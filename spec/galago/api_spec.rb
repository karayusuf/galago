require 'spec_helper'

module Galago
  describe Application do
    class ExampleApi < Galago::Application
      routes do
        get '/users' do
          'get'
        end

        get '/nil/body' do
          nil
        end

        get '/users/:id', to: proc { "Specific user" }

        post '/users' do
          'post'
        end

        patch '/users/:id' do
          'patch'
        end

        put '/users/:id' do
          'put'
        end

        delete '/users/:id' do
          'delete'
        end

        get '/errors/standard' do
          raise StandardError.new("Error")
        end
      end
    end

    let(:app) { ExampleApi }

    describe ".call" do
      context "successful request" do
        it "has a 200 response code" do
          get '/users'
          expect(last_response.status).to eql(200)
        end

        it "sets the response body to the value of the block" do
          get '/users'
          expect(last_response.body).to eql('get')
        end

        it "calls the provided application" do
          get '/users/1'
          expect(last_response.body).to eql('Specific user')
        end

        it "converts the response to a string" do
          get '/nil/body'
          expect(last_response.body).to eql('')
        end
      end

      context "errors" do
        it "has a 500 response code" do
          get '/errors/standard'
          expect(last_response.status).to eql(500)
        end

        it "has a response body of the error message" do
          get '/errors/standard'
          expect(last_response.body).to eql "Error"
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
        expect(subject).to have_route(:patch, '/users/1')
      end

      it "has a put route" do
        expect(subject).to have_route(:put, '/users/2')
      end

      it "has a delete route" do
        expect(subject).to have_route(:delete, '/users/4')
      end
    end
  end
end
