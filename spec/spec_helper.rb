require 'simplecov'
SimpleCov.start

ENV['TEST_ENV'] = 'true'

require 'bundler/setup'
require 'byebug'

require 'b_commerce'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:each) do
    Excon.stubs.clear
    BCommerce::Base.setup(client_id: nil, store_hash: nil, auth_token: nil)
  end
end
