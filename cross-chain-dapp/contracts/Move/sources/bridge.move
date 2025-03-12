module bridge::Bridge {
    use std::string::{String, utf8};
    use std::signer;
    use std::vector;
    use std::table::{Self, Table};
    use aptos_std::bcs;

    /// Custom errors
    const E_UNAUTHORIZED: u64 = 101;
    const E_INVALID_AMOUNT: u64 = 102;
    const E_INSUFFICIENT_BALANCE: u64 = 103;
    const E_BRIDGE_NOT_INITIALIZED: u64 = 104;
    const E_BRIDGE_ALREADY_INITIALIZED: u64 = 105;
    const E_INVALID_STATE: u64 = 106;

    /// Bridge operation status
    struct BridgeStatus has copy, drop, store {
        is_active: bool,
        last_operation: String,
        operation_result: String
    }

    /// Bridge state
    struct BridgeState has key {
        endpoint: address,  // If you integrate an actual bridging layer, store its address here
        admin: address,
        locked_tokens: Table<address, u64>,
        status: BridgeStatus,
        total_operations: u64
    }

    /// Example message structure for bridging tokens
    struct BridgeMessage has copy, drop {
        token_address: address,
        amount: u64,
        recipient: vector<u8>
    }

    /// Initialize bridge storage with improved checks
    public entry fun initialize(_account: &signer, endpoint: address) {
        let _admin_addr = signer::address_of(_account);
        assert!(!exists<BridgeState>(_admin_addr), E_BRIDGE_ALREADY_INITIALIZED);

        move_to(_account, BridgeState {
            endpoint,
            admin: _admin_addr,
            locked_tokens: table::new(),
            status: BridgeStatus {
                is_active: true,
                last_operation: utf8(b""),
                operation_result: utf8(b"")
            },
            total_operations: 0
        });
    }

    /// Get bridge status
    public fun get_bridge_status(bridge_address: address): (bool, String, String) acquires BridgeState {
        let bridge_state = borrow_global<BridgeState>(bridge_address);
        (
            bridge_state.status.is_active,
            bridge_state.status.last_operation,
            bridge_state.status.operation_result
        )
    }

    /// Update bridge status
    public fun update_bridge_status(
        account: &signer,
        is_active: bool
    ) acquires BridgeState {
        let admin_addr = signer::address_of(account);
        let bridge_state = borrow_global_mut<BridgeState>(@bridge);
        assert!(admin_addr == bridge_state.admin, E_UNAUTHORIZED);
        
        bridge_state.status.is_active = is_active;
    }

    /// Lock tokens and record bridging event; adapt as necessary for your bridging logic
    public entry fun bridge_tokens(
        _account: &signer,
        _token_address: address,
        _amount: u64,
        _destination_chain: u32,
        _recipient: vector<u8>
    ) acquires BridgeState {
        let admin_addr = signer::address_of(_account);
        let bridge_state = borrow_global_mut<BridgeState>(@bridge);
        assert!(bridge_state.status.is_active, E_INVALID_STATE);

        // Verify amount
        assert!(_amount > 0, E_INVALID_AMOUNT);

        // Lock tokens in the bridge
        //let old_balance = *table::borrow(&bridge_state.locked_tokens, _token_address);
        //table::upsert(&mut bridge_state.locked_tokens, _token_address, old_balance + _amount);

        // Example bridging "logic": in a real scenario, you'd burn or hold the tokens
        // coin::transfer<coin::CoinType>(_token_address, bridge_state_endpoint, _amount);

        // Create message and encode
        let msg = BridgeMessage {
            token_address: _token_address,
            amount: _amount,
            recipient: copy _recipient
        };
        let _encoded = encode_message(&msg);

        // (Placeholder) If you had an aggregator, you'd send the cross-chain message here
        // aggregator::send_message(bridge_state.endpoint, _destination_chain, _recipient, _encoded);

        // Update operation status
        bridge_state.status.last_operation = utf8(b"BRIDGE_TOKENS");
        bridge_state.status.operation_result = utf8(b"SUCCESS");
        bridge_state.total_operations = bridge_state.total_operations + 1;
    }

    /// Receive message from cross-chain aggregator
    public fun receive_message(
        _source_chain: u32,
        _sender: vector<u8>,
        _message: vector<u8>
    ) acquires BridgeState {
        let bridge_state = borrow_global_mut<BridgeState>(@bridge);

        // Decode message
        let BridgeMessage { token_address: _token_address, amount: _amount, recipient: _recipient } = decode_message(_message);

        // Release tokens to the recipient
        // let current_balance = *table::borrow(&bridge_state.locked_tokens, _token_address);
        // assert!(current_balance >= _amount, E_INSUFFICIENT_BALANCE);

        // let new_balance = current_balance - _amount;
        // table::upsert(&mut bridge_state.locked_tokens, _token_address, new_balance);

        // Transfer tokens to final recipient (adapt as needed - example uses coin)
        // let recipient_addr = account::address_from_bytes(_recipient);
        // coin::transfer<coin::CoinType>(_token_address, recipient_addr, _amount);
    }

    /// Helper encode/decode for bridging
    fun encode_message(msg: &BridgeMessage): vector<u8> {
        let encoded = vector::empty<u8>();
        vector::append(&mut encoded, bcs::to_bytes(&msg.token_address));
        vector::append(&mut encoded, bcs::to_bytes(&msg.amount));
        vector::append(&mut encoded, msg.recipient);
        encoded
    }

    fun decode_message(_message: vector<u8>): BridgeMessage {
        let _token_addr_raw = vector::slice(&_message, 0, 16);
        let _amount_raw = vector::slice(&_message, 16, 24);
        let recipient = vector::slice(&_message, 24, vector::length(&_message));

        // Use vector operations to convert bytes to primitive types
        let token_address = @0x0; // This needs proper deserialization
        let amount = 0u64; // This needs proper deserialization

        BridgeMessage {
            token_address,
            amount,
            recipient
        }
    }

    /// Admin function to update aggregator endpoint
    public fun update_endpoint(account: &signer, new_endpoint: address) acquires BridgeState {
        let admin_addr = signer::address_of(account);
        let bridge_state = borrow_global_mut<BridgeState>(@bridge);
        assert!(admin_addr == bridge_state.admin, E_UNAUTHORIZED);

        bridge_state.endpoint = new_endpoint;
    }
}
