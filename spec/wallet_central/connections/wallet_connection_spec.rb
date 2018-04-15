require 'library_helper'

module WalletCentral
  module Connections
    describe WalletConnection do
      let!(:account){ Account.create(name: 'hugo') }
      let!(:giver_wallet){ account.wallets.create(currency: 'usd', amount: '830.0', account_identifier: 'jon') }
      let!(:taker_wallet){ account.wallets.create(currency: 'eur', amount: '650.0', account_identifier: 'littefinger') }

      let(:transfered_amount){ '200' }
      let(:converted_amount){ (BigDecimal.new(transfered_amount) - 50).to_s('F') }

      before do
        @connection = described_class.new(giver_wallet, taker_wallet, transfered_amount, converted_amount)
      end

      describe '#start_transaction' do
        it 'adds transaction id to wallets' do
          expect(giver_wallet.transaction_id).to be_nil
          expect(taker_wallet.transaction_id).to be_nil
          @connection.start_transaction
          expect(giver_wallet.transaction_id).to eq @connection.transaction_id
          expect(taker_wallet.transaction_id).to eq @connection.transaction_id
        end
      end

      describe '#commit_transaction' do
        it 'adds a transaction into connection collection' do
          @connection.start_transaction

          expect(@connection.commit_transaction).to be_instance_of(WalletCentral::Transactions::WalletTransaction)
        end
      end

      describe '#rollback_transaction' do
        before { @connection.start_transaction; @connection.commit_transaction }

        it 'removes transaction_id from wallets' do
          @connection.start_transaction
          @connection.commit_transaction
          expect(giver_wallet.transaction_id).to eq @connection.transaction_id
          expect(taker_wallet.transaction_id).to eq @connection.transaction_id
          expect(@connection.rollback_transaction).to be_an_instance_of(WalletCentral::Transactions::WalletTransaction)
          expect(giver_wallet.transaction_id).to be_nil
          expect(taker_wallet.transaction_id).to be_nil
        end
      end
    end
  end
end
