require_relative 'wallet_central/errors'
require_relative 'wallet_central/account'
require_relative 'wallet_central/wallet'

module WalletCentral
  class << self
    def accounts
      Account.accounts
    end
  end
end
