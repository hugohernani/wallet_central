module WalletCentral
  module Connections
    class Base
      def self.collection
        @@transactions ||= Hash.new
      end

      private
      attr_reader :transaction_id
      def generate_transaction_id
        SecureRandom.uuid
      end
    end
  end
end
