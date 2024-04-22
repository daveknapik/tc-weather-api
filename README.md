# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Prerequisites

- Ruby version: 3.3.0

## Configuration

- Sign up for an OpenWeatherMap API KEY
- Copy `.env.template` to `.env` and set `OPEN_WEATHER_MAP_API_KEY` to the value of your new API KEY

## Running the app locally 

### With telemetry, sent to console

You can run the app locally with telemetry output sent to console like so:

`env OTEL_TRACES_EXPORTER=console OTEL_METRICS_EXPORTER=console rails server -p 8080`

### With telemetry data exported to a local Jaeger container

Alternatively, if you would like to explore your traces in a UI, you can quickly run a Docker container of Jaeger like so (prerequisites: Docker):

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

Start the app: `env OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4318" rails server -p 8080`

Then navigate to http://localhost:16686/.

### Zipkin

```shell
$ docker run --rm -d -p 9411:9411 --name zipkin openzipkin/zipkin

$ env OTEL_TRACES_EXPORTER=zipkin rails server
```

Learn more about exporters at https://opentelemetry.io/docs/languages/ruby/exporters/

### Signoz

```shell
OTEL_EXPORTER=otlp \
OTEL_SERVICE_NAME=tc-weather-api \
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318 \
rails server
```

--- 
* System dependencies
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions
