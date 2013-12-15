require 'galago'
require 'rack/test'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation

  config.include Rack::Test::Methods
end
