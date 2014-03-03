require 'galago/router'
require 'rack/test'
require 'pry'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation

  config.include Rack::Test::Methods
end
