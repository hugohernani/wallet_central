require 'json'
require_relative 'base'

module WalletCentral
  module RenderAdapters
    class JsonAdapter < Base
      def perform(result)
        JSON.generate(result)
      end
    end
  end
end
