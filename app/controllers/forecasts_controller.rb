class ForecastsController < ApplicationController
  before_action :set_current_span, :set_client
  after_action :track_metrics

  def show
    begin
      TcWeatherTracer.in_span('fetch weather data') do |span|
        @data = @open_weather_client.current_weather(forecast_params.merge(units: 'metric'))
        @calculate_api_call_duration = -> { span.end_timestamp - span.start_timestamp }
      end
    rescue Faraday::ResourceNotFound => e
      @data = { error: "Location not found: #{forecast_params.values.join(', ')}", status: 404 }
      @current_span.status = OpenTelemetry::Trace::Status.error(@data[:error])
      @current_span.record_exception(e)
    end

    render json: @data
  end

  private

  def forecast_params
    params.permit(:city, :state, :country)
  end

  def set_current_span
    @current_span = OpenTelemetry::Trace.current_span
  end

  def set_client
    @open_weather_client = OpenWeather::Client.new
  end

  def track_metrics
    # track the number of requests
    OpenWeatherApiRequestCounter.add(1)
    OpenWeatherApiResponseTimeHistogram.record(@calculate_api_call_duration.call) if @calculate_api_call_duration
  end
end
