require 'library_helper'

module WalletCentral
  module Transactions
    describe WalletTransaction do
      let!(:account){ Account.create(name: 'hugo') }
      let(:giver_original_amount){ '830.0' }
      let(:taker_original_amount){ '650.0' }
      let!(:giver_wallet){ account.wallets.create(currency: 'usd', amount: giver_original_amount, account_identifier: 'jon') }
      let!(:taker_wallet){ account.wallets.create(currency: 'eur', amount: taker_original_amount, account_identifier: 'littefinger') }

      let(:transfered_amount){ BigDecimal.new('200') }
      let(:converted_amount){ transfered_amount - 50 }

      subject(:execute_transaction){ described_class.new(giver_wallet.account_identifier, giver_wallet.currency,
                                        taker_wallet.account_identifier, taker_wallet.currency,
                                        transfered_amount, converted_amount) }

      describe '#rollback' do
        it 'adds transaction id to wallets' do
          giver_wallet.debit(transfered_amount)
          taker_wallet.credit(converted_amount)

          @transaction = execute_transaction

          expect(giver_wallet.amount).not_to eq giver_original_amount
          expect(taker_wallet.amount).not_to eq taker_original_amount

          @transaction.rollback

          expect(giver_wallet.amount).to eq giver_original_amount
          expect(taker_wallet.amount).to eq taker_original_amount
        end
      end
    end
  end
end
