require 'galago/router'
require 'rack/lobster'

router = Galago::Router.new do
  get '/lobster', to: Rack::Lobster.new
end

run router

