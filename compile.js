const path = require("path");
const solc = require("solc");
const fs = require("fs-extra");

// Delete entire build path
const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, "contracts", "HeroOwnership.sol");
const source = fs.readFileSync(campaignPath, "utf8");

const input = {
  language: "Solidity",
  sources: {
    "HeroOwnership.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

const output = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  "HeroOwnership.sol"
];

fs.ensureDirSync(buildPath);

for (const contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, `${contract}.json`),
    output[contract]
  );
}
