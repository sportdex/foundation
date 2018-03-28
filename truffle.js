require('@babel/register');
require('dotenv').config();

const PrivateKeyProvider = require('truffle-privatekey-provider');
const privateKey = process.env.PRIVATE_KEY;

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 9545,
      network_id: '*',
    },
    rinkeby: {
      provider: new PrivateKeyProvider(privateKey, 'https://rinkeby.infura.io'),
      network_id: 4,
      gas: 4698712,
    },
    mainnet: {
      provider: new PrivateKeyProvider(privateKey, 'https://mainnet.infura.io'),
      network_id: 1,
      gas: 5000000,
    },
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
};
