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

      context "#identify_params_in_path" do
        it "does not find named parameters when the path has none" do
          path = Router::Path.new('/accounts')
          identified_parameters = path.identify_params_in_path('/accounts')

          expect(identified_parameters).to be_empty
        end

        it "maps the names for params in the path" do
          path = Router::Path.new('/accounts/:account_id/users/:id')
          identified_parameters = path.identify_params_in_path('/accounts/42/users/11')

          expect(identified_parameters).to eql({
            'account_id' => '42',
            'id'         => '11'
          })
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
