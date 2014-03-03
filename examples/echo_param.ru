require 'galago/router'

EchoParams = lambda { |env|
  params = Rack::Request.new(env).params
  Rack::Response.new(params).finish
}

router = Galago::Router.new do
  get '/echo_params', to: EchoParams
  get '/echo_params/:name', to: EchoParams

  post '/echo_params', to: EchoParams
  put '/echo_params/:name', to: EchoParams

  delete '/echo_params', to: EchoParams
end

run router

