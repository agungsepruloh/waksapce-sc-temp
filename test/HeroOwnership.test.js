const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());

const compiledHeroOwnership = require("../build/HeroOwnership.json");

let accounts;
let firstAccount, secondAccount, thirdAccount;
let factory;

beforeEach(async () => {
  // Get a list of accounts
  accounts = await web3.eth.getAccounts();

  // Get the firstAccount
  [firstAccount, secondAccount, thirdAccount] = accounts;

  factory = await new web3.eth.Contract(compiledHeroOwnership.abi)
    .deploy({ data: compiledHeroOwnership.evm.bytecode.object })
    .send({ from: firstAccount, gas: "3000000" });
});

describe("HeroOwnership", () => {
  it("Deploys a factory and a factory", () => {
    assert.ok(factory.options.address);
  });

  it("marks caller as the factory owner", async () => {
    const owner = await factory.methods.owner().call();
    assert.equal(firstAccount, owner);
  });

  it("allows to create a new hero", async () => {
    const name = "Hero 0";

    await factory.methods
      .createRandomHero(name)
      .send({ from: firstAccount, gas: "1000000" });

    const firstHero = await factory.methods.heroes(0).call();
    assert.equal(name, firstHero["name"]);
  });

  it("marks creator as the hero owner", async () => {
    const name = "Hero 0";

    await factory.methods
      .createRandomHero(name)
      .send({ from: secondAccount, gas: "1000000" });

    const ownerHero = await factory.methods.ownerOf(0).call();
    assert.equal(secondAccount, ownerHero);
  });
});
