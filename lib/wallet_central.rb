require_relative 'wallet_central/account'

module WalletCentral
  class << self
    def accounts
      Account.accounts
    end

    def wallets
      Wallet.wallets
    end
  end
end
