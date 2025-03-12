# Cross-Chain dApp Architecture with Polygon AggLayer

## Overview
This document outlines the implementation of cross-chain communication between Move and EVM chains using Polygon AggLayer. The architecture enables seamless message and value transfer across different blockchain environments.

## Components
The dApp consists of the following main components:

1. **Move Smart Contracts**
   - Located in `contracts/Move/contract.move`
   - Implements the core functionalities of the dApp using the Move programming language.
   - Manages state and facilitates interactions with EVM-based contracts.

```move
module Bridge {
    use AggLayer::MessageReceiver;
    use AggLayer::MessageSender;

    struct BridgeContract has key {
        endpoint: address
    }

    public fun initialize(endpoint: address) {
        move_to(sender(), BridgeContract { endpoint });
    }

    public fun send_message(
        destination_chain_id: u32,
        recipient: vector<u8>,
        message: vector<u8>
    ) acquires BridgeContract {
        let bridge = borrow_global<BridgeContract>(sender());
        MessageSender::send_message(
            bridge.endpoint,
            destination_chain_id,
            recipient,
            message
        );
    }

    public fun receive_message(
        source_chain_id: u32,
        sender: vector<u8>,
        message: vector<u8>
    ) {
        // Handle incoming messages from EVM chain
    }
}
```

2. **EVM Smart Contracts**
   - Located in `contracts/EVM/contract.sol`
   - Implements functionalities such as token swaps and liquidity pool management using Solidity.
   - Interacts with the Move contracts to provide a cohesive user experience.

### 1. EVM Contract Components
- **Bridge Contract**
```solidity
pragma solidity ^0.8.0;

import "@polygon-aggLayer/contracts/interfaces/IMessageReceiver.sol";
import "@polygon-aggLayer/contracts/interfaces/IMessageSender.sol";

contract BridgeContract is IMessageReceiver {
    address public aggLayerEndpoint;
    
    constructor(address _endpoint) {
        aggLayerEndpoint = _endpoint;
    }

    function sendMessage(
        uint32 destinationChainId,
        bytes calldata recipient,
        bytes calldata message
    ) external payable {
        IMessageSender(aggLayerEndpoint).sendMessage{value: msg.value}(
            destinationChainId,
            recipient,
            message
        );
    }

    function receiveMessage(
        uint32 sourceChainId,
        bytes calldata sender,
        bytes calldata message
    ) external override {
        // Handle incoming messages from Move chain
    }
}
```

3. **Frontend Application**
   - Built using React and TypeScript, located in the `frontend` directory.
   - The main entry point is `frontend/src/components/App.tsx`, which manages the layout and routing of the application.
   - The Home page component, defined in `frontend/src/pages/Home.tsx`, serves as the primary interface for users to interact with the dApp.

4. **Deployment Scripts**
   - Located in `scripts/deploy.js`
   - Handles the deployment of both Move and EVM smart contracts to the respective blockchain environments.
   - Integrates with Polygon AggLayer to ensure cross-chain functionality.

## Interoperability
The architecture leverages Polygon AggLayer to enable interoperability between the Move and EVM components. This allows for efficient communication and transaction processing across different blockchain networks, enhancing the overall functionality of the dApp.

```markdown
graph LR
    A[User] --> B[Source Chain Contract]
    B --> C[AggLayer Endpoint]
    C --> D[Validators]
    D --> E[Destination Chain Contract]
    E --> F[Target Function]
```

## Dependencies
```npm i
```

## Conclusion
This architecture is designed to provide a robust framework for building and deploying a cross-chain dApp that utilizes both Move and EVM technologies. The integration with Polygon AggLayer ensures that users can enjoy a seamless experience while interacting with the dApp across multiple blockchain environments.