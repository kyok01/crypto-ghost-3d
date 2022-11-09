import { ethers } from "hardhat";

const hre = require("hardhat");

const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const DecodeObjFactory = await hre.ethers.getContractFactory("DecodeObjTest");
  const DecodeObjFactoryContract = await DecodeObjFactory.deploy();
  const contract = await DecodeObjFactoryContract.deployed();

  console.log("Contract deployed to: ", contract.address);
  console.log("owner address: ", owner.address);
  const transaction1 = await contract.addVectorData(
    12, 6,
    ["0.5", "0.866025", "0.0", "0.433013", "0.866025", "0.25", "0.25", "0.866025", "0.433013", "0.866026", "0.5", "0.0", "0.750001", "0.5", "0.433013", "0.433013", "0.5", "0.750001", "1.0", "0.0", "0.0", "0.866025", "0.0", "0.5", "0.5", "0.0", "0.866025"],
    ["0.2582", "0.9636", "0.0692", "0.189", "0.9636", "0.189", "0.0692", "0.9636", "0.2582", "0.6947", "0.6947", "0.1862", "0.5085", "0.6947", "0.5086", "0.1861", "0.6947", "0.6947", "0.9351", "0.2506", "0.2506", "0.6845", "0.2506", "0.6846", "0.2505", "0.2506", "0.9351"]
);
console.log(transaction1);
console.log("VectorDataにデータ登録できました。");

const transaction3 = await contract.writeGhost(
    "First Ghost",
    "First Ghost Description",
    "First Ghost Material Data",
    12
);
console.log(transaction3);
console.log("ゴーストのデータを追加できました。")

const createObjFile = await contract.createObjFile(12);
console.log(createObjFile);
console.log("createObjFile")

const transaction4 = await contract.readGhost(
    1,
    12
);
console.log(transaction4);
console.log("ゴーストのデータとOBJファイルを取得できました。")

const transaction5 = await contract.getAllGhost();
console.log(transaction5);
console.log("ゴーストのデータを全て取得できました。")
console.log("Contract deployed to: ", contract.address);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
