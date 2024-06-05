use starknet::ContractAddress;

#[starknet::interface]
trait Ierc20<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn decimals(self: @TContractState) -> u8;
    fn totalSupply(self: @TContractState) -> u256;
    fn balanceOf(self: @TContractState, owner: ContractAddress) -> u256;
    fn transfer(ref self: TContractState, _to: ContractAddress, value: u256) -> bool;
    fn transferFrom(ref self: TContractState, _from: ContractAddress, _to: ContractAddress, _value: u256) -> bool;
    fn approve(ref self: TContractState, _spender: ContractAddress, _value: u256) -> bool;
    fn allowance(self: @TContractState, _owner: ContractAddress, _spender: ContractAddress) -> u256;
}

#[starknet::contract]
mod erc20 {
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        decimals: u8,
        totalSupply: u256,
        balances: LegacyMap::<ContractAddress, u256>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        _from: ContractAddress,
        _to: ContractAddress,
        _value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        _owner: ContractAddress,
        _spender: ContractAddress,
        _value: u256,
    }

    #[abi(embed_v0)]
    impl Ierc20Impl of super::Ierc20<ContractState>{
        fn name(self: @ContractState) -> felt252 {
            self.name.read()
        }
        fn symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }
        fn decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }
        fn totalSupply(self: @ContractState) -> u256 {
            self.totalSupply.read()
        }
        fn balanceOf(self: @ContractState, owner: ContractAddress) -> u256 {
            self.balances.read(owner)
        }
        fn transfer(ref self: ContractState, _to: ContractAddress, value: u256) -> bool {
            let sender = get_caller_address();
            false
        }
        fn transferFrom(ref self: ContractState, _from: ContractAddress, _to: ContractAddress, _value: u256) -> bool {
            false
        }
        fn approve(ref self: ContractState, _spender: ContractAddress, _value: u256) -> bool {
            false
        }
        fn allowance(self: @ContractState, _owner: ContractAddress, _spender: ContractAddress) -> u256 {
            self.allowances.read((_owner, _spender))
        }
    }
}