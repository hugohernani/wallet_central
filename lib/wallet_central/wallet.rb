require 'forwardable'

module WalletCentral
  class Wallet
    class << self
      extend Forwardable

      def wallets_for(account)
        identifier = account.is_a?(Account) ? account.name : account
        @wallets ||= Hash.new
        @wallets[identifier] ||= Set.new(identifier)
      end

      def wallets
        @wallets
      end
    end

    class Set
      extend Forwardable
      delegate [:each, :select, :reject, :map] => :all

      def initialize(identifier)
        @identifier = identifier
      end

      def create(attributes)
        Wallet.new(attributes).tap do |wallet|
          wallet.account_identifier = @identifier
          currency = attributes[:currency]
          fail WalletCentral::DuplicateWalletError, "There is an wallet with this currency: #{currency}" if find(currency)
          collection[currency] = wallet
        end
      end

      def destroy(currency)
        find(currency)
        !collection.delete(currency).nil?
      end

      def destroy!(currency)
        find!(currency)
        !collection.delete(currency).nil?
      end

      def all
        collection.values
      end

      def find(currency)
        _find(currency)
      end

      def find!(currency)
        find(currency).tap do |wallet|
          if wallet.nil?
            fail WalletCentral::WalletNotFoundError, "Wallet with currency #{currency} does not exist"
          end
        end
      end

      private
      def collection
        @collection ||= Hash.new
      end

      def _find(currency)
        collection[currency]
      end
    end

    attr_accessor :currency, :amount, :account_identifier
    attr_reader :account

    def initialize(attributes)
      ensure_required_args!(attributes)
      set_variables(attributes)
    end

    def destroy
      self.class.wallets_for(account_identifier).destroy(currency)
    end

    private

    def ensure_required_args!(args)
      missing_args = [:currency, :amount] - args.keys
      unless missing_args.empty?
        fail WalletCentral::MissingRequiredParamsError, "Missing required params for #{self.class}. Given: #{args}. Missing: #{missing_args}"
      end
    end

    def set_variables(attributes)
      attributes.each do |key, val|
        instance_variable_set(:"@#{key}", val) if respond_to?(key)
      end
    end
  end
end
