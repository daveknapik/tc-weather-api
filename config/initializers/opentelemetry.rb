require 'opentelemetry/sdk'
require 'opentelemetry/instrumentation/all'
require 'opentelemetry-exporter-otlp'
require 'opentelemetry/exporter/otlp_metrics'
require 'opentelemetry/sdk/metrics/export/console_exporter'

OpenTelemetry::SDK.configure do |c|
  c.service_name = 'tc-weather-api'
  c.use 'OpenTelemetry::Instrumentation::ActiveSupport'
  c.use 'OpenTelemetry::Instrumentation::ActionPack'
  c.use 'OpenTelemetry::Instrumentation::Rack'
  c.use 'OpenTelemetry::Instrumentation::ActiveJob'
  c.use 'OpenTelemetry::Instrumentation::ActiveRecord'
  c.use 'OpenTelemetry::Instrumentation::ActionView'
  c.use 'OpenTelemetry::Instrumentation::ConcurrentRuby'
  c.use 'OpenTelemetry::Instrumentation::Faraday'
  c.use 'OpenTelemetry::Instrumentation::Net::HTTP'
  c.use 'OpenTelemetry::Instrumentation::Rails'
end

TcWeatherTracer = OpenTelemetry.tracer_provider.tracer('tc-weather-api-tracer')

# create metrics exporters
console_exporter = OpenTelemetry::SDK::Metrics::Export::ConsoleExporter.new
otlp_metric_exporter = OpenTelemetry::Exporter::OTLP::MetricsExporter.new

# create a periodic reader for metrics and pair it with the exporter
metric_reader = OpenTelemetry::SDK::Metrics::Export::PeriodicMetricReader.new(export_interval: 60, export_timeout: 10, exporter: console_exporter)

# pair the reader with the provider
OpenTelemetry.meter_provider.add_metric_reader(metric_reader)

# create a meter
meter = OpenTelemetry.meter_provider.meter('tc-weather-api-meter')

# TODO: Find a better place for these global instruments (e.g. OpenTelemetry::Context object)
OpenWeatherApiRequestCounter = meter.create_counter('requests-to-open-weather-api', unit: 'request', description: 'Counter to track requests to the OpenWeatherMap API')
OpenWeatherApiResponseTimeHistogram = meter.create_histogram('open-weather-api-response-time', unit: 'ns', description: 'Response time in nanoseconds')
