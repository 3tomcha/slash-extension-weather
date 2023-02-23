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
    })

    it("owner should be equal deployed owner", () => {
        expect(deployedOwner).to.equal(owner.address);;
    });
});