require 'galago'
require 'rack/test'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation

  config.include Rack::Test::Methods

  def example_api(&block)
    let(:app) do
      klass = Class.new(Galago::API)
      klass.class_eval(&block)
      klass
    end
  end
end
