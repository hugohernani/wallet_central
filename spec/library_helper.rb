require 'spec_helper'
require "pry"

LIBRARY_PATH = File.expand_path('../../lib', __FILE__)
Dir[File.join(LIBRARY_PATH, '**', '*.rb')].each{|f| require f }
Dir[File.join(LIBRARY_PATH, 'spec', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) { WalletCentral::Account.instance_variable_set :@accounts, nil }
  config.before(:each) { WalletCentral::Wallet.instance_variable_set :@wallets, nil }
  config.before(:each) { WalletCentral::Connections::Base.class_variable_set :@@collection, nil }
end
