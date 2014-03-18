require 'spec_helper'

module Galago
  describe 'Router::VERSION' do
    it "current" do
      expect(Router::VERSION).to eql '0.1.0'
    end
  end
end
