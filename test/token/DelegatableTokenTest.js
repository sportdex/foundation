import utils from 'ethereumjs-util';
import web3Utils from 'web3-utils';

const DelegatableTokenMock = artifacts.require("DelegatableTokenMock");
const SportDexToken = artifacts.require("SportDexToken");

// The hardcoded private key for accounts[0] in testrpc, used for signing
const PRIVATE_KEY = Buffer.from('c87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3', 'hex');

function signMethodCall(callerAddress, contractAddress, methodName, methodArgs) {
  const hash = web3Utils.sha3(`${methodName}(${methodArgs.map(arg => arg.type).join(',')})`).substr(0, 10);
  const sigArgs = [
    { type: 'address', value: callerAddress }, 
    { type: 'address', value: contractAddress },
    { type: 'bytes4', value: hash },
    ...methodArgs,
  ];
  const message = web3Utils.soliditySha3(...sigArgs);
  const messageHex = Buffer.from(message.replace('0x', ''), 'hex');
  const { v, r, s } = utils.ecsign(messageHex, PRIVATE_KEY);
  return { v, r: utils.bufferToHex(r), s: utils.bufferToHex(s) };
}

function assertEvent(event, checker) {
  event.get((error, logs) => {
    assert.equal(error, null);
    checker(logs);
  });
}

async function assertFailure(p) {
  try {
    if (typeof p === 'function') {
      p = p();
    }
    await p;
    assert.fail();
  } catch (e) {}
}

async function testDelegateTransfer(token, accounts) {
  const supply = (await token.totalSupply()).toNumber();
  const from = accounts[0];
  const delegate = accounts[1];
  const to = accounts[2];
  const amount = supply / 2;
  const nonce = 100;
  assert.equal(await token.balanceOf(from), supply);

  let { v, r, s } = signMethodCall(
    delegate, token.address,
    'delegatedTransfer', [
      { type: 'address', value: from },
      { type: 'address', value: to },
      { type: 'uint256', value: amount },
      { type: 'uint256', value: nonce },
    ],
  );
  await token.delegatedTransfer(from, to, amount, nonce, v, r, s, { from: delegate });

  assertEvent(token.DelegatedTransfer(), logs => {
    const event = logs[0].args;
    assert.equal(event.delegate, delegate);
    assert.equal(event.from, from);
    assert.equal(event.to, to);
    assert.equal(event.amount, amount);
  });
  assert.equal(await token.balanceOf(from), amount);
  assert.equal(await token.balanceOf(to), amount);

  await assertFailure(token.delegatedTransfer(from, to, amount, nonce, v, r, s, { from: delegate }));
  assert.equal(await token.balanceOf(from), amount);
  assert.equal(await token.balanceOf(to), amount);
}

async function testDelegateApprove(token, accounts) {
  const supply = (await token.totalSupply()).toNumber();
  const owner = accounts[0];
  const delegate = accounts[1];
  const spender = accounts[2];
  const amount = supply / 2;
  const nonce = 100;

  let { v, r, s } = signMethodCall(
    delegate, token.address,
    'delegatedApprove', [
      { type: 'address', value: owner },
      { type: 'address', value: spender },
      { type: 'uint256', value: amount },
      { type: 'uint256', value: nonce },
    ],
  );
  await token.delegatedApprove(owner, spender, amount, nonce, v, r, s, { from: delegate });

  assertEvent(token.DelegatedApprove(), logs => {
    const event = logs[0].args;
    assert.equal(event.delegate, delegate);
    assert.equal(event.owner, owner);
    assert.equal(event.spender, spender);
    assert.equal(event.amount, amount);
  });
  assert.equal(await token.allowance(owner, spender), amount);

  const receiver = accounts[3];
  await token.transferFrom(owner, receiver, amount / 4, { from: spender });
  assert.equal(await token.allowance(owner, spender), amount * 3 / 4);
  assert.equal(await token.balanceOf(owner), supply * 7 / 8);
  assert.equal(await token.balanceOf(receiver), amount / 4);
}

contract('DelegatableToken', accounts => {
  it('should delegate transfer', async () => {
    const token = await DelegatableTokenMock.new(100000);
    await testDelegateTransfer(token, accounts);
  });
  it('should delegate approve', async () => {
    const token = await DelegatableTokenMock.new(100000);
    await testDelegateApprove(token, accounts);
  });
});

contract('SportDexToken', accounts => {
  it('should delegate transfer', async () => {
    const token = await SportDexToken.new();
    await assertFailure(() => testDelegateTransfer(token, accounts));
    await token.addDelegate(accounts[1]);
    await testDelegateTransfer(token, accounts);
  });
  it('should delegate approve', async () => {
    const token = await SportDexToken.new();
    await assertFailure(() => testDelegateApprove(token, accounts));
    await token.addDelegate(accounts[1]);
    await testDelegateApprove(token, accounts);
  });
});
