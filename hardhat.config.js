require('dotenv').config()
require('@nomiclabs/hardhat-ethers')
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  networks: {
    goerli: {
      url: process.env.GOERLI_NODE_URL,
      accounts: [process.env.GOERLI_PRIVATE_KEY]
    }
  },
  solidity: {
    compilers: [
      {
        version: '0.8.7',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
    ]
  }
}
