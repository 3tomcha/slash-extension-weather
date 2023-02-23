const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("test", () => {
    let owner;
    let buyer;
    let iYHExtension;
    let deployedOwner;
    let erc20Demo;
    beforeEach(async () => {
        [owner, buyer] = await ethers.getSigners();
        const IYHExtension = await ethers.getContractFactory("IYHExtension");
        iYHExtension = await IYHExtension.deploy();
        deployedOwner = await iYHExtension.owner();

        const ERC20Demo = await ethers.getContractFactory("ERC20Demo");
        erc20Demo = await ERC20Demo.deploy(100000);
        await erc20Demo.deployed();
        await erc20Demo.transfer(buyer.address, 100000);
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
        await iYHExtension.receivePayment(erc20Demo.address, 1, "1", "1", "0x11");
        expect(Number(await iYHExtension.userTransactions(owner.address, 0))).to.equal(1);
        expect(Number(await iYHExtension.userAverage(owner.address))).to.equal(1);
    })

    it("receivePayment2", async () => {
        await iYHExtension.receivePayment(erc20Demo.address, 1, "1", "1", "0x11");
        expect(Number(await erc20Demo.balanceOf(owner.address))).to.equal(1);
    })
});