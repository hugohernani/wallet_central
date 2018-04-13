require 'forwardable'

module WalletCentral
  class Wallet
    class << self
      extend Forwardable
      delegate [:create, :find, :find!, :all, :destroy, :destroy!] => :wallets

      def wallets
        @wallets ||= Set.new
      end
    end

    class Set
      extend Forwardable
      delegate [:each, :map] => :all

      def create(attributes)
        Wallet.new(attributes).tap do |wallet|
          finder_attr = attributes.is_a?(Hash) ? attributes[:currency] : attributes.first
          fail DuplicateWalletError, "There is an wallet with this currency: #{finder_attr}" if find(finder_attr)
          collection[finder_attr] = wallet
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
          fail WalletNotFoundError, "Wallet with currency #{currency} does not exist" unless wallet
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

    attr_accessor :currency, :amount

    def initialize(attributes)
      ensure_required_args!(attributes)
      if attributes.is_a?(Hash)
        set_variables(attributes)
      else
        @currency, @amount = [attributes.first, attributes.second]
      end
    end

    def destroy
      self.class.destroy(currency)
    end

    private

    def ensure_required_args!(args)
      extracted_args = args.is_a?(Hash) ? args.keys : args
      missing_args = [:currency, :amount] - extracted_args
      unless missing_args.empty?
        fail MissingRequiredParamsError, "Missing required params for #{self.class}. Given: #{args}. Missing: #{missing_args}"
      end
    end

    def set_variables(attributes)
      attributes.each do |key, val|
        instance_variable_set(:"@#{key}", val) if respond_to?(key)
      end
    end
  end
end
