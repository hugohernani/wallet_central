require 'library_helper'

module WalletCentral
  describe Transfer do
    let(:usd_wallet_amount){ '830.0' }
    let(:eur_wallet_amount){ '650.0' }
    let(:brl_wallet_amount){ '950.0' }
    let!(:account){ Account.create(name: 'hugo') }
    let!(:usd_wallet){ account.wallets.create(currency: 'usd', amount: usd_wallet_amount, account_identifier: 'jon') }
    let!(:eur_wallet){ account.wallets.create(currency: 'eur', amount: eur_wallet_amount, account_identifier: 'littefinger') }
    let!(:brl_wallet){ account.wallets.create(currency: 'brl', amount: brl_wallet_amount, account_identifier: 'jack') }

    let(:transfer_amount){ '200' }
    let(:currency){ nil }

    subject{ described_class.transfer(giver_wallet, taker_wallet, transfer_amount, currency) }


    describe '.transfer' do
      context 'unknown currency' do
        let(:giver_wallet){ usd_wallet }
        let(:taker_wallet){ eur_wallet }

        context 'in the system' do
          let(:currency){ 'CLP' }

          it 'raises a missing param error' do
            expect{subject}.to raise_error(CurrencyNotSupportedError)
          end
        end

        context 'not transferable between  wallets' do
          let(:currency){ 'BRL' }

          it 'raises a missing param error' do
            expect{subject}.to raise_error(WalletsWithoutCurrencyError)
          end
        end
      end
      context 'valid amounts' do
        context 'usd to eur' do
          let(:giver_wallet){ usd_wallet }
          let(:taker_wallet){ eur_wallet }

          let(:currency){ 'EUR' }
          it 'does the transfer properly' do
            usd_to_eur_rate = described_class.rates[:usd_to_eur_rate]
            expected_transfered_value = BigDecimal.new(transfer_amount) * usd_to_eur_rate
            giver_result = (BigDecimal.new(giver_wallet.amount) - BigDecimal.new(transfer_amount)).to_s('F')
            taker_result = (BigDecimal.new(taker_wallet.amount) + expected_transfered_value).to_s('F')

            subject
            expect(giver_wallet.amount).to eq (giver_result)
            expect(taker_wallet.amount).to eq (taker_result)
          end
        end

        context 'usd to brl' do
          let(:giver_wallet){ usd_wallet }
          let(:taker_wallet){ brl_wallet }

          let(:currency){ 'BRL' }
          it 'does the transfer properly' do
            rate = described_class.rates[:usd_to_brl_rate]
            expected_transfered_value = BigDecimal.new(transfer_amount) * rate
            giver_result = (BigDecimal.new(giver_wallet.amount) - BigDecimal.new(transfer_amount)).to_s('F')
            taker_result = (BigDecimal.new(taker_wallet.amount) + expected_transfered_value).to_s('F')

            subject
            expect(giver_wallet.amount).to eq (giver_result)
            expect(taker_wallet.amount).to eq (taker_result)
          end
        end

        context 'brl to eur' do
          let(:giver_wallet){ brl_wallet }
          let(:taker_wallet){ eur_wallet }

          let(:currency){ 'EUR' }
          it 'does the transfer properly' do
            dollar_transfered_value = BigDecimal.new(transfer_amount) / described_class.rates[:usd_to_brl_rate]
            expected_transfered_value = dollar_transfered_value * described_class.rates[:usd_to_eur_rate]
            giver_result = (BigDecimal.new(giver_wallet.amount) - BigDecimal.new(transfer_amount)).to_s('F')
            taker_result = (BigDecimal.new(taker_wallet.amount) + expected_transfered_value).to_s('F')

            subject
            expect(giver_wallet.amount).to eq (giver_result)
            expect(taker_wallet.amount).to eq (taker_result)
          end
        end

        context 'eur to brl' do
          let(:giver_wallet){ eur_wallet }
          let(:taker_wallet){ brl_wallet }

          let(:currency){ 'BRL' }
          it 'does the transfer properly' do
            dollar_transfered_value = BigDecimal.new(transfer_amount) / described_class.rates[:usd_to_eur_rate]
            expected_transfered_value = dollar_transfered_value * described_class.rates[:usd_to_brl_rate]
            giver_result = (BigDecimal.new(giver_wallet.amount) - BigDecimal.new(transfer_amount)).to_s('F')
            taker_result = (BigDecimal.new(taker_wallet.amount) + expected_transfered_value).to_s('F')

            subject
            expect(giver_wallet.amount).to eq (giver_result)
            expect(taker_wallet.amount).to eq (taker_result)
          end
        end
      end

      context 'invalid amounts' do
        let(:giver_wallet){ usd_wallet }
        let(:taker_wallet){ eur_wallet }
        let(:transfer_amount){ (BigDecimal.new(usd_wallet_amount) + 1).to_s('F') } # plus one dollar the amount in the wallet

        it 'does not the transfer properly. it raises InsufficientAmountError' do
          expect{subject}. to raise_error(InsufficientAmountError)
        end
      end

      context 'change rates' do
        it 'changes usd to brl rate' do
          expected_rate = 2.5

          expect(described_class.set_rate("USD_BRL_RATE", expected_rate)).to eq expected_rate
        end

        it 'raises UnknownCurrencyRateError when given currency error is supported' do
          expect{described_class.set_rate('UNKNOWN_CURRENCY_RATE', 999)}.to raise_error(UnknownCurrencyRateError)
        end
      end
    end
  end
end
