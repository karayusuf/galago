require 'galago/router'
require 'rack/lobster'

router = Galago::Router.new do
  get    '/foo',       to: ->(env) { [200, {}, ['foo']] }
  post   '/bar/:bar',  to: ->(env) { [200, {}, ['bar']] }

  namespace :lobsters do
    get  '/', to: Rack::Lobster.new
    post '/', to: Rack::Lobster.new

    patch  ':name', to: Rack::Lobster.new
    put    ':name', to: Rack::Lobster.new
    delete ':name', to: Rack::Lobster.new
  end
end

run router

