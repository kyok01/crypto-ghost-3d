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

    const DecodeObj = await ethers.getContractFactory("DecodeObj");
    const contract = await DecodeObj.deploy();

    return { contract, owner, otherAccount };
  }

    it("DecodeObj", async function () {
      const { contract, owner } = await loadFixture(deployDecodeObj);

      const transaction1 = await contract.createObjData(12, 6, [500000, 866025, 0, 866026, 500000, 0, 1, 0, 0], [2582, 9636, 692, 6947, 6947, 1862, 9351, 2506, 2506]);
      console.log(transaction1);
      console.log("transaction1は通りました。")

      const transaction2 = await contract.createObjFile(12);
      console.log(transaction2);

      //   expect(await lock.unlockTime()).to.equal(unlockTime);
  });
});
