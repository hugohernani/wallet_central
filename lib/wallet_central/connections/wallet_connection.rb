require_relative 'base'
require_relative '../transactions/wallet_transaction'

module WalletCentral
  module Connections
    class WalletConnection < Base
      attr_reader :transaction_id, :giver_wallet, :taker_wallet, :transfered_amount, :converted_amount

      def initialize(giver_wallet, taker_wallet, transfered_amount, converted_amount)
        @transaction_id = generate_transaction_id
        @giver_wallet = giver_wallet
        @taker_wallet = taker_wallet
        @transfered_amount = transfered_amount
        @converted_amount = converted_amount
      end

      def start_transaction
        giver_wallet.add_transaction(transaction_id)
        taker_wallet.add_transaction(transaction_id)
      end

      def commit_transaction
        transaction = Transactions::WalletTransaction.new(
          giver_wallet.account_identifier, giver_wallet.currency,
          taker_wallet.account_identifier, taker_wallet.currency,
          transfered_amount, converted_amount)
        self.class.collection[[transaction_id, :wallet]] = transaction
      end

      def rollback_transaction
        giver_wallet.remove_transaction(transaction_id)
        taker_wallet.remove_transaction(transaction_id)

        self.class.collection.delete([transaction_id, :wallet])
      end
    end
  end
end
