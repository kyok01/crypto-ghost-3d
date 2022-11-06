import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
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

        const transaction4 = await contract.readGhost(
            1,
            12
        );
        console.log(transaction4);
        console.log("ゴーストのデータとOBJファイルを取得できました。")

        const transaction5 = await contract.getAllGhost();
        console.log(transaction5);
        console.log("ゴーストのデータを全て取得できました。")


      //   expect(await lock.unlockTime()).to.equal(unlockTime);
    });
});
