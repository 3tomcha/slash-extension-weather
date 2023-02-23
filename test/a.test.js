const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("test", () => {
    let owner;
    let iYHExtension;
    let deployedOwner;
    beforeEach(async () => {
        [owner] = await ethers.getSigners();
        const IYHExtension = await ethers.getContractFactory("IYHExtension");
        iYHExtension = await IYHExtension.deploy();
        deployedOwner = await iYHExtension.owner();

        const UniversalERC20 = await ethers.getContractFactory("contracts/v2/libs/UniversalERC20.sol:UniversalERC20");
        universalERC20 = await UniversalERC20.deploy();
    })

    it("owner should be equal deployed owner", () => {
        expect(deployedOwner).to.equal(owner.address);;
    });

    it("addTransaction", async () => {
        await iYHExtension.addTransaction(owner.address, 1);
        expect(Number(await iYHExtension.userTransactions(owner.address, 0))).to.equal(1);
        expect(Number(await iYHExtension.userAverage(owner.address))).to.equal(1);
    })

    it("emit", async () => {
        await iYHExtension.addTransaction(owner.address, 1);
        await iYHExtension.receivePayment(universalERC20.address, 1, undefined, undefined, undefined);
        // expect(universalERC20.balanceOf(owner)).to.equal(1);
    })
});