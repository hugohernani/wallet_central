require 'forwardable'
require 'securerandom'
require_relative 'connections/wallet_connection'

module WalletCentral
  class Transaction
    class << self
      def transactions
        Connections::Base.collection
      end

      def wallet_transactions(wallet = nil)
        if wallet && wallet.transaction_id
          Connections::Base.collection.select{|key, value| key == [wallet.transaction_id, :wallet]}
                                      .values.sort_by(&date_sorting)
        else
          Connections::Base.collection.select{|key, value| key.include?(:wallet)}
                                      .values.sort_by(&date_sorting)
        end
      end

      def wallet_transaction(giver, taker, transfered_amount, converted_amount, &block)
        connection = Connections::WalletConnection.new(giver, taker, transfered_amount, converted_amount)
        connection.start_transaction
        block.call
        connection.commit_transaction
      rescue Exception => e
        connection.rollback_transaction
        raise e
      end

      private
      def date_sorting
        Proc.new do |wallet|
          wallet.created_at
        end
      end
    end
  end
end
