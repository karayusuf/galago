require 'spec_helper'

module Galago
  describe Router do
    describe 'routes' do
      it 'adds the specified routes' do
        router = Router.new do
          get    '/foo' , to: lambda { |env| 'bar' }
          post   '/foo' , to: lambda { |env| 'bar' }
          patch  '/foo' , to: lambda { |env| 'bar' }
          put    '/foo' , to: lambda { |env| 'bar' }
          delete '/foo' , to: lambda { |env| 'bar' }
        end

        expect(router).to have_route('GET', '/foo')
        expect(router).to have_route('POST', '/foo')
        expect(router).to have_route('PATCH', '/foo')
        expect(router).to have_route('PUT', '/foo')
        expect(router).to have_route('DELETE', '/foo')
      end

      it 'adds the namespace to the route' do
        router = Router.new do
          namespace :foo do
            get  '/', to: ->(env) { [200, {}, ['foo']] }
            post '/', to: ->(env) { [200, {}, ['post foo']] }

            get    '/:foo', to: ->(env) { [200, {}, ['get :foo']] }
            patch  '/:foo', to: ->(env) { [200, {}, ['patch :foo']] }
            put    '/:foo', to: ->(env) { [200, {}, ['put :foo']] }
            delete '/:foo', to: ->(env) { [200, {}, ['delete :foo']] }
          end
        end

        expect(router).to have_route('GET', '/foo')
        expect(router).to have_route('POST', '/foo')

        expect(router).to have_route('GET', '/foo/1')
        expect(router).to have_route('PATCH', '/foo/2')
        expect(router).to have_route('PUT', '/foo/3')
        expect(router).to have_route('DELETE', '/foo/4')
      end

      it 'can have multiple namespaces' do
        router = Router.new do
          namespace :foo do
            get '/', to: ->(env) { [200, {}, ['foo']] }

            namespace :bar do
              get '/',    to: ->(env) { [200, {}, ['foo bar']] }
              get ':bar', to: ->(env) { [200, {}, ['foo bar']] }
            end
          end

          namespace :hello do
            get '/', to: ->(env) { [200, {}, ['hello']] }
          end
        end

        expect(router).to have_route('GET', '/foo')
        expect(router).to have_route('GET', '/foo/bar')
        expect(router).to have_route('GET', '/foo/bar/1')
        expect(router).to have_route('GET', '/hello')
      end
    end

    describe "#add_route" do
      let(:rack_app) do
        lambda { |env| "RackApp" }
      end

      it "stores the route" do
        router = Router.new
        router.add_route('GET', '/users', rack_app)

        expect(router).to have_route('GET', '/users')
      end
    end

    describe "has_route?" do
      it "returns true when the route has been added" do
        router = Router.new
        router.add_route('POST', '/users', lambda {})

        expect(router).to have_route('POST', '/users')
      end

      it "returns true when the route has a path param" do
        router = Router.new
        router.add_route('GET', '/users/:id', lambda {})

        expect(router).to have_route('GET', '/users/42')
      end

      it "returns false when the route has not been added" do
        router = Router.new
        router.add_route('POST', '/users', lambda {})

        expect(router).not_to have_route('GET', '/users')
      end
    end

    describe "#call" do
      it "calls the rack app when the route is found" do
        router = Router.new do
          get '/foo', to: lambda { |env| [200, {}, 'bar'] }
        end

        response = router.call({
          'rack.input' => '',
          'REQUEST_METHOD' => 'GET',
          'PATH_INFO' => '/foo'
        })

        expect(response).to eql [200, {}, 'bar']
      end

      it "returns 404 when no route matchs the path" do
        router = Router.new

        response = router.call({
          'rack.input' => '',
          'REQUEST_METHOD' => 'GET',
          'PATH_INFO' => '/bar'
        })

        expect(response[0]).to eql(404)
        expect(response[1]).to eql({ 'Content-Length' => '9' })
        expect(response[2].body).to eql(['Not Found'])
      end
    end

    describe "responses" do
      context "method not allowed" do
        let(:app) do
          Router.new do
            get '/foo', to: lambda { |env| [200, {}, ['foo']] }
          end
        end

        it 'sets the status code to 405' do
          post '/foo'
          expect(last_response.status).to eql(405)
        end

        it "sets the 'Allow' header to the allowed methods" do
          post '/foo'

          allow = last_response.headers.fetch('Allow')
          expect(allow).to eql 'GET, OPTIONS'
        end
      end
    end

  end
end
