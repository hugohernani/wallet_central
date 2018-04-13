require 'library_helper'

module WalletCentral
  describe Account do
    describe '.create' do
      context 'when required param is not passed' do
        let(:attributes){ Hash[:inexistant_attr, nil] }

        it 'raises a missing param error' do
          expect{described_class.create(attributes)}.to raise_error(MissingRequiredParamsError)
        end
      end

      context 'when account already exists' do
        let(:attributes){ {name: 'Jon'} }

        before { described_class.create(attributes) }

        it 'raises a duplicate account error' do
          expect{described_class.create(attributes)}.to raise_error(DuplicateAccountError)
        end
      end

      context 'when attributes are valid' do
        let(:attributes){ Hash[:name, 'Litlefinger']}

        it 'returns an instance' do
          expect(described_class.create(attributes)).to be_an_instance_of(described_class)
        end
      end
    end
    describe '.all' do
      let(:accounts_size){ 2 }

      before { accounts_size.times{|i| described_class.create(name: "name-#{i}") } }

      it 'returns the right amount of accounts' do
        expect(described_class.all.size).to eq accounts_size
      end
    end
    describe '.find' do
      context 'when account does not exist' do
        it 'returns nil' do
          expect(described_class.find('unknown_account')).to be_nil
        end
      end
    end
    describe '.find!' do
      context 'when account does not exist' do
        it 'raises a Account Not Found error' do
          expect{described_class.find!('unknown_account')}.to raise_error(AccountNotFoundError)
        end
      end
    end
    describe '.destroy' do
      context 'when account does not exist' do
        it 'returns false' do
          expect(described_class.destroy('unknown_account')).to be_falsey
        end
      end

      context 'when account exists' do
        let(:attributes){ {name: 'Jon'} }

        before { described_class.create(attributes) }

        it 'returns true' do
          expect(described_class.destroy('Jon')).to be_truthy
        end
      end
    end
    describe '.destroy!' do
      context 'when account does not exist' do
        it 'raises a Account Not Found error' do
          expect{described_class.destroy!('unknown_account')}.to raise_error(AccountNotFoundError)
        end
      end
    end
    describe '#destroy' do
      it 'returns true' do
        account = described_class.create(name: 'Littefinger')
        expect(account.destroy).to be_truthy
      end
    end
  end
end
