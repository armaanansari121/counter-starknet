# Starknet Counter Contract

A simple Starknet smart contract that implements a counter with security features:
- Owner-controlled incrementing
- Kill switch for emergency stops
- Event emission for tracking changes

## Features

- **Counter Operations**: Get and increment counter values
- **Access Control**: Only contract owner can increment
- **Safety**: Integrated kill switch for emergency stops
- **Transparency**: Emits events on counter changes

# Prerequisites

### System Requirements
- Node.js 21.x or later
- scarb 2.8.5

### Environment Variables
```env
DEPLOYER_PRIVATE_KEY=   # Your Starknet account private key
DEPLOYER_ADDRESS=       # Your Starknet account address
RPC_ENDPOINT=           # RPC URL (e.g. Infura or local node)
CONTRACT_ADDRESS=       # Address of the deployed contract (add after deploying)
```

# Interacting with the Counter Contract

## 1. Deploy Contract
Deploy a new instance of the counter contract:
```bash
npm run deploy
```

## 2. Read Counter Value
Retrieve the current counter value:
```bash
npm run call
```

## 3. Increase Counter Value
Increment the counter value (only owner can do this):
```bash
npm run invoke
```