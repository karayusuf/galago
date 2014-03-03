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
class MyApp < Galago::Router
  routes do
    get '/users',  to: YourRackApp
    post '/users', to: AnotherRackApp
    patch '/users', to: YetAnotherRackApp
    put '/users/:name', to: MoreRackApp
    delete '/users/:name', to: DeleteRackApp
  end
end

run GitHub::Application
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

