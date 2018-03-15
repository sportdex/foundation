import utils from 'ethereumjs-util';
import web3Utils from 'web3-utils';

const DelegatableTokenMock = artifacts.require("DelegatableTokenMock");

// The hardcoded private key for accounts[0] in testrpc, used for signing
const PRIVATE_KEY = Buffer.from('c87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3', 'hex');

contract('DelegatableToken', accounts => {
  const supply = 100000;
  let token;

  before(async () => {
    token = await DelegatableTokenMock.new(supply);
  });

  it('should delegate transfer', async () => {
    const from = accounts[0];
    const delegate = accounts[1];
    const to = accounts[2];
    const amount = supply / 2;
    const nonce = 100;
    assert.equal(await token.balanceOf(from), supply);

    const msg = web3Utils.soliditySha3(
      { type: 'address', value: token.address }, 
      { type: 'address', value: delegate },
      { type: 'address', value: from },
      { type: 'address', value: to },
      { type: 'uint256', value: amount },
      { type: 'uint256', value: nonce },
    );
    const hashed = Buffer.from(msg.replace('0x', ''), 'hex');
    let { r, s, v } = utils.ecsign(hashed, PRIVATE_KEY);
    const sig = utils.bufferToHex(Buffer.concat([r, s, Buffer.from([v])]));
    await token.delegateTransfer(from, to, amount, nonce, sig, { from: delegate });

    const event = token.DelegatedTransfer();
    event.get((error, logs) => {
      assert.equal(error, null);
      const event = logs[0].args;
      assert.equal(event.delegate, delegate);
      assert.equal(event.from, from);
      assert.equal(event.to, to);
      assert.equal(event.amount, amount);
    });
    assert.equal(await token.balanceOf(from), amount);
    assert.equal(await token.balanceOf(to), amount);

    try {
      await token.delegateTransfer(from, to, amount, nonce, sig, { from: delegate });
      assert.fail();
    } catch (e) {}
    assert.equal(await token.balanceOf(from), amount);
    assert.equal(await token.balanceOf(to), amount);
  });
});
