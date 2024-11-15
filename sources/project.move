module rental_service::gadget_rental {
    use std::signer;
    use aptos_framework::account;
    use std::string::{String, utf8};

    // Struct to represent a Gadget
    struct Gadget has key {
        name: String,           // Name of the gadget
        rented: bool            // Rental status: true if rented, false otherwise
    }

    // Function to list a new gadget for rent
    public entry fun list_gadget(account: &signer, gadget_name: String) acquires Gadget {
        let owner_address = signer::address_of(account);
        
        // Ensure gadget doesn't already exist for the owner
        if (!exists<Gadget>(owner_address)) {
            let gadget = Gadget {
                name: gadget_name,
                rented: false
            };
            move_to(account, gadget);
        } else {
            let gadget = borrow_global_mut<Gadget>(owner_address);
            gadget.name = gadget_name; // Update gadget details
            gadget.rented = false;     // Reset rental status
        }
    }

    // Function to rent the gadget
    public entry fun rent_gadget(account: &signer) acquires Gadget {
        let owner_address = signer::address_of(account);

        // Check if gadget exists and isn't already rented
        assert!(exists<Gadget>(owner_address), 1);
        let gadget = borrow_global_mut<Gadget>(owner_address);
        assert!(!gadget.rented, 2);

        // Update gadget status to rented
        gadget.rented = true;
    }
}
