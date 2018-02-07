module.exports = {
  networks: {
    dev: {
      host: 'localhost',
      port: 9545,
      network_id: '*',
    },
    test: {
      host: 'localhost',
      port: 8545,
      from: '0xA711642Dec94A673f0E3707010311C531E6F17fB',
      network_id: 4,
      gas: 4612388,
    },
  },
};