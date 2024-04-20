# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Prerequisites

- Ruby version: 3.3.0

## Configuration

- Sign up for an OpenWeatherMap API KEY
- Copy `.env.template` to `.env` and set `OPEN_WEATHER_MAP_API_KEY` to the value of your new API KEY

## Run the app locally with telemetry

You can run the app locally with telemetry output sent to console like so:

`env OTEL_TRACES_EXPORTER=console rails server -p 3000`

--- 
* System dependencies
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions
