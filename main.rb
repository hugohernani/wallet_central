## API Usage example

require_relative 'lib/wallet_central'

WalletCentral.seed # load and initialize predefined account/wallets
WalletCentral.accounts
WalletCentral.wallets

jon_account =  WalletCentral.accounts.find('jon')
jon_wallets = jon_account.wallets
jon_usd_wallet = jon_account.wallets.find('USD')

littlefinger_account =  WalletCentral.accounts.find('littlefinger')
littlefinger_wallets = jon_account.wallets
littlefinger_eur_wallet = jon_account.wallets.find('EUR')

WalletCentral.registry_for(jon_account) # Print out registry at account level
WalletCentral.registry_for(jon_account, adapter: WalletCentral::RenderAdapters::JsonAdapter.new) # Print out registry at account level to json
WalletCentral.registry_for(littlefinger_eur_wallet) # Print out registry at wallet level
WalletCentral.transfer(jon_usd_wallet, littlefinger_eur_wallet, 100.0, currency: WalletCentral::Transfer::EUR_CURRENCY)

## The following transaction actions don't actually function like this in real world.
## It was created just to point out how a reverse strategy could work
## last_transaction = jon_account.transactions.last
## last_transaction.details
## last_transaction.rollback
