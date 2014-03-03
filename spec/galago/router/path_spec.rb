require 'spec_helper'

module Galago
  describe Router::Path do

    describe "#recognizes?" do
      it "recognizes exact matches" do
        path = Router::Path.new('/users')
        expect(path).to be_recognizes '/users'
      end

      it "recognizes parameters matches" do
        path = Router::Path.new('/users/:id')
        expect(path).to be_recognizes '/users/1'
      end

      it "does not recognize exact param matches" do
        path = Router::Path.new('/users/:id')
        expect(path).not_to be_recognizes '/users/:id'
      end
    end

    describe "#to_s" do
      it "returns the path as a string" do
        path = Router::Path.new(:foo)
        expect(path.to_s).to eql 'foo'
      end
    end

    describe "#named_parameters" do
      it "returns path segments starting with a ':'" do
        path = Router::Path.new('/users/:user_id/posts/:id')
        expect(path.named_parameters).to eql ['user_id', 'id']
      end

      it "returns empty when no segments begin with a ':'" do
        path = Router::Path.new('/users')
        expect(path.named_parameters).to be_empty
      end
    end

    describe "#add_path_params_to_env" do
      let(:env) do
        { 'rack.input' => anything }
      end

      it "adds the params" do
        env['PATH_INFO'] = '/users/21/posts/42'

        path = Router::Path.new('/users/:user_id/posts/:id')
        path.add_path_params_to_env(env)

        request = Rack::Request.new(env)
        expect(request.params).to eql({
          'user_id' => '21',
          'id'      => '42'
        })
      end

      it "does not add params when no path params exist" do
        env['PATH_INFO'] = '/users'

        path = Router::Path.new('/users')
        path.add_path_params_to_env(env)

        request = Rack::Request.new(env)
        expect(request.params).to be_empty
      end
    end

  end
end
