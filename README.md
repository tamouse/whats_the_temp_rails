# What's the Temp>

A small Rails app written as a coding exercise for a job interview.

## Prerequisits

* Ruby version: 3.2.x
* Bundler version: 2.5.7
* An API key from https://www.weatherapi.com
  - Sign up is free. You get the API when you sign up.

## installation

Clone a copy of the repo to your local development system:

    git clone git@github.com:tamouse/whats_the_temp_rails.git

## Configuration

Change into the directory where the app installed:

    cd whats_the_temp_rails

Initialize the app:

    bundle install 
    export WEATHER_API_KEY=<API key from the service above>
    bin/rails db:migrate
  
## Running the test suite

Tests are written using RSpec.

    bin/rake
      
## Running the server locally

    bin/rails server

When the server is up, it will display the local URL, Point your browser at the URL, and try things out.

## Feedback, comments, issues

Please submit to <https://github.com/tamouse/whats_the_temp_rails/issues/new>

As this is a demo, I won't be accepting any pull requests.

No license or CoC.

## Weather service

I chose weatherapi.com as the service as it was entirely free, had some interesting options, and could provide the requirements simply.
Documentation for the API is available at <https://www.weatherapi.com/docs/>. 
Acceptable forms for address can be found at <https://www.weatherapi.com/docs/#intro-request-param>.

Briefly, they include:

* a zip or postal code
* a city name
* an IP address
* the string "auto:ip" which looks up your externally visible IP address 
