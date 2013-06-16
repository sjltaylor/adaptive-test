# Adaptive Lab Code Test

## Project Setup

* Rails 4.0.0.rc2
* Ruby 2.0.0p195
* Uses postgres 9.1.4

## Getting Started

* Install postgres if required
  * setup a `config/database.yml`. A copy of `config/database_example.yml` is a good start.
* bundle && bundle exec rake db:setup db:test:prepare
* A test run will check everything is working; run `bundle exec rspec` in the project root
* `bundle exec rails server` to launch the app, assuming port 3000 is available

## Test Coverage

I'm not religious about writing tests. I write unit test because they encourage lower coupling of units and can actually make code faster to write. I write integration tests because they give you confidence that the code actually performs as required and affords some protection against regression.

There are some circumstances that such coverage may not be required. Perhaps we are writing very simple code for experimental purposes, unit tests may not provide any benefit. Perhaps we are writing an experimental integration with a third-party api to split test a new feature; integration tests might not be worth the effort until the value of the feature is verified.

The appropriate level type of coverage depends on evalulating the cost of a failure, the cost of manual testing and the cost of implementing the test.

I write this code with consideration for extensibility and maintainability; I'm coding for the next guy!

* we're only use htmlunit, for a real web app we would likely want to consider browser automation, probably with Selenium WebDriver for whichever browser the applicaiton targets:
  * IE
  * Chrome
  * Firefox
  * Safari
  * Safari for iOS
  * Android browsers
  * We could use SauceLabs as a testing platform or setup our own WebDriver hub
