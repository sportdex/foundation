require('@babel/register');

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 9545,
      network_id: '*',
    },
    // Start geth by: geth --rinkeby --rpc --rpcapi db,eth,net,web3,protocol console
    // and unlock the from account by: personal.unlockAccount(address)
    rinkeby: {
      host: 'localhost',
      port: 8545,
      from: '0xA711642Dec94A673f0E3707010311C531E6F17fB',
      network_id: 4,
      gas: 4698712,
    },
    mainnet: {
      network_id: 1,
    },
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
};
