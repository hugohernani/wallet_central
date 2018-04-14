module WalletCentral
  module RenderAdapters
    class Base
      def perform(res)
        raise NotImplementedError
      end
    end
  end
end
