require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    baseSepolia: {
      url: `https://base-mainnet.g.alchemy.com/v2/2zwf6w27OIBUfAr0b58DmJckPEIXJ1OO`,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
