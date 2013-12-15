# Galago

Galago is an API micro framework for Ruby.
I am building it to gain more appreciation for existing tools.

## Installation

Add this line to your application's Gemfile:

    gem 'galago'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install galago

## Usage

```ruby
module GitHub::API < Galago::API
  routes do
    get '/users' do
      'get user list'
    end

    post '/users' do
      'create a user'
    end

    patch '/users/:id' do
      'update a user'
    end

    put '/users/:id' do
      'update a user'
    end

    delete '/users/:id' do
      'delete a user'
    end
  end
end

run Foo::API
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

