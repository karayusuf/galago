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

    describe "#identify_params_in_path" do
      it "identifies each param and its value" do
        path = Router::Path.new('/users/:user_id/posts/:id')
        path_params = path.identify_params_in_path('/users/1/posts/2')

        expect(path_params).to eql({
          'user_id' => '1',
          'id'      => '2'
        })
      end

      it "returns empty when no path params are present" do
        path = Router::Path.new('/users')
        expect(path.identify_params_in_path('/users')).to be_empty
      end
    end

  end
end
