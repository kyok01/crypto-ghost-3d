import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.12",
  networks: {
    hardhat: {
      blockGasLimit: 30_000_000,
    }
  }
};

export default config;
