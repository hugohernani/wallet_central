module WalletCentral
  module Renderers
    class Base
      def render(resource, attributes)
        raise NotImplementedError
      end
    end
  end
end
