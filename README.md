# Wallet Central

## Usage

Start by loading the mediator, the master class **WalletCentral**

`require_relative 'lib/wallet_central'`

### Seed
The file `data/wallets.csv` can be used to seed the system loading Accounts and Wallets into memory. This can be done through the following command:

`WalletCentral.seed`

### Account
Accounts operations are wrapped into `WalletCentral.accounts`. After loading this wrapper operations become available like *creating*, getting *all* accounts, being able to *find* a specific account.

Examples:

```ruby
account_manager = WalletCentral.accounts
peter_account = account_manager.create(name: 'peter')
jack_account = account_manager.create(name: 'jack')
accounts = account_manager.all

account_manager.find('peter')
peter_account.destroy
account_manager.destroy('jack')
```

### Wallet
Wallets operations are wrapped into `WalletCentral.wallets`.
After loading this wrapper operations become available like *creating*, getting *all* wallets, being able to *find* a specific wallet. Although this function similar to `Account` wrapper. Wallet manager function as a subsystem of `Account`. This means that it needs an account to function properly.

See examples:
```ruby
hugo_account = WalletCentral.accounts.create(name: 'hugo')
hugo_wallets_manager = hugo_account.wallets
usd_wallet = hugo_wallets_manager.create(currency: 'USD', amount: '200.0')
eur_wallet = hugo_wallets_manager.create(currency: 'EUR', amount: '200.0')
hugo_wallets_manager.all
hugo_wallets_manager.find('EUR')
usd_wallet.destroy

WalletCentral.wallets # load all existent wallets
```

### Registry
The `WalletCentral` system allows data to be printed out as a hash or as json

Examples:
```ruby
WalletCentral.registry_for(jon_account) # At account level
# {name: 'jon', wallets: {'usd': '200.0'}}
WalletCentral.registry_for(jon_account, adapter: WalletCentral::RenderAdapters::JsonAdapter.new) # At account level to json
# "{\"name\":\"jon\",\"wallets\":{\"eur\":\"868.65\",\"usd\":\"463.39\"}}"
WalletCentral.registry_for(littlefinger_brl_wallet) # At wallet level
# {"BRL"=>"1567.04" }

```
Right now the system only allows `JsonAdapter` and `HashRenderer`.

### Transfer
The system allows value to be transfered between wallets.
The `currency` arg is optional. In this case the wallet to be transfered the value to will have its currency as the target in case of conversion.

Example:
```ruby
WalletCentral.transfer(jon_usd_wallet, littlefinger_eur_wallet, 100.0, currency: WalletCentral::Transfer::BRL_CURRENCY)
```
The following constants are available to be used:
```ruby
WalletCentral::Transfer::USD_BRL_RATE
WalletCentral::Transfer::USD_EUR_RATE
WalletCentral::Transfer::USD_CURRENCY
WalletCentral::Transfer::BRL_CURRENCY
WalletCentral::Transfer::EUR_CURRENCY
```
It's also possible to list rates of change a specific one:
```ruby
WalletCentral::Transfer.rates()
WalletCentral::Transfer.set_rate('USD_BRL_RATE', 3.70)
```

### Transactions
Although the transactions system is not working as expected in real world it can be used to do simple tasks like seeing details or rolling back.

Examples:
```ruby
transactions = WalletCentral::Transaction.wallet_transactions(jon_usd_wallet)
last_transaction = transactions.last
last_transaction.details
last_transaction.rollback

```
