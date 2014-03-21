# Galago Router

Simple, efficient routing for rack applications.

## Installation

Add this line to your application's Gemfile:

    gem 'galago-router'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install galago-router

## Usage

```ruby
# config.ru
require 'galago/router'
require 'rack/lobster'

router = Galago::Router.new do
  get    '/foo',       to: ->(env) { [200, {}, ['foo']] }
  post   '/bar/:bar',  to: ->(env) { [200, {}, ['bar']] }

  namespace 'lobsters' do
    get  '/', to: Rack::Lobster.new
    post '/', to: Rack::Lobster.new

    patch  ':name', to: Rack::Lobster.new
    put    ':name', to: Rack::Lobster.new
    delete ':name', to: Rack::Lobster.new
  end
end

run router
```

## Environment

The router adds information about the route that was called to the environment.
All requests will have the following keys added:

| Key                  | Example Value |
| :------------------- | :------------ |
| galago_router.path   | '/users/:id'  |
| galago_router.params | { id: 42 }    |


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

