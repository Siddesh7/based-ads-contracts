const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Get the contract factories
  const NFT = await hre.ethers.getContractFactory("BasedAdPool");

  // Set the initial owner address

  // Deploy the NFT contract with the initial owner
  const nft = await NFT.deploy("0x1eff3dd78f4a14abfa9fa66579bd3ce9e1b30529");

  // Log deployment information
  console.log("NFT contract deployed to:", nft.address);
}

// Run the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
