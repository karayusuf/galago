require 'spec_helper'

module Galago
  describe "Routes" do
    describe "HEAD" do

      let(:app) do
        Galago::Router.new do
          get  '/users',    to: ->(env) { Rack::Response.new('get').finish }
          put '/users/:id', to: ->(env) { Rack::Response.new('put').finish }
        end
      end

      context "when a resource responds to GET requests" do
        it "adds a HEAD request to the resource" do
          head '/users'
          expect(last_response.status).to eql 200
        end

        it "has no response body" do
          head '/users'
          expect(last_response.body).to eql ''
        end

        it "knows how large the content body would have been" do
          head '/users'

          content_length = last_response.headers['Content-Length']
          expect(content_length).to eql 'get'.length.to_s
        end

        it "has the same headers as the GET request" do
          get '/users'
          get_headers = last_response.headers

          head '/users'
          head_headers = last_response.headers

          expect(get_headers).to eql head_headers
        end
      end

      context "when a resource does not respond to GET requests" do
        it "returns a 405 method not allowed" do
          head '/users/1'
          expect(last_response.status).to eql 405
        end
      end

    end
  end
end
