const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("test", () => {
    let owner;
    let buyer;
    let iYHExtension;
    let deployedOwner;
    let UniversalERC20;
    let universalERC20;
    beforeEach(async () => {
        [owner, buyer] = await ethers.getSigners();
        const IYHExtension = await ethers.getContractFactory("IYHExtension");
        iYHExtension = await IYHExtension.deploy();
        deployedOwner = await iYHExtension.owner();

        UniversalERC20 = await ethers.getContractFactory("contracts/v2/libs/UniversalERC20.sol:UniversalERC20");
        universalERC20 = await UniversalERC20.deploy();
        await universalERC20.deployed();
        await universalERC20.universalTransfer(universalERC20, buyer, 100000);
    })

    it("owner should be equal deployed owner", () => {
        expect(deployedOwner).to.equal(owner.address);;
    });

    it("addTransaction", async () => {
        await iYHExtension.addTransaction(owner.address, 1);
        expect(Number(await iYHExtension.userTransactions(owner.address, 0))).to.equal(1);
        expect(Number(await iYHExtension.userAverage(owner.address))).to.equal(1);
    })

    it("receivePayment1", async () => {
        await iYHExtension.receivePayment(universalERC20.address, 1, "1", "1", "0x11");
        expect(Number(await iYHExtension.userTransactions(owner.address, 0))).to.equal(1);
        expect(Number(await iYHExtension.userAverage(owner.address))).to.equal(1);
    })

    it("receivePayment2", async () => {
        await iYHExtension.receivePayment(universalERC20.address, 1, "1", "1", "0x11");
        expect(Number(await universalERC20.universalBalanceOf(universalERC20.address, owner.address))).to.equal(1);
    })
});