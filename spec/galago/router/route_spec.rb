require 'spec_helper'
require 'pry'

module Galago
  describe Router::Route do
    context "#call" do
      let(:env) do
        { 'PATH_INFO' => '/foo', 'rack.input' => '' }
      end

      let(:action) do
        lambda { |env| "foo" }
      end

      it "adds the named params to the env" do
        env['PATH_INFO'] = '/users/bob'


        route = Router::Route.new('GET', '/users/:name', action)
        route.call(env)

        expect(env['galago_router.params']).to eql({
          'name' => 'bob'
        })
      end

      it "adds the path to the env" do
        route = Router::Route.new('GET', '/foo/:id', action)
        route.call(env)

        expect(env['galago_router.path']).to eql '/foo/:id'
      end

      it "calls the route's action" do
        route = Router::Route.new('GET', '/bar', action)
        expect(action).to receive(:call).with(env)

        route.call(env)
      end
    end

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

      context "#recognizes?" do
        it "recognizes a paths with no named parameters" do
          path = Router::Path.new('/users')
          expect(path).to be_recognizes('/users')
        end

        it "recognizes a path with named parameters" do
          path = Router::Path.new('/users/:id')
          expect(path).to be_recognizes('/users/32')
        end
      end

      context "#named_parameters" do
        it "has none when no segments start with a ':'" do
          path = Router::Path.new('/users')
          expect(path).to have(0).named_parameters
        end

        it "returns segments starting with a ':'" do
          path = Router::Path.new('/accounts/:account_id/users/:id')
          expect(path.named_parameters).to eql ['account_id', 'id']
        end
      end

      context "path" do
        it "remembers the path" do
          route = Router::Route.new('GET', '/foo', lambda {})
          expect(route.path.to_s).to eql '/foo'
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

