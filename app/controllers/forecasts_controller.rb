class ForecastsController < ApplicationController
  def show
    client = OpenWeather::Client.new(
      api_key: ENV["OPEN_WEATHER_MAP_API_KEY"]
    )

    counter = TcWeatherApiMeter.create_counter("rpm", unit: "request", description: "Requests per minute")
    counter.add(1)

    city = params[:city] || "Tokyo"

    data = client.current_weather(city: city, units: "metric")

    # TcWeatherApiMetricReader.force_flush

    render json: data
  end
end
