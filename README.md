# TC Weather API

An overview of the application, its purpose, and potential use cases

TC Weather API is a simple wrapper around the OpenWeatherMap 2.5 current weather API that adds in OpenTelemetry for observability.

Potential use cases include:

- Get the current weather anywhere in the world using only a city name
  - Additionally limit by state (US-only) and country
- Use popular tracing platforms like [Jaeger](https://www.jaegertracing.io/) to analyze collected trace data about this app and the weather API it uses
- Use as a template / proof of concept for your own Rails-based OpenTelemetry projects that may have nothing to do with the weather: dream big, but measure the dream! :)

## Prerequisites

- Ruby version: 3.3.0
- Docker (for running Jaeger locally)

## Configuration

- Clone this repository
- Make sure you have the necessary Ruby version installed (see Prerequisites above)
- Run `bundle install` in the project root
- Sign up for an [OpenWeatherMap API KEY](https://home.openweathermap.org/api_keys)
- Copy `.env.template` to `.env` and set `OPEN_WEATHER_MAP_API_KEY` to the value of your new API KEY

## Running the app locally

### Without telemetry

Start the local server with `rails s` in the project root and navigate to http://localhost:3000/forecasts/Tokyo as an example. Change the city as needed.

### With telemetry, sent to console

You can run the app locally with telemetry output sent to console like so:

`env OTEL_TRACES_EXPORTER=console OTEL_METRICS_EXPORTER=console rails server -p 8080`

- Navigate to http://localhost:8080/forecasts/Tokyo
- Look at the console window where you started the server to view telemetry output

### With telemetry data exported to a local Jaeger container

Alternatively, if you would like to explore your traces in a UI (highly recommended), you can quickly run a Docker container of Jaeger like so (prerequisites: Docker):

```shell
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:latest
```

- Start the app server with this command: `env OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4318" rails server -p 8080`
- Navigate to http://localhost:8080/forecasts/Tokyo
- Experiment with a few more API requests with different cities
- Navigate to http://localhost:16686/ and use the Jaeger UI to explore your traces

Learn more about exporters at https://opentelemetry.io/docs/languages/ruby/exporters/

### Important note about Jaeger and Metrics

This application records traces and metrics, but Jaeger UI only supports tracing. Currently the app sends metrics output to the console even with the above Jaeger instructions. Look at your console output to see metrics output, which is currently sent every 60 seconds.

## API docs

TODO: API endpoint, request/response formats, and examples of usage

### Usage examples

http://localhost:8080/forecasts/Springfield?state=MO&country=US

## Recommendations on how the API could be improved or extended to cater to a broader audience
