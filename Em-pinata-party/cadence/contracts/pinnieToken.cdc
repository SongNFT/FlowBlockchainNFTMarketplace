pub contract pinnieToken{
    pub var totalSupply: UFix64
    pub var tokenName: String

    pub resource interface Provider {
        pub fun withdraw(amount: UFix64): @Vault {
            post {
                result.balance == UFix64(amount):
                    "Withdrawal amount must be the same as the balance of the withdrawn Vault"
            }
        }
        pub resource interface Receiver {
            pub fun deposit(from: @Vault)
        }

        pub resource interface Balance {
            pub var balance: UFix64
        }

        pub resource Vault: Provider, Receiver, Balance {
            pub var balance: UFix64

            init(balance: UFix64) {
                self.balance = balance
            }

            pub fun withdraw(amount: UFix64): @Vault {
                self.balance = self.balance - amount
                return <-create Vault(balance: amount)
            }

            pub fun deposit(from: @Vault) {
                self.balance = self.balance + from.balance
                destroy from
            }
        }
        
    }
}