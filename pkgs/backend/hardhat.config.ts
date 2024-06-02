import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
import fs from "fs";
import "hardhat-gas-reporter";
import {HardhatUserConfig} from "hardhat/types";
import path from "path";

dotenv.config();

const {PRIVATE_KEY, GAS_REPORT, COINMARKETCAP_API_KEY, OP_SCAN_API_KEY} =
  process.env;

const SKIP_LOAD = process.env.SKIP_LOAD === "true";
if (!SKIP_LOAD) {
  const taskPaths = [""];
  taskPaths.forEach((folder) => {
    const tasksPath = path.join(__dirname, "tasks", folder);
    fs.readdirSync(tasksPath)
      .filter((_path) => _path.includes(".ts"))
      .forEach((task) => {
        require(`${tasksPath}/${task}`);
      });
  });
}

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    opSepolia: {
      url: "https://sepolia.optimism.io",
      chainId: 11155420,
      accounts: [`${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: {
      opSepolia: OP_SCAN_API_KEY!,
    },
    customChains: [
      {
        network: "opSepolia",
        chainId: 11155420,
        urls: {
          apiURL: "https://api-sepolia-optimistic.etherscan.io/api",
          browserURL: "https://sepolia-optimism.etherscan.io/",
        },
      },
    ],
  },
  gasReporter: {
    enabled: GAS_REPORT ? true : false,
    currency: "JPY",
    gasPrice: 20,
    token: "ETH",
    coinmarketcap: COINMARKETCAP_API_KEY,
    gasPriceApi:
      "https://api.etherscan.io/api?module=proxy&action=eth_gasPrice",
  },
};

export default config;
