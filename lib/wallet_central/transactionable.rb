module WalletCentral
  module Transactionable
    def add_transaction(transaction_id)
      @transaction_id = transaction_id
    end

    def remove_transaction(transaction_id)
      @transaction_id = nil
    end
  end
end
