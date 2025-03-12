module MoveBridge::Bridge {
    use Std::Signer;
    use Std::Vector;
    use AggLayer::MessageReceiver;
    use AggLayer::MessageSender;
    use Std::Event;

    /// Custom errors
    const E_UNAUTHORIZED: u64 = 101;
    const E_INVALID_AMOUNT: u64 = 102;
    const E_INSUFFICIENT_BALANCE: u64 = 103;

    /// Events
    struct TokensBridgedEvent has drop, store {
        token_address: address,
        amount: u64,
        destination_chain: u32,
        recipient: vector<u8>
    }

    struct MessageReceivedEvent has drop, store {
        source_chain: u32,
        sender: vector<u8>,
        message: vector<u8>
    }

    /// Bridge state
    struct BridgeState has key {
        endpoint: address,
        admin: address,
        locked_tokens: Table<address, u64>,
        events: EventHandle<TokensBridgedEvent>
    }

    /// Message structure for cross-chain communication
    struct BridgeMessage has copy, drop {
        token_address: address,
        amount: u64,
        recipient: vector<u8>
    }

    public fun initialize(account: &signer, endpoint: address) {
        let sender = Signer::address_of(account);
        assert!(!exists<BridgeState>(sender), E_UNAUTHORIZED);

        move_to(account, BridgeState {
            endpoint,
            admin: sender,
            locked_tokens: Table::new(),
            events: Event::new_event_handle<TokensBridgedEvent>(account)
        });
    }

    public fun bridge_tokens(
        account: &signer,
        token_address: address,
        amount: u64,
        destination_chain: u32,
        recipient: vector<u8>
    ) acquires BridgeState {
        let sender = Signer::address_of(account);
        let bridge_state = borrow_global_mut<BridgeState>(@MoveBridge);

        // Verify amount
        assert!(amount > 0, E_INVALID_AMOUNT);

        // Lock tokens in the bridge
        let current_balance = Table::get_or_default(&bridge_state.locked_tokens, token_address, 0);
        Table::set(&mut bridge_state.locked_tokens, token_address, current_balance + amount);

        // Create bridge message
        let message = BridgeMessage {
            token_address,
            amount,
            recipient: copy recipient
        };

        // Encode message for cross-chain transfer
        let encoded_message = encode_message(&message);

        // Send message through AggLayer
        MessageSender::send_message(
            bridge_state.endpoint,
            destination_chain,
            recipient,
            encoded_message
        );

        // Emit event
        Event::emit_event(
            &mut bridge_state.events,
            TokensBridgedEvent {
                token_address,
                amount,
                destination_chain,
                recipient
            }
        );
    }

    public fun receive_message(
        source_chain: u32,
        sender: vector<u8>,
        message: vector<u8>
    ) acquires BridgeState {
        let bridge_state = borrow_global_mut<BridgeState>(@MoveBridge);
        
        // Verify sender is AggLayer endpoint
        assert!(MessageReceiver::verify_sender(sender), E_UNAUTHORIZED);

        // Decode message
        let BridgeMessage { token_address, amount, recipient } = decode_message(message);

        // Release tokens to recipient
        let current_balance = Table::get(&bridge_state.locked_tokens, token_address);
        assert!(current_balance >= amount, E_INSUFFICIENT_BALANCE);
        
        Table::set(
            &mut bridge_state.locked_tokens,
            token_address,
            current_balance - amount
        );

        // Transfer tokens to recipient
        let recipient_addr = from_bytes<address>(recipient);
        Token::transfer(token_address, recipient_addr, amount);

        // Emit event
        Event::emit_event(
            &mut bridge_state.events,
            MessageReceivedEvent {
                source_chain,
                sender,
                message
            }
        );
    }

    /// Helper functions for message encoding/decoding
    fun encode_message(message: &BridgeMessage): vector<u8> {
        let encoded = Vector::empty<u8>();
        Vector::append(&mut encoded, bcs::to_bytes(&message.token_address));
        Vector::append(&mut encoded, bcs::to_bytes(&message.amount));
        Vector::append(&mut encoded, message.recipient);
        encoded
    }

    fun decode_message(message: vector<u8>): BridgeMessage {
        let token_address = from_bytes<address>(Vector::slice(&message, 0, 32));
        let amount = from_bytes<u64>(Vector::slice(&message, 32, 40));
        let recipient = Vector::slice(&message, 40, Vector::length(&message));
        
        BridgeMessage {
            token_address,
            amount,
            recipient
        }
    }

    /// Admin functions
    public fun update_endpoint(account: &signer, new_endpoint: address) acquires BridgeState {
        let sender = Signer::address_of(account);
        let bridge_state = borrow_global_mut<BridgeState>(@MoveBridge);
        assert!(sender == bridge_state.admin, E_UNAUTHORIZED);
        bridge_state.endpoint = new_endpoint;
    }
}