source "https://rubygems.org"

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

# Gem for accessing the OpenWeatherMap API
gem "open-weather-ruby-client", "~> 0.4"

# OpenTelemetry is a set of APIs, libraries, agents, and instrumentation to provide observability
gem "opentelemetry-api", github: "open-telemetry/opentelemetry-ruby", tag: "opentelemetry-sdk-experimental/v0.3.2"
gem "opentelemetry-sdk", github: "open-telemetry/opentelemetry-ruby", tag: "opentelemetry-sdk-experimental/v0.3.2"

# See https://github.com/open-telemetry/opentelemetry-ruby/blob/main/exporter/otlp-metrics/README.md
gem 'opentelemetry-metrics-api', github: "open-telemetry/opentelemetry-ruby", glob: 'metrics_api/*.gemspec'
gem "opentelemetry-metrics-sdk", github: "xuan-cao-swi/opentelemetry-ruby", branch: "periodic-reader", glob: 'metrics_sdk/*.gemspec'
gem "opentelemetry-exporter-otlp-metrics", github: "open-telemetry/opentelemetry-ruby", glob: "exporter/otlp-metrics/*.gemspec"

gem 'opentelemetry-exporter-otlp', '~> 0.26.3'
gem "opentelemetry-exporter-zipkin", "~> 0.23.1"
gem "opentelemetry-instrumentation-all", "~> 0.60.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]

  # Use pry for debugging
  gem "pry", "~> 0.14.2"

  # Environment variable management
  gem "dotenv"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Use solargraph editor extension
  gem "solargraph"
  gem "solargraph-rails"
end


