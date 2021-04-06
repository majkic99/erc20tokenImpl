const { expect } = require("chai");


describe("ERC20Token", function(){

    let NebojsaTokenFactory;
    let nebojsaToken;
    let nebojsaTokenAsUser;

    beforeEach(async function(){
        accounts = await ethers.getSigners();
        NebojsaTokenFactory = await ethers.getContractFactory("NebojsaToken");
        nebojsaToken = await NebojsaTokenFactory.deploy();
        nebojsaTokenAsUser = [];
        for (let i = 0; i < 10; i++){
            nebojsaTokenAsUser[i] = nebojsaToken.connect(accounts[i]);
        }
    });

    describe("Deployment", function(){

        it("Deployment successful", async function(){
            await nebojsaToken.deployed();
            expect(nebojsaToken.address).not.to.equal(0);
            expect (await nebojsaToken.name()).to.equal("NebojsaToken");
            expect (await nebojsaToken.symbol()).to.equal("NBTK");
            totalSupply = (await nebojsaToken.totalSupply());
            expect(totalSupply).to.equal(0);
            decimals = (await nebojsaToken.decimals());
            expect(decimals).to.equal(8);
            
        });

    });

    describe("Transactions", function(){
        it("Faucet testing", async function(){
            await nebojsaToken.deployed();
            //Getting tokens for the first time
            for (let i = 0; i < 10; i++){
                await nebojsaTokenAsUser[i].faucet(10000000);
                expect(await nebojsaToken.balanceOf(accounts[i].address)).to.equal(10000000);
            }
            for (let i = 0; i < 10; i++){
                //await expect(nebojsaToken.receivedFreeTokens.call(accounts[i].address)).to.equal(true);
            }
            //Second time request should always fail
            for (let i = 0; i < 10; i++){
                await expect(nebojsaTokenAsUser[i].faucet(50000000))
                .to.be.revertedWith('Already received free tokens');
                expect(await nebojsaToken.balanceOf(accounts[i].address)).to.equal(10000000);
            }
        });
    })

    describe("Transfers", function(){

        it("Transfers", async function(){
            await nebojsaToken.deployed();
            for (let i = 0; i < 10; i++){
                await nebojsaTokenAsUser[i].faucet(10000000);
                expect(await nebojsaToken.balanceOf(accounts[i].address)).to.equal(10000000);
            }
            
            for (let i = 0; i < 10; i += 2){
                await nebojsaTokenAsUser[i].transfer(accounts[i+1].address, 10000000);
            }
            for (let i = 0; i < 10; i++){
                if (i % 2 == 0){
                    expect (await nebojsaToken.balanceOf(accounts[i].address)).to.equal(0);
                }else{
                    expect (await nebojsaToken.balanceOf(accounts[i].address)).to.equal(10000000*2);
                }
            }
        });
    });


    

})