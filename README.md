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
module GitHub::Application < Galago::Application
  routes do
    get '/users' do
      users = User.all
    end

    post '/users' do
      user = User.create! params['user']
    end

    patch '/users/:name' do
      user = User.find_by_name params['name']
      user.update! params['user']
    end

    put '/users/:name' do
      user = User.find_by_name params['name']
      user.update! params['user']
    end

    delete '/users/:name' do
      user = User.find_by_name params['name']
      user.destroy!
    end
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

