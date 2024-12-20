#[starknet::interface]
trait IKillSwitch<TContractState> {
    fn is_active(self: @TContractState) -> bool;
}

#[starknet::interface]
pub trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
}

#[starknet::contract]
pub mod counter_contract {
    use starknet::{ContractAddress};
    use starknet::storage::{StoragePointerWriteAccess, StoragePointerReadAccess};
    use super::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
    use openzeppelin_access::ownable::OwnableComponent;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl InternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        pub counter: u32,
        pub kill_switch: ContractAddress,
        #[substorage(v0)]
        pub ownable: OwnableComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        CounterIncreased: CounterIncreased,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    #[derive(Drop, starknet::Event)]
    pub struct CounterIncreased {
        pub value: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u32, kill_switch: ContractAddress, initial_owner: ContractAddress) {
        self.counter.write(initial_value);
        self.kill_switch.write(kill_switch);
        self.ownable.initializer(initial_owner);
    }    

    #[abi(embed_v0)]
    impl ICounter of super::ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            self.ownable.assert_only_owner();
            let kill_switch = IKillSwitchDispatcher { contract_address: self.kill_switch.read() };
            assert!(!kill_switch.is_active(), "Kill Switch is active");
            let current_value = self.counter.read();
            self.counter.write(current_value + 1);
            self.emit(CounterIncreased { value: current_value + 1 });
        }
    }
}