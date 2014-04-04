require 'spec_helper'

module Galago
  describe "Routes" do
    describe "OPTIONS" do
      let(:app) do
        Galago::Router.new do
          get  '/users', to: lambda { |env| [200, {}, ['get']] }
          post '/users', to: lambda { |env| [200, {}, ['post']] }
        end
      end

      context "when the resource has been defined" do
        it "returns 200" do
          options '/users'
          expect(last_response.status).to eql 200
        end

        it "lists which request methods have been defined" do
          options '/users'

          allow_header = last_response.headers['Allow']
          expect(allow_header).to eql 'GET, OPTIONS, POST'
        end
      end

      context "when the resource has not been defined" do
        it "returns 404" do
          options '/users/42'
          expect(last_response.status).to eql 404
        end
      end

    end
  end
end
