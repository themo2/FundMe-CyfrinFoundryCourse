# FundMe Smart Contract

A decentralized crowdfunding smart contract built with Solidity and deployed using Foundry. This project allows users to fund the contract with ETH, tracks contributions, and includes owner-only withdrawal functionality with price feed integration from Chainlink oracles.

**Part of the [Cyfrin Updraft](https://updraft.cyfrin.io/) Foundry Fundamentals Course.**

## Features

- **Fund with ETH**: Users can contribute ETH to the contract
- **Minimum USD requirement**: Uses Chainlink price feeds to enforce a minimum contribution in USD
- **Owner withdrawals**: Only the contract owner can withdraw funds
- **Multi-network support**: Configured for deployment on multiple networks (Sepolia, local Anvil, zkSync)
- **Price conversion**: Real-time ETH/USD conversion using Chainlink oracles
- **zkSync compatibility**: Supports deployment to zkSync Era networks

## Project Structure

```
├── src/
│   ├── FundMe.sol              # Main crowdfunding contract
│   └── PriceConverter.sol      # Utility library for price conversions
├── test/
│   ├── unit/                   # Unit tests
│   ├── integration/            # Integration tests
│   └── mocks/                  # Mock contracts for testing
├── script/
│   ├── DeployFundMe.s.sol     # Deployment script
│   ├── HelperConfig.s.sol     # Network configuration helper
│   └── Interactions.s.sol     # Contract interaction scripts
├── lib/
│   ├── forge-std/             # Foundry standard library
│   ├── chainlink-brownie-contracts/  # Chainlink contracts
│   └── foundry-devops/        # Deployment utilities
├── Makefile                   # Build and deployment automation
└── foundry.toml               # Foundry configuration
```

## Smart Contracts

### FundMe.sol
The main contract that handles:
- Accepting ETH contributions with minimum USD value requirement
- Tracking funders and their contributions
- Owner-only withdrawal functionality
- Integration with Chainlink price feeds

### PriceConverter.sol
A library contract that provides:
- ETH to USD price conversion using Chainlink oracles
- Utility functions for price calculations

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Installation

1. Clone the repository:
```shell
git clone <your-repo-url>
cd foundry-fundme
```

2. Install dependencies:
```shell
forge install
```

3. Build the project:
```shell
forge build
```

## Usage

### Testing

Run all tests:
```shell
forge test
```

Run tests with verbosity:
```shell
forge test -vvv
```

Run a specific test:
```shell
forge test --match-test testFunctionName
```

### Using Makefile Commands

This project includes a comprehensive Makefile for easy project management:

**Setup and Build:**
```shell
make install    # Install dependencies
make build      # Build the project
make clean      # Clean build artifacts
```

**Testing:**
```shell
make test       # Run all tests
make snapshot   # Generate gas snapshots
```

**Local Development:**
```shell
make anvil      # Start local Anvil node
make deploy     # Deploy to local network
```

**Network Deployments:**
```shell
make deploy-sepolia    # Deploy to Sepolia testnet
make deploy-zk         # Deploy to zkSync local
make deploy-zk-sepolia # Deploy to zkSync Sepolia
```

**Contract Interactions:**
```shell
make fund       # Fund the contract
make withdraw   # Withdraw funds (owner only)
```

### Manual Deployment

**Local Deployment:**

1. Start a local Anvil node:
```shell
anvil
```

2. Deploy to local network:
```shell
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --private-key <ANVIL_PRIVATE_KEY> --broadcast
```

**Testnet Deployment (Sepolia):**

1. Set up environment variables in `.env`:
```env
SEPOLIA_RPC_URL=your_sepolia_rpc_url
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

2. Deploy to Sepolia:
```shell
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

### Interacting with the Contract

Fund the contract:
```shell
cast send <CONTRACT_ADDRESS> "fund()" --value 0.1ether --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>
```

Check contract balance:
```shell
cast balance <CONTRACT_ADDRESS> --rpc-url <RPC_URL>
```

Withdraw funds (owner only):
```shell
cast send <CONTRACT_ADDRESS> "withdraw()" --rpc-url <RPC_URL> --private-key <OWNER_PRIVATE_KEY>
```

## Configuration

The project uses [`HelperConfig.s.sol`](script/HelperConfig.s.sol) to manage network-specific configurations:

- **Sepolia**: Uses live Chainlink ETH/USD price feed
- **Local/Anvil**: Deploys mock price feed for testing

## Testing

The test suite includes:
- Unit tests for all contract functions
- Integration tests with price feeds
- Fuzz testing for edge cases
- Gas optimization tests

Key test files:
- [`FundMeTest.t.sol`](test/FundMeTest.t.sol): Main test suite

## Gas Optimization

View gas usage:
```shell
forge snapshot
```

The gas snapshot is saved in [`.gas-snapshot`](.gas-snapshot) for tracking gas usage changes.

## Security Considerations

- Uses Chainlink price feeds for reliable price data
- Implements owner-only withdrawal pattern
- Includes minimum contribution requirements
- Comprehensive test coverage for edge cases

## Dependencies

- **Foundry**: Testing framework and deployment toolkit
- **Chainlink Contracts**: Price feed oracles



## Resources
- [Cyfrin Updraft Foundry Fundamentals Course](https://updraft.cyfrin.io/courses/foundry)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds/price-feeds)
- [Solidity Documentation](https://docs.soliditylang.org/)