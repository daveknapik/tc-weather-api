# TC Weather API

TC Weather API is a simple wrapper around the [OpenWeatherMap 2.5 current weather API](https://openweathermap.org/current) that adds OpenTelemetry for observability.

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

### GET /forecasts/:city

#### Parameters

| Name    | Required? | Type   | Description                                                                                                                   |
| ------- | --------- | ------ | ----------------------------------------------------------------------------------------------------------------------------- |
| city    | true      | string | City name                                                                                                                     |
| state   | false\*   | string | State name (US only, [two-letter abbreviation](https://en.wikipedia.org/wiki/List_of_U.S._state_and_territory_abbreviations)) |
| country | false\*   | string | Country code ([two-letter ISO 3166 standard abbreviation](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes))      |

\* Note that if you specify state, you must also specify country in order for the OpenWeatherMap API to find the location. State and country are otherwise optional parameters.

#### Usage examples

##### Get the current weather for a city using only its name

http://localhost:8080/forecasts/Tokyo

```json
{
  "coord": {
    "lon": 139.6917,
    "lat": 35.6895
  },
  "weather": [
    {
      "icon_uri": "http://openweathermap.org/img/wn/10d@2x.png",
      "icon": "10d",
      "id": 501,
      "main": "Rain",
      "description": "moderate rain"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 15.08,
    "feels_like": 15.02,
    "temp_min": 14.25,
    "temp_max": 15.9,
    "pressure": 1012,
    "humidity": 91
  },
  "visibility": 6000,
  "wind": {
    "speed": 4.63,
    "deg": 50
  },
  "clouds": {
    "all": 75
  },
  "rain": {
    "1h": 1.33
  },
  "snow": null,
  "dt": "2024-04-24T05:18:57.000Z",
  "sys": {
    "type": 2,
    "id": 268395,
    "country": "JP",
    "sunrise": "2024-04-23T19:57:08.000Z",
    "sunset": "2024-04-24T09:21:17.000Z"
  },
  "id": 1850144,
  "timezone": 32400,
  "name": "Tokyo",
  "cod": 200
}
```

##### Multiple cities with the same name in different countries

###### Get the current weather for the city of York (no country specified)

In this first example, we only supply the required city name parameter and the API chooses one of the Yorks for us: the one in United States, as evidenced by how these coordinates match those of the US-specific call in the third example `"coord":{"lon":-77,"lat":40.1254}`.

http://localhost:8080/forecasts/York

```json
{
  "coord": {
    "lon": -77,
    "lat": 40.1254
  },
  "weather": [
    {
      "icon_uri": "http://openweathermap.org/img/wn/01n@2x.png",
      "icon": "01n",
      "id": 800,
      "main": "Clear",
      "description": "clear sky"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 11.9,
    "feels_like": 10.87,
    "temp_min": 10.14,
    "temp_max": 13.55,
    "pressure": 1011,
    "humidity": 66
  },
  "visibility": 10000,
  "wind": {
    "speed": 1.54,
    "deg": 70
  },
  "clouds": {
    "all": 0
  },
  "rain": null,
  "snow": null,
  "dt": "2024-04-24T05:18:37.000Z",
  "sys": {
    "type": 2,
    "id": 2002734,
    "country": "US",
    "sunrise": "2024-04-24T10:16:09.000Z",
    "sunset": "2024-04-24T23:55:35.000Z"
  },
  "id": 5220355,
  "timezone": -14400,
  "name": "York",
  "cod": 200
}
```

###### Get the current weather for the city of York, GB

http://localhost:8080/forecasts/York?country=GB

```json
{
  "coord": {
    "lon": -1.0827,
    "lat": 53.9576
  },
  "weather": [
    {
      "icon_uri": "http://openweathermap.org/img/wn/04d@2x.png",
      "icon": "04d",
      "id": 803,
      "main": "Clouds",
      "description": "broken clouds"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 4.8,
    "feels_like": 1.18,
    "temp_min": 3.78,
    "temp_max": 5.1,
    "pressure": 1019,
    "humidity": 78,
    "sea_level": 1019,
    "grnd_level": 1017
  },
  "visibility": 10000,
  "wind": {
    "speed": 4.8,
    "deg": 332
  },
  "clouds": {
    "all": 65
  },
  "rain": null,
  "snow": null,
  "dt": "2024-04-24T05:18:42.000Z",
  "sys": {
    "type": 2,
    "id": 2020357,
    "country": "GB",
    "sunrise": "2024-04-24T04:42:04.000Z",
    "sunset": "2024-04-24T19:22:25.000Z"
  },
  "id": 2633352,
  "timezone": 3600,
  "name": "York",
  "cod": 200
}
```

###### Get the current weather for the city of York, US

Lastly, we do a specific search for the current weather in York, US and we correctly get that city's current weather. This happens to be the same York that was inferred by the API in the first example where we only provided the `city` parameter. (Note that this also happens to be York, PA, US, which can be verified by searching with `state=PA` in the query string.)

http://localhost:8080/forecasts/York?country=US

```json
{
  "coord": {
    "lon": -77,
    "lat": 40.1254
  },
  "weather": [
    {
      "icon_uri": "http://openweathermap.org/img/wn/01n@2x.png",
      "icon": "01n",
      "id": 800,
      "main": "Clear",
      "description": "clear sky"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 11.9,
    "feels_like": 10.87,
    "temp_min": 10.14,
    "temp_max": 13.55,
    "pressure": 1011,
    "humidity": 66
  },
  "visibility": 10000,
  "wind": {
    "speed": 1.54,
    "deg": 70
  },
  "clouds": {
    "all": 0
  },
  "rain": null,
  "snow": null,
  "dt": "2024-04-24T05:18:25.000Z",
  "sys": {
    "type": 2,
    "id": 2002734,
    "country": "US",
    "sunrise": "2024-04-24T10:16:09.000Z",
    "sunset": "2024-04-24T23:55:35.000Z"
  },
  "id": 5220355,
  "timezone": -14400,
  "name": "York",
  "cod": 200
}
```

##### Multiple cities with the same name in the United States

In the following examples, look closely at what happens when you have multiple cities with the same name in the United States.

###### Get the current weather for the city of Springfield (no state nor country specified)

In this first example, we only supply the required city name parameter and the API chooses one of the Springfields for us: the one in the state of Missouri, as evidenced by how these coordinates match those of the Missouri-specific call in the third example `"coord": {"lon": -93.2982, "lat": 37.2153}`.

http://localhost:8080/forecasts/Springfield

```json
{
  "coord": {
    "lon": -93.2982,
    "lat": 37.2153
  },
  "weather": [
    {
      "icon_uri": "http://openweathermap.org/img/wn/01n@2x.png",
      "icon": "01n",
      "id": 800,
      "main": "Clear",
      "description": "clear sky"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 9.93,
    "feels_like": 9.93,
    "temp_min": 8.27,
    "temp_max": 12.41,
    "pressure": 1012,
    "humidity": 93
  },
  "visibility": 10000,
  "wind": {
    "speed": 0,
    "deg": 0
  },
  "clouds": {
    "all": 0
  },
  "rain": null,
  "snow": null,
  "dt": "2024-04-24T04:45:39.000Z",
  "sys": {
    "type": 2,
    "id": 2091479,
    "country": "US",
    "sunrise": "2024-04-23T11:27:15.000Z",
    "sunset": "2024-04-24T00:55:12.000Z"
  },
  "id": 4409896,
  "timezone": -18000,
  "name": "Springfield",
  "cod": 200
}
```

###### Get the current weather for the city of Springfield, Illinois, US

http://localhost:8080/forecasts/Springfield?state=IL&country=US

In this example, we specific the US state of Illinois via the `state` parameter as `state=IL` and we find a different Springfield, as evidenced by the coordinates of `"coord": {"lon": -89.6437, "lat": 39.8017}`.

Note that you must specify country if you use state, otherwise the remote API at OpenWeatherMap cannot find the location and will return a 404.

```json
{
  "coord": {
    "lon": -89.6437,
    "lat": 39.8017
  },
  "weather": [
    {
      "icon_uri": "http://openweathermap.org/img/wn/01n@2x.png",
      "icon": "01n",
      "id": 800,
      "main": "Clear",
      "description": "clear sky"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 10.88,
    "feels_like": 10.3,
    "temp_min": 9.49,
    "temp_max": 12.2,
    "pressure": 1015,
    "humidity": 87
  },
  "visibility": 10000,
  "wind": {
    "speed": 0.89,
    "deg": 257
  },
  "clouds": {
    "all": 6
  },
  "rain": null,
  "snow": null,
  "dt": "2024-04-24T04:44:40.000Z",
  "sys": {
    "type": 2,
    "id": 2018691,
    "country": "US",
    "sunrise": "2024-04-23T11:08:35.000Z",
    "sunset": "2024-04-24T00:44:38.000Z"
  },
  "id": 4250542,
  "timezone": -18000,
  "name": "Springfield",
  "cod": 200
}
```

###### Get the current weather for the city of Springfield, Missouri, US

Lastly, we do a specific search for the current weather in Springfield, Missouri and we correctly get that city's current weather. This happens to be the same Springfield that was inferred by the API in the first example where we only provided the `city` parameter.

http://localhost:8080/forecasts/Springfield?state=MO&country=US

```json
{
  "coord": {
    "lon": -93.2982,
    "lat": 37.2153
  },
  "weather": [
    {
      "icon_uri": "http://openweathermap.org/img/wn/01n@2x.png",
      "icon": "01n",
      "id": 800,
      "main": "Clear",
      "description": "clear sky"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 9.91,
    "feels_like": 9.91,
    "temp_min": 8.27,
    "temp_max": 12.41,
    "pressure": 1012,
    "humidity": 93
  },
  "visibility": 10000,
  "wind": {
    "speed": 0,
    "deg": 0
  },
  "clouds": {
    "all": 0
  },
  "rain": null,
  "snow": null,
  "dt": "2024-04-24T04:46:36.000Z",
  "sys": {
    "type": 2,
    "id": 2091479,
    "country": "US",
    "sunrise": "2024-04-23T11:27:15.000Z",
    "sunset": "2024-04-24T00:55:12.000Z"
  },
  "id": 4409896,
  "timezone": -18000,
  "name": "Springfield",
  "cod": 200
}
```

## Recommendations for future direction

### API improvements

- Obfuscate OpenWeatherMap API key from telemetry
  - Currently the OpenWeatherMap API key can be seen in traces. We should find a way to obfuscate or redact it.
- Add tests
- Add Swagger documentation integrated with tests via https://github.com/rswag/rswag
- Dockerize the app with Jaeger to simplify local setup steps
- Find a UI that supports Metrics and use it instead of or alongside Jaeger
- Make metrics send interval configurable
  - Currently metrics are hard-coded to send every 60 seconds

### Accommodating a broader audience

- Allow user to specify units other than `metric` (i.e., `standard` or `imperial`) when calling the OpenWeatherMap API
- Add support for responses in locales other than English
  - e.g. `lang=ja`
- Investigate how to add support for querying in Japanese
  - http://localhost:8080/forecasts/東京 works but http://localhost:8080/forecasts/京都 does not
- The OpenWeatherAPI does not reuse `state` as a way to query, for example, Canadian provinces or Japanese prefectures.
  - https://openweathermap.org/current notes, "searching by states available only for the USA locations"
  - Investigate alternate ways to provide this specificity and implement if there is significant user need.
