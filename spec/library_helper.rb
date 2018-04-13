require 'spec_helper'

LIBRARY_PATH = File.expand_path('../../lib', __FILE__)
Dir[File.join(LIBRARY_PATH, '**', '*.rb')].each{|f| require f }
Dir[File.join(LIBRARY_PATH, 'spec', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Clear accounts on each test
  config.before(:each) { WalletCentral::Account.instance_variable_set :@accounts, nil }
end
