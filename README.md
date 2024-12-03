# SuperfluidRepo

Superfluid を調査・学習するためのリポジトリです。

## 動かし方

- インストール

  ```bash
  yarn
  ```

- QuickStart 用のコントラクト関連

  - デプロイ

    ```bash
    yarn backend deploy --network opSepolia
    ```

    ```bash
      ======================= start =========================
      FlowSender Contract deployed to 0x9370C082dabFb847b6F4d7b3Cf9c001aDCC85d8d

      Successfully submitted source code for contract
      contracts/FlowSender.sol:FlowSender at 0x9370C082dabFb847b6F4d7b3Cf9c001aDCC85d8d
      for verification on the block explorer. Waiting for verification result...

      Successfully verified contract FlowSender on Etherscan.
      https://sepolia-optimism.etherscan.io/address/0x9370C082dabFb847b6F4d7b3Cf9c001aDCC85d8d#code
      ======================== end  ========================
      ✨  Done in 21.13s.
    ```

## distribution させる方法(メモ)

1. pool を作る。

2. 分配するメンバーを設定させる。

3. Pool コントラクトに SuperToken を送る。

4. distributionFlow メソッドを呼び出す。

### 参考文献

1. [Superfluid Docs](https://www.superfluid.finance/)
2. [Superfluid - Youtube](https://www.youtube.com/SuperfluidHQ)
3. [Superfluid - Dashboard](https://app.superfluid.finance/?utm_source=coinbase&utm_medium=web)
4. [Superfluid - QuickStart](https://docs.superfluid.finance/superfluid/developers/quickstart)
5. [Superfluid - GitHub](https://github.com/superfluid-finance)
6. [Test Super Token Faucet](https://docs.superfluid.finance/superfluid/developers/super-tokens/super-token-faucet)
7. [Super Tokens Factory Contract](https://docs.superfluid.finance/docs/protocol/super-tokens/guides/deploy-super-token/deploy-wrapped-super-token)
8. [contract-addresses](https://docs.superfluid.finance/docs/protocol/contract-addresses)
9. [Super Token Deploy Page](https://v2.docs.superfluid.finance/docs/protocol/super-tokens/guides/deploy-super-token/deploy-pure-super-token)
10. [Superfluid Dashboard](https://app.superfluid.finance/)
11. [Create, Update, and Delete Flows](https://docs.superfluid.finance/docs/protocol/money-streaming/guides/create-update-delete-flow)
12. [Subgraph Fake DAI](https://explorer.superfluid.finance/subgraph?_network=eth-sepolia&_query=CiAgICAgICAgICAgICAgICAgIHF1ZXJ5ICgkaWQ6IElEISkgewogICAgICAgICAgICAgICAgICAgIHRva2VuKGlkOiAkaWQpIHsKICAgICAgICAgICAgICAgICAgICAgIG5hbWUKICAgICAgICAgICAgICAgICAgICAgIHN5bWJvbAogICAgICAgICAgICAgICAgICAgICAgaXNTdXBlclRva2VuCiAgICAgICAgICAgICAgICAgICAgICBpc0xpc3RlZAogICAgICAgICAgICAgICAgICAgICAgdW5kZXJseWluZ0FkZHJlc3MKICAgICAgICAgICAgICAgICAgICAgIGRlY2ltYWxzCiAgICAgICAgICAgICAgICAgICAgICBjcmVhdGVkQXRUaW1lc3RhbXAKICAgICAgICAgICAgICAgICAgICAgIGNyZWF0ZWRBdEJsb2NrTnVtYmVyCiAgICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICA=&_variables=eyAiaWQiOiAiMHg5Y2UyMDYyYjA4NWEyMjY4ZThkNzY5ZmZjMDQwZjY2OTIzMTVmZDJjIiB9)
