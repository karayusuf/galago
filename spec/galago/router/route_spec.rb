require 'spec_helper'

module Galago
  describe Router::Route do
    context "#initialize" do
      context "request method" do
        it "errors when an invalid request method is provided" do
          expect { Router::Route.new('foo', anything, lambda {})
          }.to raise_error Router::RequestMethodInvalid
        end

        it "remembers the request method" do
          Router::REQUEST_METHODS.each do |request_method|
            route = Router::Route.new(request_method, anything, lambda {})
            expect(route.request_method).to eql request_method
          end
        end
      end

      context "path" do
        it "remembers the path" do
          route = Router::Route.new('GET', '/foo', lambda {})
          expect(route.path).to eql '/foo'
        end
      end

      context "action" do
        it "raises an error when the action does not respond to call" do
          expect { Router::Route.new('PATCH', '/foo', :action)
          }.to raise_error Router::ActionInvalid
        end

        it "remembers the action" do
          action = Proc.new { 'action' }
          route = Router::Route.new('GET', '/foo', action)
          expect(route.action).to eql action
        end
      end
    end

  end
end
