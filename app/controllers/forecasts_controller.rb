class ForecastsController < ApplicationController
  def show
    client = OpenWeather::Client.new(
      api_key: ENV["OPEN_WEATHER_MAP_API_KEY"]
    )

    city = params[:city] || "Tokyo"

    data = client.current_weather(city: city, units: "metric")

    render json: data
  end
end
