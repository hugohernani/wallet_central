module WalletCentral
  module Transactions
    class Base
      def details
        raise NotImplementedError
      end

      def rollback
        raise NotImplementedError
      end
    end
  end
end
