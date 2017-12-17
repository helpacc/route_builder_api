class RouteBuilder
  def initialize(from_lat:, from_long:, to_lat:, to_long:)
    @from = { lat: from_lat, lng: from_long }
    @to = { lat: to_lat, lng: to_long }
  end

  def build
    gmaps = GoogleMapsService::Client.new(key: ENV['GOOGLE_API_KEY'])
    result = gmaps.directions(@from, @to, mode: 'driving', alternatives: false)
    main_leg = result.first[:legs].first
    {
      minutes: main_leg.dig(:distance, :value).to_f / 1000,
      distance: main_leg.dig(:duration, :value).to_f / 60
    }
  end
end
