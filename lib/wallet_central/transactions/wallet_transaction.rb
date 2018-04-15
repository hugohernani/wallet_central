require_relative 'base'

module WalletCentral
  module Transactions
    class WalletTransaction < Base
      attr_reader :giver_wallet_owner, :giver_wallet_currency, :taker_wallet_owner,
                  :taker_wallet_currency, :transfered_amount, :converted_amount, :created_at

      def initialize(giver_wallet_owner, giver_wallet_currency, taker_wallet_owner,
                     taker_wallet_currency, transfered_amount, converted_amount)
        @giver_wallet_owner = giver_wallet_owner
        @giver_wallet_currency = giver_wallet_currency
        @taker_wallet_owner = taker_wallet_owner
        @taker_wallet_currency = taker_wallet_currency
        @transfered_amount = transfered_amount
        @converted_amount = converted_amount
        @created_at = DateTime.now.strftime("%m/%d/%Y")
      end

      def details
        {
          giver_wallet: giver_wallet.currency,
          giver_amount: giver_wallet.amount,
          giver_account: giver_wallet.account_identifier,
          taker_wallet: taker_wallet.currency,
          taker_amount: taker_wallet.amount,
          taker_account: taker_wallet.account_identifier,
          giver_transfered_amount: transfered_amount.to_s('F'),
          taker_transfered_amount: converted_amount.to_s('F'),
          created_at: created_at
        }
      end

      # the wallets will have their transactions (credit, debit) inverted.
      def rollback
        giver_wallet.credit(transfered_amount) # it's assumed it did a debit before
        taker_wallet.debit(converted_amount) # it's assumed ot dod a credit before
        [giver_wallet, taker_wallet]
      end

      private
      def giver_wallet
        @giver_wallet ||= WalletCentral.accounts.find(giver_wallet_owner).wallets.find(giver_wallet_currency)
      end

      def taker_wallet
        @taker_wallet ||= WalletCentral.accounts.find(taker_wallet_owner).wallets.find(taker_wallet_currency)
      end
    end
  end
end
