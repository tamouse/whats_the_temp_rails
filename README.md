# What's the Temp?

A small Rails app written as a coding exercise for a job interview.

## Prerequisites

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

## Development Considerations

### Separate the external API call from the Rails app as much as possible

The weather API is just one of several that are available. Separating it leaves relatively easy to replace it at some point.

There is still a fair amount of coupling between `WeatherService` and `WeatherAPI` but in a truly well-constructed API class, it should be able to handle the form the service is expecting, even if that involves some translation of field names and structures. I didn't go to that extend to provide an exhaustive manifold here, since it's too much for a coding sample.

## Use a service object for the weather

Another place of abstraction that provides a place for the app to perform caching on the calls, handling the responses from the API, and giving the controller an object to query about the weather.

## Slim controller

The `WeathersController` provides the parameter validation, dispatching the `WeatherService` and creating a `Reading` entry, then Marshalling whatever is needed for the views.

## Views 

The views are limited to an opening page with no data, but a form inviting the user to submit some data to get the current temperature.

The views use a partial form that lets them share the input form.

There is no view for the create action since it only redirects to the show action.

## Caching

To fulfill the requirement to cache the weather responses for 30 minutes, I chose to use Rails Caching in the `WeatherService`. This works rather well, but there are some other concerns.
When the cached entry comes back, the controller still makes a `Reading` record in the database. This needlessly creates records, and wastes space.

Rails caching is the means to achieving the caching effect, but I think it would be better to cache the `Reading` record rather than build a hew one. My initial instinct is to build this into the `WeatherService` but perhaps its more appropriate to split that functionality into two services, one that deals with `Reading` caching and the other that is called only on a cache miss.

