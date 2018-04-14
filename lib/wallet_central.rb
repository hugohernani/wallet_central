# Libraries
require 'csv'
require 'bigdecimal'

# Renderers
require_relative "wallet_central/renderers/hash_renderer"

# Render Adapters
require_relative "wallet_central/render_adapters/json_adapter"

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
        account.wallets.create(currency: row[1], amount: row[2])
      end
      puts "The data was seeded" if wallets.any?
    end

    def registry_for(resource, options = {})
      renderer = options.fetch(:renderer, Renderers::HashRenderer.new)
      result = resource.render(renderer)
      options[:adapter] ? options[:adapter].perform(result) : result
    end
  end
end
