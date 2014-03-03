# Galago Router

A rack router.

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
  get    '/lobsters',       to: Rack::Lobster.new
  post   '/lobsters',       to: Rack::Lobster.new
  patch  '/lobsters/:name', to: Rack::Lobster.new
  put    '/lobsters/:name', to: Rack::Lobster.new
  delete '/lobsters/:name', to: Rack::Lobster.new
end

run router
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

