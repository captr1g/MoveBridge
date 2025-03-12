#[test_only]
module bridge::bridge_tests {
    use std::signer;
    use std::vector;
    use bridge::Bridge;

    #[test(admin = @bridge)]
    public fun test_initialize(admin: &signer) {
        let endpoint = @0x123;
        Bridge::initialize(admin, endpoint);
    }

    #[test(admin = @bridge, user = @0x456)]
    #[expected_failure(abort_code = 101)]
    public fun test_initialize_unauthorized(admin: &signer, user: &signer) {
        let endpoint = @0x123;
        Bridge::initialize(admin, endpoint);
        Bridge::initialize(user, endpoint); // Should fail
    }

    #[test(admin = @bridge)]
    public fun test_update_endpoint(admin: &signer) {
        let old_endpoint = @0x123;
        let new_endpoint = @0x456;
        
        Bridge::initialize(admin, old_endpoint);
        Bridge::update_endpoint(admin, new_endpoint);
    }

    #[test(admin = @bridge, user = @0x456)]
    #[expected_failure(abort_code = 101)]
    public fun test_update_endpoint_unauthorized(admin: &signer, user: &signer) {
        let endpoint = @0x123;
        Bridge::initialize(admin, endpoint);
        Bridge::update_endpoint(user, @0x456); // Should fail
    }
}
