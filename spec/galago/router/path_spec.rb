require 'spec_helper'

module Galago
  describe Router::Path do

    describe ".join" do
      it "joins the provided segments with a '/'" do
        path = Router::Path.join('foo', 'bar')
        expect(path).to eql '/foo/bar'
      end

      it "removes repeated '/'" do
        path = Router::Path.join('//foo', '///bar', '/baz')
        expect(path).to eql '/foo/bar/baz'
      end

      it "removes trailing '/'" do
        path = Router::Path.join('foo', 'bar/')
        expect(path).to eql '/foo/bar'
      end
    end

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

      it "does not recognize paths with newlines" do
        path = Router::Path.new('/users/:id')
        expect(path).not_to be_recognizes "\n/users/1"
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

    describe "#params_from" do
      let(:env) do
        { 'rack.input' => '' }
      end

      it "adds the params" do
        env['PATH_INFO'] = '/users/21/posts/42'

        path = Router::Path.new('/users/:user_id/posts/:id')
        params = path.params_from(env)

        expect(params).to eql({
          'user_id' => '21',
          'id'      => '42'
        })
      end

      it "does not add params when no path params exist" do
        env['PATH_INFO'] = '/users'

        path = Router::Path.new('/users')
        params = path.params_from(env)

        expect(params).to be_empty
      end
    end

  end
end
