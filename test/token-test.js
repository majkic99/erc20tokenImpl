const { expect } = require("chai");
const { ethers } = require("ethers");

const nebojsaTokenJson = require("../artifacts/contracts/NebojsaToken.sol/NebojsaToken.json");

let abi = nebojsaTokenJson.abi;
let bytecode = nebojsaTokenJson.bytecode;
const url = "https://eth-rinkeby.alchemyapi.io/v2/DPqv31gQz2j4lTUXOkUBK4obsGE9cZc1";
let provider = new ethers.providers.JsonRpcProvider(url);
let walletNoProvider = ethers.Wallet.createRandom();
let wallet = walletNoProvider.connect(provider);


describe("ERC20Token", function(){
    it("Deploy good", async function(){
        const NebojsaTokenFactory =  new ethers.ContractFactory(abi, bytecode, wallet);
        const nebojsaToken = await NebojsaTokenFactory.deploy();

        console.log(nebojsaToken.address);
        await nebojsaToken.deployed();
        expect (await nebojsaToken.name().to.equal("NebojsaToken"));
        expect (await nebojsaToken.symbol().to.equal("NBTK"));
        totalSupply = await nebojsaToken.totalSupply();
        expect(totalSupply.to.equal(0));
        decimals = await nebojsaToken.decimals();
        expect(decimals.to.equal(8));

  
    });
})