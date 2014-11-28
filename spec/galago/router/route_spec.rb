require 'spec_helper'
require 'pry'

module Galago
  describe Router::Route do
    context "#call" do
      let(:env) do
        { 'rack.input' => '' }
      end

      let(:action) do
        lambda { |env| "foo" }
      end

      context "when the request method is allowed" do
        it "adds the named params to the env" do
          env['PATH_INFO'] = '/users/bob'

          route = Router::Route.new('/users/:name')
          route.add_endpoint('GET', action)

          route.call(env)

          extracted_params = env['galago_router.params']
          expect(extracted_params).to eql('name' => 'bob')
        end

        it "adds the path to the env" do
          route = Router::Route.new('/foo/:id')
          route.add_endpoint('GET', action)

          route.call(env)

          expect(env['galago_router.path']).to eql '/foo/:id'
        end

        it "calls the route's action" do
          route = Router::Route.new('/bar')
          route.add_endpoint('GET', action)

          expect(action).to receive(:call).with(env)

          env['REQUEST_METHOD'] = 'GET'
          route.call(env)
        end
      end

      context "when the request method is not allowed" do
        let(:route) do
          route = Router::Route.new('/foo')
          route.add_endpoint('GET', lambda { |env| 'foo' })
          route.add_endpoint('PUT', lambda { |env| 'foo' })
          route
        end

        it "has a 405 status code" do
          env['REQUEST_METHOD'] = 'DELETE'
          response = route.call(env)

          status = response[0]
          expect(status).to eql(405)
        end

        it "sets the 'Allow' header" do
          env['REQUEST_METHOD'] = 'DELETE'
          response = route.call(env)

          headers = response[1]
          expect(headers['Allow']).to eql 'GET, OPTIONS, PUT'
        end
      end
    end

    context "allowed_methods" do
      let(:route) { Router::Route.new('/users/:id/posts') }

      it "allows OPTIONS by default" do
        expect(route.allowed_methods).to eql ['OPTIONS']
      end

      it "has an allowed method for each endpoint" do
        route.add_endpoint('POST', anything)
        route.add_endpoint('PUT', anything)

        expect(route.allowed_methods).to eql ['OPTIONS', 'POST', 'PUT']
      end

      it "lists the allowed methods in alphabetical order" do
        route.add_endpoint('POST', anything)
        route.add_endpoint('DELETE', anything)
        route.add_endpoint('GET', anything)

        allowed_methods = route.allowed_methods
        expect(allowed_methods).to eql ['DELETE', 'GET', 'OPTIONS', 'POST']
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
        expect(path.named_parameters).to be_empty
      end

      it "returns segments starting with a ':'" do
        path = Router::Path.new('/accounts/:account_id/users/:id')
        expect(path.named_parameters).to eql ['account_id', 'id']
      end
    end

    context "path" do
      it "remembers the path" do
        route = Router::Route.new('/foo')
        expect(route.path.to_s).to eql '/foo'
      end
    end
  end
end

