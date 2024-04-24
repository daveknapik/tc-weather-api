class ForecastsController < ApplicationController
  before_action :set_current_span, :set_client
  after_action :track_metrics

  def show
    begin
      TcWeatherTracer.in_span('fetch weather data') do |span|
        @data =
          @open_weather_client.current_weather(
            forecast_params.merge(units: 'metric'),
          )
        @calculate_api_call_duration = -> do
          span.end_timestamp - span.start_timestamp
        end
      end
      @current_span.add_attributes(
        'data.city' => @data.name,
        'data.country' => @data.sys.country,
      )
    rescue Faraday::ResourceNotFound => e
      @data = {
        error: "Location not found: #{forecast_params.values.join(', ')}",
      }
      @current_span.status = OpenTelemetry::Trace::Status.error(@data[:error])
      @current_span.record_exception(e)
    end

    if @data.has_key?(:error)
      render json: @data, status: :not_found
    else
      render json: @data
    end
  end

  private

  def forecast_params
    params.permit(:city, :state, :country)
  end

  def set_current_span
    @current_span = OpenTelemetry::Trace.current_span
    unless forecast_params[:city].nil?
      @current_span.set_attribute('params.city', forecast_params[:city])
    end
    unless forecast_params[:state].nil?
      @current_span.set_attribute('params.state', forecast_params[:state])
    end
    unless forecast_params[:country].nil?
      @current_span.set_attribute('params.country', forecast_params[:country])
    end
  end

  def set_client
    @open_weather_client = OpenWeather::Client.new
  end

  def track_metrics
    # track the number of requests
    OpenWeatherApiRequestCounter.add(1)
    if @calculate_api_call_duration
      OpenWeatherApiResponseTimeHistogram.record(
        @calculate_api_call_duration.call,
      )
    end
  end
end
