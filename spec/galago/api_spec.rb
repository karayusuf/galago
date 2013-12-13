require 'galago'
require 'rack/test'

module Galago
  describe API do
    class ExampleApi < Galago::API
      routes do
        get    '/users',     lambda { |env| 'get'    }
        post   '/users',     lambda { |env| 'post'   }
        patch  '/users/:id', lambda { |env| 'patch'  }
        put    '/users/:id', lambda { |env| 'put'    }
        delete '/users/:id', lambda { |env| 'delete' }
      end
    end

    let(:app) { ExampleApi }

    describe ".call" do
      include Rack::Test::Methods

      context "successful request" do
        it "has a 200 response code" do
          get '/users'
          expect(last_response.status).to eql(200)
        end

        it "sets the response body to the value of the block" do
          get '/users'
          expect(last_response.body).to eql('get')
        end
      end

      context "not found" do
        it "has a 404 response code" do
          get '/does/not/exist'
          expect(last_response.status).to eql(404)
        end

        it "has a response body of Not Found" do
          get '/does/not/exist'
          expect(last_response.body).to eql('Not Found')
        end
      end
    end

    describe ".routes" do
      subject { ExampleApi.router }

      it "has a get route" do
        expect(subject).to have_route(:get, '/users')
      end

      it "has a post route" do
        expect(subject).to have_route(:post, '/users')
      end

      it "has a patch route" do
        expect(subject).to have_route(:patch, '/users/:id')
      end

      it "has a put route" do
        expect(subject).to have_route(:put, '/users/:id')
      end

      it "has a delete route" do
        expect(subject).to have_route(:delete, '/users/:id')
      end
    end
  end
end
