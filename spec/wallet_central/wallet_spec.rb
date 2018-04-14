require 'library_helper'

module WalletCentral
  describe Wallet do
    let!(:account){ Account.create(name: 'jon') }

    subject{ described_class.wallets_for(account) }

    describe '.create' do
      context 'when required param is not passed' do
        let(:attributes){ Hash[:inexistant_attr, nil] }

        it 'raises a missing param error' do
          expect{subject.create(attributes)}.to raise_error(MissingRequiredParamsError)
        end
      end

      context 'when wallet already exists' do
        let(:attributes){ {currency: 'USD', amount: 120.0} }

        before { subject.create(attributes) }

        it 'raises a missing param error' do
          expect{subject.create(attributes)}.to raise_error(DuplicateWalletError)
        end
      end

      context 'when attributes are valid' do
        let(:attributes){ Hash[:currency, 'USD', :amount, 200.0, :account, account]}

        it 'returns an instance' do
          expect(subject.create(attributes)).to be_an_instance_of(described_class)
        end
      end
    end
    describe '.all' do
      let(:wallets_size){ 2 }

      before { wallets_size.times{|i| subject.create(currency: "CURRENCY-#{i}", amount: 200) } }

      it 'returns the right amount of wallets' do
        expect(subject.all.size).to eq wallets_size
      end
    end
    describe '.find' do
      context 'when wallet does not exist' do
        it 'returns nil' do
          expect(subject.find('unknown_wallet')).to be_nil
        end
      end
    end
    describe '.exists?' do
      context 'when wallet does not exist' do
        it 'returns nil' do
          expect(subject.exists?('unknown_wallet')).to be_falsey
        end
      end
    end
    describe '.find!' do
      context 'when wallet does not exist' do
        it 'raises a Wallet Not Found error' do
          expect{subject.find!('unknown_wallet')}.to raise_error(WalletNotFoundError)
        end
      end
    end
    describe '.destroy' do
      context 'when wallet does not exist' do
        it 'returns false' do
          expect(subject.destroy('unknown_wallet')).to be_falsey
        end
      end

      context 'when wallet exists' do
        let(:attributes){ {currency: 'USD', amount: '200.0'} }

        before { subject.create(attributes) }

        it 'returns true' do
          expect(subject.destroy('USD')).to be_truthy
        end
      end
    end
    describe '.destroy!' do
      context 'when wallet does not exist' do
        it 'raises a Wallet Not Found error' do
          expect{subject.destroy!('unknown_wallet')}.to raise_error(WalletNotFoundError)
        end
      end
    end
    describe '#destroy' do
      it 'returns true' do
        wallet = subject.create(currency: 'USD', amount: 200)
        expect(wallet.destroy).to be_truthy
      end
    end

    describe '#credit' do
      it 'increases the quantity in amount field' do
        wallet = subject.create(currency: 'USD', amount: 200)
        wallet.credit(100)
        expect(wallet.amount).to eq "300.0"
      end
    end

    describe '#debit' do
      it 'decreases the quantity in amount field' do
        wallet = subject.create(currency: 'USD', amount: 200)
        wallet.debit(50)
        expect(wallet.amount).to eq "150.0"
      end
    end
  end
end
