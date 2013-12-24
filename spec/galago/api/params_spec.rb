require 'spec_helper'

module Galago
  describe "params" do
    application do
      routes do
        get '/params_via_string' do
          params["bar"]
        end

        get '/params/:in_path' do
          params["in_path"].to_s
        end
      end
    end

    it "can be accessed using string keys" do
      get 'params_via_string', bar: "string"
      expect(last_response.body).to eql "string"
    end

    it "extracts parameters from the request path" do
      get 'params/42'
      expect(last_response.body).to eql "42"
    end
  end
end
