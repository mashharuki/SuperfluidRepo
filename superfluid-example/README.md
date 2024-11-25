## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test -vvv
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Deploy Contracts

before

```bash
source .env
```

```bash
yarn deploy:PureSuperToken --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
```

実際にデプロイした SuperToken コントラクト

[0x5Eb49590d8521Ca45082c5Be9622BFddd1d04D7c](https://sepolia.etherscan.io/address/0x5Eb49590d8521Ca45082c5Be9622BFddd1d04D7c)

```bash
yarn deploy:Counter --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
```

```bash
yarn deploy:AdSpotContract --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
```

実際にデプロイした AdSpotContract コントラクト

[0x29Eed2c5D0313f4052a1Bd0eFbE8725DA753fA2B](https://sepolia.etherscan.io/address/0x29Eed2c5D0313f4052a1Bd0eFbE8725DA753fA2B)

デプロイ時に NFT を発行する。

[Pool Admin NFT](https://sepolia.etherscan.io/token/0x1bd3b6522102f9ea406807f8ecaeb2d96278a83f)

FlowSender をデプロイする。

```bash
yarn deploy:FlowSender --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
```

[0x09601578E73ebf6744C7aAd6455Fa4B9870eBdF9](https://sepolia.etherscan.io/address/0x09601578E73ebf6744C7aAd6455Fa4B9870eBdF9)

FlowSpiltter をデプロイする。

```bash
yarn deploy:FlowSplitter --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
```

[0x9c66778e867d4346a18c221534c6113b73a055bf](https://sepolia.etherscan.io/address/0x9c66778e867d4346a18c221534c6113b73a055bf)

DistributionContract をデプロイする。

```bash
yarn deploy:DistributionContract --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
```

[0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301](https://sepolia.etherscan.io/address/0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301)

### Cast

```shell
$ cast <subcommand>
```

increment する

```bash
cast send 0xd52DD0DcF92ff5714402eF9f3CB5f8A75bDcCf37 "increment()" --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
```

number の値を読み取る

```bash
cast call 0xd52DD0DcF92ff5714402eF9f3CB5f8A75bDcCf37 "number" --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

SuperToken の残高を取得する。

```bash
cast --to-dec $(cast call 0x5eb49590d8521ca45082c5be9622bfddd1d04d7c "balanceOf(address owner)" 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY)
```

トークン名とシンボル名を取得する。

```bash
cast --to-ascii $(cast call 0x5eb49590d8521ca45082c5be9622bfddd1d04d7c "name()" --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY)
```

```bash
cast --to-ascii $(cast call 0x5eb49590d8521ca45082c5be9622bfddd1d04d7c "symbol()" --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY)
```

500 SuperToken を送信する。

```bash
cast send 0x5eb49590d8521ca45082c5be9622bfddd1d04d7c "transfer(address,uint256)" 0x29Eed2c5D0313f4052a1Bd0eFbE8725DA753fA2B 50000000000000000000 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

createFlow を行う。

```bash
cast send 0x5eb49590d8521ca45082c5be9622bfddd1d04d7c "transfer(address,uint256)" 0x29Eed2c5D0313f4052a1Bd0eFbE8725DA753fA2B 1000 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

selfRegister を実行する。

```bash
cast send 0x29Eed2c5D0313f4052a1Bd0eFbE8725DA753fA2B "selfRegister(bool,bool,bool)" true true true --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

gainDAI を行う。

```bash
cast send 0x09601578E73ebf6744C7aAd6455Fa4B9870eBdF9 "gainDaiX()" --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

createFlow を行う。

```bash
cast send 0x09601578E73ebf6744C7aAd6455Fa4B9870eBdF9 "createStream(int96, address)" 10 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

updateFlow を行う。

```bash
cast send 0x09601578E73ebf6744C7aAd6455Fa4B9870eBdF9 "updateStream(int96, address)" 1000 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

deleteFlow を行う。

```bash
cast send 0x09601578E73ebf6744C7aAd6455Fa4B9870eBdF9 "deleteStream(address)" 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

readFlowRate で指定したアドレスの FlowRate の値を読み取る。

```bash
cast --to-dec $(cast call 0x09601578E73ebf6744C7aAd6455Fa4B9870eBdF9 "readFlowRate(address)" 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY)
```

DistributionContract で gainDaiX する。

```bash
cast send 0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301 "gainDaiX()" --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

cretePool を行う。

```bash
yarn createPool --rpc-url $SEPOLIA_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY
```

createStreamToPool を行う。

```bash
cast send 0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301 "createStreamToPool" 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072 100 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

updateMemberUnits を行う。

```bash
cast send 0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301 "updateMemberUnits" 0x1431ea8af860C3862A919968C71f901aEdE1910E 3 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

distributeFlow を行う。

```bash
cast send 0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301 "distributeFlow" 10 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

distribute を行う。

```bash
cast send 0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301 "distribute" 1000 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

repmapping の設定は以下で確認

```bash
forge remappings
```

## FlowSplitter コントラクト

## 関連コントラクト

[Token Super fDAI Fake Token Sepolia](https://sepolia.etherscan.io/address/0x9ce2062b085a2268e8d769ffc040f6692315fd2c)
