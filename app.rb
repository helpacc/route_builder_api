require 'sinatra'
require 'sinatra/json'
require 'google_maps_service'
require_relative 'lib/route_builder'

set :show_exceptions, false

get '/v1/build_route' do
  return abort_on_coords_missing if any_coord_missing?
  route = build_route
  json(minutes: route[:minutes], distance: route[:distance])
end

private

def any_coord_missing?
  %i[from_lat from_long to_lat to_long].detect do |param_name|
    params[param_name].to_s.empty?
  end
end

def abort_on_coords_missing
  status :unprocessable_entity
  json(message: 'from_lat, from_long, to_lat, to_long should be set')
end

def build_route
  RouteBuilder.new(
    from_lat: params['from_lat'],
    from_long: params['from_long'],
    to_lat: params['to_lat'],
    to_long: params['to_long']
  ).build
end
