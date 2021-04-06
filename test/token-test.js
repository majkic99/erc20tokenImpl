const { expect } = require("chai");

describe("ERC20Token", function(){
    it("Deploy good", async function(){
        const NebojsaToken = await ethers.getContractFactory("NebojsaToken");
        const nebojsaToken = await NebojsaToken.deploy();

        await nebojsaToken.deployed();
        
        console.log(nebojsaToken.address);
        expect (await nebojsaToken.name()).to.equal("NebojsaToken");
        expect (await nebojsaToken.symbol()).to.equal("NBTK");
        totalSupply = (await nebojsaToken.totalSupply());
        expect(totalSupply).to.equal(0);
        decimals = (await nebojsaToken.decimals());
        expect(decimals).to.equal(8);
        
    });
})