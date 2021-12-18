const hre = require("hardhat");

async function main() {
  const LegendNFT = await hre.ethers.getContractFactory("LegendNFT");
  const legendNFT = await LegendNFT.deploy();

  await legendNFT.deployed();

  console.log("NFT deployed to:", legendNFT.address);

  let txn = await legendNFT.makeLegendNFT()
  await txn.wait()

  txn = await legendNFT.makeLegendNFT()
  await txn.wait()

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
