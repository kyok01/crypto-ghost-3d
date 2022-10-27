import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployTokenFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("MyToken");
    const contract = await Token.deploy();

    const ReturnMaxTest = await ethers.getContractFactory("ReturnMaxTest");
    const contract2 = await ReturnMaxTest.deploy();

    return { contract, contract2,owner, otherAccount };
  }

  describe("Mint", function () {
    it("Safe Mint", async function () {
      const { contract, owner } = await loadFixture(deployTokenFixture);

      const transaction = await contract.safeMint(
        owner.address,
        `IyBCbGV`
      );
      console.log(transaction);

      //   expect(await lock.unlockTime()).to.equal(unlockTime);
    });

    it("ReturnMax", async function () {
      const { contract2, owner } = await loadFixture(deployTokenFixture);

      const transaction = await contract2.tokenUri();
      console.log(transaction);

      //   expect(await lock.unlockTime()).to.equal(unlockTime);
    });
  });
});
