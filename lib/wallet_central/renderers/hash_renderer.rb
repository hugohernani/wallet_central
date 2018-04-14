require_relative 'base'

module WalletCentral
  module Renderers
    class HashRenderer < Base
      def render(resource, attributes)
        arr = attributes.map{|attr| [attr, resource.send(:"#{attr}")]}.flatten
        Hash[*arr]
      end
    end
  end
end
