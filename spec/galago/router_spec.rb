require 'spec_helper'

module Galago
  describe Router do

    describe "#add_route" do
      let(:rack_app) do
        lambda { |env| "RackApp" }
      end

      it "stores the route" do
        router = Router.new
        router.add_route(:get, '/users', rack_app)

        expect(router).to have_route(:get, '/users')
      end

      it "raises an error when an invalid http verb is provided" do
        router = Router.new

        expect { router.add_route(:foo, '/foo', rack_app)
        }.to raise_error Router::RequestMethodInvalid
      end
    end

    describe "has_route?" do
      it "returns true when the route has been added" do
        router = Router.new
        router.add_route(:post, '/users', lambda {})

        expect(router).to have_route(:post, '/users')
      end

      it "returns false when the route has not been added" do
        router = Router.new
        router.add_route(:post, '/users', lambda {})

        expect(router).not_to have_route(:get, '/users')
      end
    end

  end
end
