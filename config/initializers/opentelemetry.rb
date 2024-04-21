# config/initializers/opentelemetry.rb
require 'opentelemetry/sdk'
require 'opentelemetry/instrumentation/all'
require 'opentelemetry-exporter-otlp'
require 'opentelemetry-exporter-zipkin'


module OpenTelemetry
  module SDK
    module Metrics
      module Export
        # Outputs {SpanData} to the console.
        #
        # Potentially useful for exploratory purposes.
        class ConsoleExporter
          def initialize
            @stopped = false
          end

          def export(spans, timeout: nil)
            return FAILURE if @stopped

            Array(spans).each { |s| pp s }

            SUCCESS
          end

          def force_flush(timeout: nil)
            SUCCESS
          end

          def shutdown(timeout: nil)
            @stopped = true
            SUCCESS
          end
        end
      end
    end
  end
end


OpenTelemetry::SDK.configure do |c|
  c.service_name = 'tc-weather-api'
  c.use_all # enable all instrumentation
end

TcWeatherApiConsoleExporter = OpenTelemetry::SDK::Metrics::Export::ConsoleExporter.new
TcWeatherApiMetricReader = OpenTelemetry::SDK::Metrics::Export::PeriodicMetricReader.new(interval_millis: 5, timeout_millis: 5, exporter: TcWeatherApiConsoleExporter)
OpenTelemetry.meter_provider.add_metric_reader(TcWeatherApiMetricReader)


TcWeatherApiMeter = OpenTelemetry.meter_provider.meter("tc-weather-api-meter")
