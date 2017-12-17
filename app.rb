require 'sinatra'
require 'sinatra/json'

get '/v1/build_route' do
  sleep 0.5
  json(minutes: 7, distance: 10.4)
end
