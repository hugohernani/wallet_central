RSpec.shared_context "shared wallets", shared_context: :metadata do
  # TODO
end

RSpec.configure do |rspec|
  rspec.include_context "shared wallets", include_shared: true
end
