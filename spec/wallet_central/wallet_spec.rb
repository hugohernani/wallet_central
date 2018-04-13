require 'library_helper'

module WalletCentral
  describe Wallet do
    describe '.create' do
      context 'when required param is not passed' do
        let(:attributes){ Hash[:inexistant_attr, nil] }

        it 'raises a missing param error' do
          expect{described_class.create(attributes)}.to raise_error(MissingRequiredParamsError)
        end
      end

      context 'when wallet already exists' do
        let(:attributes){ {currency: 'USD', amount: 120.0} }

        before { described_class.create(attributes) }

        it 'raises a missing param error' do
          expect{described_class.create(attributes)}.to raise_error(DuplicateWalletError)
        end
      end

      context 'when attributes are valid' do
        let(:attributes){ Hash[:currency, 'USD', :amount, 200.0]}

        it 'returns an instance' do
          expect(described_class.create(attributes)).to be_an_instance_of(described_class)
        end
      end
    end
    describe '.all' do
      let(:wallets_size){ 2 }

      before { wallets_size.times{|i| described_class.create(currency: "CURRENCY-#{i}", amount: 200) } }

      it 'returns the right amount of wallets' do
        expect(described_class.all.size).to eq wallets_size
      end
    end
    describe '.find' do
      context 'when wallet does not exist' do
        it 'returns nil' do
          expect(described_class.find('unknown_wallet')).to be_nil
        end
      end
    end
    describe '.find!' do
      context 'when wallet does not exist' do
        it 'raises a Wallet Not Found error' do
          expect{described_class.find!('unknown_wallet')}.to raise_error(WalletNotFoundError)
        end
      end
    end
    describe '.destroy' do
      context 'when wallet does not exist' do
        it 'returns false' do
          expect(described_class.destroy('unknown_wallet')).to be_falsey
        end
      end

      context 'when wallet exists' do
        let(:attributes){ {currency: 'USD', amount: '200.0'} }

        before { described_class.create(attributes) }

        it 'returns true' do
          expect(described_class.destroy('USD')).to be_truthy
        end
      end
    end
    describe '.destroy!' do
      context 'when wallet does not exist' do
        it 'raises a Wallet Not Found error' do
          expect{described_class.destroy!('unknown_wallet')}.to raise_error(WalletNotFoundError)
        end
      end
    end
    describe '#destroy' do
      it 'returns true' do
        wallet = described_class.create(currency: 'USD', amount: 200)
        expect(wallet.destroy).to be_truthy
      end
    end
  end
end