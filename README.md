# oyster-serverless-devtools

This repository contains helper tools for devlopers who wish to develop applications using Oyster Serverless

## Test serverless JS function locally

First, clone the `oyster-serverless-devtools` github repository and change directory to `local_tester`.
```bash
git clone https://github.com/marlinprotocol/oyster-serverless-devtools.git && cd oyster-serverless-devtools/local_tester
```

<b>Create docker image for local test server</b>

Note that, above Dockerfile accepts `TARGETARCH` as build argument which determines the target cpu. Valid values for `TARGETARCH` are `amd64`and `arm64`. Following is the sample command:

```bash
docker image build -t tester:latest --build-arg TARGETARCH=amd64 .
```

<b>Run local test server</b>

```bash
chmod +x mock_serverless.sh
sudo ./mock_serverless.sh 8090 <path-to-js-file>
```

<b> Perform the test call </b>

```bash
curl http://0:8090/ -v -d '{"num": 60000}'
```

## Serverless User Contract

### Setup

Setup the environment:
```bash
git clone https://github.com/marlinprotocol/oyster-serverless-devtools.git && cd oyster-serverless-devtools/user_contract_builder
npm install
```

Check the environment by running `npx hardhat`.
```bash
$ npx hardhat
Hardhat version 2.22.1

Usage: hardhat [GLOBAL OPTIONS] [SCOPE] <TASK> [TASK OPTIONS]

...
```
### Build

Check the sample contract at `contracts/UserSample.sol`. This can be used as base contract for developing new application contract. For Subscription example, check `contracts/SubsUser.sol`.

To compile contracts:
```bash
npx hardhat compile
```

### Deploy

Deployment script can be found at `script/deploy/UserSample.ts`. Make sure to set existent Relay and USDC contract addresses in the script. Here are the steps to deploy the contract on Arbitrum Sepolia Testnet.

Create an account using [metamask wallet](https://support.metamask.io/getting-started/getting-started-with-metamask/#how-to-install-metamask). Then, select Arbitrum Sepolia as network on Metamask extesion. Get some Arbitrum Sepolia Eths using [faucet](https://faucets.chain.link/sepolia). Make sure that account private key is accessible.

Next, follow the [guide](https://docs.arbiscan.io/getting-started/viewing-api-usage-statistics) to generate an Arbiscan API Key.

Now, create an `user_contract_builder/.env` file with following content. Fill the place holder with above generated value.
```
ARBITRUM_SEPOLIA_DEPLOYER_KEY=<deployer-account-private-key>
ARBISCAN_API_KEY=<arbiscan-api-key>
```

At the end, following command is required to run to deploy contract on Arbitrum Sepolia Testnet. This will print the deployed contract address.
```bash
npx hardhat run script/deploy/UserSample.ts --network arbs
```

Similar steps can also be followed for other chains with relevant configs (check `hardhat.config.ts`).

For Serverless example, use the script at `script/deploy/SubsUser.ts`, following the same step as above. Make sure to set existent Subscription Relay and USDC contract addresses in the script.

### Contract Verification

Hardhat provides contract verification, allowing users to interact directly with contracts on Arbiscan. It displays all contract transactions and event details in a human-readable format.

Prepare a file named `arg.js` as illustrated below. This file contains the original constructor argument values used while deploying the contract.
```javascript
module.exports = [
    "0x56EC16763Ec62f4EAF9C7Cfa09E29DC557e97006",
    "0x186A361FF2361BAbEE9344A2FeC1941d80a7a49C",
    "0xf90e66d1452be040ca3a82387bf6ad0c472f29dd"
];
```
Finally, execute the following command to get the contract verified.
```bash
npx hardhat verify --network arbs --constructor-args arg.js <contract_address>
```
