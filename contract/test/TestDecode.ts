import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";


describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployDecodeObj() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    // const DecodeObj = await ethers.getContractFactory("DecodeObj");
    const DecodeObj = await ethers.getContractFactory("DecodeObjTest");
    const contract = await DecodeObj.deploy();

    return { contract, owner, otherAccount };
  }

    it("DecodeObj", async function () {
      const { contract, owner } = await loadFixture(deployDecodeObj);

    //   const transaction1 = await contract.createObjData(12, 6, [500000, 866025, 0, 866026, 500000, 0, 1, 0, 0], [2582, 9636, 692, 6947, 6947, 1862, 9351, 2506, 2506]);
      const transaction1 = await contract.createObjData(12, 6,
        ["0.5", "0.866025", "0.0", "0.433013", "0.866025", "0.25", "0.25", "0.866025", "0.433013", "0.866026", "0.5", "0.0", "0.750001", "0.5", "0.433013", "0.433013", "0.5", "0.750001", "1.0", "0.0", "0.0", "0.866025", "0.0", "0.5", "0.5", "0.0", "0.866025"],
        ["0.2582", "0.9636", "0.0692", "0.189", "0.9636", "0.189", "0.0692", "0.9636", "0.2582", "0.6947", "0.6947", "0.1862", "0.5085", "0.6947", "0.5086", "0.1861", "0.6947", "0.6947", "0.9351", "0.2506", "0.2506", "0.6845", "0.2506", "0.6846", "0.2505", "0.2506", "0.9351"]);
      console.log(transaction1);
      console.log("transaction1は通りました。")

      const transaction2 = await contract.createObjFile(12);
      console.log(transaction2);
      console.log("transaction2は通りました。")


      //   expect(await lock.unlockTime()).to.equal(unlockTime);
  });
});
