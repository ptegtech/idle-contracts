# truffle-contracts
## In order to build contracts *LOCALLY*, run
1. `yarn install` or `npm install` depending on your preference
2. make sure you have testrpc running , and change `truffle.js` to point to that network. e.g. `localhost:8545`.
3. `truffle compile` to create the json contract artifacts
4. `truffle migrate` to deploy the contracts onto the network
4. `truffle test` to run the unit tests for contracts onto the network
