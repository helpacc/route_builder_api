require 'rack/test'
require 'webmock/rspec'
require_relative '../app'

RSpec.describe 'Route Builder API' do
  include Rack::Test::Methods

  describe 'GET /v1/build_route' do
    def ask_api_for_route(query)
      get('/v1/build_route', query)
    end

    def coord_params(except: nil)
      default = { from_lat: '60', from_long: '60', to_lat: '60', to_long: '60' }
      default.reject { |key, _| except == key }
    end

    before do
      stub_request(:get, 'https://maps.googleapis.com/maps/api/directions/json')
        .with(query: hash_including(:destination, :key, :mode, :origin))
        .to_return(body: fake_google_api_response)
    end

    it 'responds successfully with JSON object' do
      ask_api_for_route(coord_params)
      expect(last_response.status).to eq 200
      expect(last_response.header['Content-Type']).to eq 'application/json'
      expect(json_body).to be_a(Hash)
    end

    it 'returns "minutes" and "distance" attributes' do
      ask_api_for_route(coord_params)
      expect(json_body['minutes']).to be_an(Integer)
      expect(json_body['distance']).to be_a(Float)
    end

    it 'requires all coordinates' do
      %i[from_lat from_long to_lat to_long].each do |param_name|
        ask_api_for_route(coord_params(except: param_name))
        expect(last_response.status).to eq 422
      end
    end
  end

  # move helper methods below to reduce mental load on reading the file
  def app
    Sinatra::Application
  end

  # don't memoize value to support multiple requests per example
  def json_body
    JSON.parse(last_response.body)
  end

  def fake_google_api_response
    <<-STR
      {
       "routes" : [
          {
            "legs" : [
              {
                "distance" : { "text" : "34.2 km", "value" : 34225 },
                "duration" : { "text" : "41 mins", "value" : 2462 }
              }
            ]
          }
       ],
       "status" : "OK"
      }
    STR
  end
end
