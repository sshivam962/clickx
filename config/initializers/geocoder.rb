Geocoder.configure(
  lookup: :google, google: { api_key: ENV['GEOCODE_API_KEY'] },
  ip_lookup: :ipstack, ipstack: { api_key: ENV['GEOCODE_IP_API_KEY'] }
)
