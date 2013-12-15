require 'spec_helper'

module Galago
  describe "params" do
    example_api do
      routes do
        get '/params_via_string', lambda { |env| params["bar"] }
      end
    end

    it "can be accessed using string keys" do
      get 'params_via_string', bar: "string"
      expect(last_response.body).to eql "string"
    end
  end
end
