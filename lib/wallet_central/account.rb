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
          finder_attr = attributes.is_a?(Hash) ? attributes[:name] : attributes.first
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
      @name = attributes.is_a?(Hash) ? attributes[:name] : attributes.first
    end

    def destroy
      self.class.destroy(name)
    end

    private

    # It does simply check for name parameter
    def ensure_required_args!(args)
      valid = (args.is_a?(Hash) ? args.key?(:name) : args.first == String)
      fail MissingRequiredParamsError, "Missing required params for #{self.class}. Given: #{args}" unless valid
    end
  end
end
