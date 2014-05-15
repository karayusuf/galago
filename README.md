# Galago Router

Simple, efficient router for rack applications.

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

## Routes

### OPTIONS

OPTIONS endpoints are automatically defined for each resource provided. The
response will contain an ALLOW header listing the request methods the resource
supports.

### HEAD

HEAD endpoints are automatically defined for each resource that supports GET.


## Environment

The router adds information about the route that was called to the environment.
All requests will have the following keys added:

| Key                  | Example Value |
| :------------------- | :------------ |
| galago_router.path   | '/users/:id'  |
| galago_router.params | { id: 42 }    |


## Responses

### 405 Method Not Allowed

In the event a path is requested with an unsupported method, the router will return a method not allowed response.
This consists of a 405 status code and an 'Allow' header listing the valid request methods. 

More information: http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

