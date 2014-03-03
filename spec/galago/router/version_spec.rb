require 'spec_helper'

module Galago
  describe 'Router::VERSION' do
    it "0.0.1" do
      expect(Router::VERSION).to eql '0.0.1'
    end
  end
end
