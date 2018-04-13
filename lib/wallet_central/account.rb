require 'forwardable'

module WalletCentral
  class Account
    class << self
      extend Forwardable
      delegate [:create, :find, :find!, :all, :destroy, :destroy!] => :accounts

      def accounts
        @accounts ||= Set.new
      end
    end

    class Set
      extend Forwardable
      delegate [:each, :map] => :all

      def create(attributes)
        Account.new(attributes).tap do |account|
          finder_attr = attributes[:name]
          fail DuplicateAccountError, "There is an account with: #{finder_attr}" if find(finder_attr)
          collection[finder_attr] = account
        end
      end

      def destroy(name)
        find(name)
        !collection.delete(name).nil?
      end

      def destroy!(name)
        find!(name)
        !collection.delete(name).nil?
      end

      def all
        collection.values
      end

      def find(name)
        _find(name)
      end

      def find!(name)
        find(name).tap do |account|
          fail AccountNotFoundError, "Account with name #{name} does not exist" unless account
        end
      end

      private

      def collection
        @collection ||= Hash.new
      end

      def _find(name)
        collection[name]
      end
    end

    attr_accessor :name

    def initialize(attributes)
      ensure_required_args!(attributes)
      @name = attributes[:name]
    end

    def identifier
      name
    end

    def wallets
      @wallets ||= Wallet.wallets_for(self)
    end

    def destroy
      self.class.destroy(name)
      destroyed = true
      wallets.each{|w| w.destroy }
    end

    private

    # It does simply check for name parameter
    def ensure_required_args!(args)
      if (missing_args = [:name] - args.keys).any?
        fail MissingRequiredParamsError, "Missing required params for #{self.class}. Given: #{args}. Missing: #{missing_args}"
      end
    end
  end
end
