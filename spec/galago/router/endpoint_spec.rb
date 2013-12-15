require 'spec_helper'

module Galago
  describe Router::Endpoint do
    context "#initialize" do
      context "request method" do
        it "errors when an invalid request method is provided" do
          expect { Router::Endpoint.new('foo', anything, lambda {})
          }.to raise_error Router::RequestMethodInvalid
        end

        it "remembers the request method" do
          Router::REQUEST_METHODS.each do |request_method|
            endpoint = Router::Endpoint.new(request_method, anything, lambda {})
            expect(endpoint.request_method).to eql request_method
          end
        end
      end

      context "path" do
        it "remembers the path" do
          endpoint = Router::Endpoint.new('GET', '/foo', lambda {})
          expect(endpoint.path.to_s).to eql '/foo'
        end
      end

      context "action" do
        it "raises an error when the action does not respond to call" do
          expect { Router::Endpoint.new('PATCH', '/foo', :action)
          }.to raise_error Router::ActionInvalid
        end

        it "remembers the action" do
          action = Proc.new { 'action' }
          endpoint = Router::Endpoint.new('GET', '/foo', action)
          expect(endpoint.action).to eql action
        end
      end
    end

  end
end
