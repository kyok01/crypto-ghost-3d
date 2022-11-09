import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

// ALCHEMY API KEY
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY

// GOERLI PRIVATE KEY
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY

const config: HardhatUserConfig = {
  solidity: "0.8.12",
  networks: {
    goerli: {
      url: ALCHEMY_API_KEY,
      accounts: [`${GOERLI_PRIVATE_KEY}`],
    },
    hardhat: {
      blockGasLimit: 30_000_000,
      allowUnlimitedContractSize: true
    }
  }
};

export default config;
