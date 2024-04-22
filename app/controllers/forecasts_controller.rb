class ForecastsController < ApplicationController
  after_action :send_histogram_metrics, only: :show

  def show
   current_span = OpenTelemetry::Trace.current_span
    # initialize the OpenWeatherMap client
    client = OpenWeather::Client.new(
      api_key: ENV["OPEN_WEATHER_MAP_API_KEY"]
    ) 
    current_span.add_event("OpenWeatherMap client initialized") 
    
    # track the number of requests
    OpenWeatherApiRequestCounter.add(1)

    # fetch the weather data
    begin
      data = {}
      fetch_weather_data_span = nil
      TcWeatherTracer.in_span("fetch weather data") do |s|
        data = client.current_weather(city: params[:city], units: "metric")
        fetch_weather_data_span = s
      end
      duration = fetch_weather_data_span.end_timestamp - fetch_weather_data_span.start_timestamp
      OpenWeatherApiResponseTimeHistogram.record(duration, attributes: {'foo' => 'bar'})
    rescue Faraday::ResourceNotFound => e
      data = { error: "City not found: #{params[:city]}", status: 404 }
      current_span.status = OpenTelemetry::Trace::Status.error(data[:error])
      current_span.record_exception(e)
    end

    render json: data
  end

  private

  def send_histogram_metrics
    
  end
end
