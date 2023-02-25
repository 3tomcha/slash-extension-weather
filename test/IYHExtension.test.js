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

    it("buyer balance should be 100000", async () => {
        expect(Number(await erc20Demo.balanceOf(buyer.address))).to.equal(100000);
    });

    it("addTransaction", async () => {
        await iYHExtension.addTransaction(owner.address, 1);
        expect(Number(await iYHExtension.userTransactions(owner.address, 0))).to.equal(1);
        expect(Number(await iYHExtension.userAverage(owner.address))).to.equal(1);
    })

    it("receivePayment1", async () => {
        await erc20Demo.approve(buyer.address, 1);
        await iYHExtension.connect(buyer).receivePayment(erc20Demo.address, 1, "1", "1", "0x11");
        expect(Number(await iYHExtension.userTransactions(owner.address, 0))).to.equal(1);
        expect(Number(await iYHExtension.userAverage(owner.address))).to.equal(1);
    })
});