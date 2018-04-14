# Libraries
require 'csv'
require 'bigdecimal'

# Resources
require_relative 'wallet_central/errors'
require_relative 'wallet_central/account'
require_relative 'wallet_central/wallet'

module WalletCentral
  class << self
    def accounts
      Account.accounts
    end

    def wallets
      Wallet.wallets
    end

    def seed
      CSV.foreach(File.expand_path('../data/wallets.csv', __FILE__), headers: true, return_headers: false) do |row|
        account = accounts.find(row[0]) || accounts.create(name: row[0])
        account.wallets.create(currency: row[1], amount: BigDecimal.new(row[2]))
      end
      puts "The data was seeded" if wallets.any?
    end
  end
end
