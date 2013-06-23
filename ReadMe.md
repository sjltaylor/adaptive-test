# Adaptive Lab Code Test


## Project Setup

System Dependencies:

* Rails 4.0.0.rc2
* Ruby 2.0.0p195
* Uses postgres 9.1.4

If there are any issues setting these up, I can prepare an ec2 instance for the purposes of demonstration


## Getting Started

* Setup a `config/database.yml`. A copy of `config/database_example.yml` is a good start
* similarly, setup a `config/config.yml`
* bundle && bundle exec rake db:setup db:test:prepare
* A test run will check everything is working: run `bundle exec rspec` in the project root
* `bundle exec rails server` to launch the app, assuming port 3000 is available

## Console Access

Application data and behaviour can be inspected in the rails console.
Run `rails console` in the application root

For a database client prompt: `rails dbconsole`


## Test Coverage

I'm a fan of TDD and BDD, but I'm not religious about it.
I write unit test because they encourage lower coupling and can help implement complicated functionality faster.
I write integration tests because they give you confidence that the code actually performs as required, affords you some protection against regression and makes sure that the units work together as expected.

There are some circumstances that such coverage may not be required. Perhaps we are writing very simple code for experimental purposes, unit tests may not provide any benefit.
Perhaps we are writing an experimental integration with a third-party api to split test a new feature; integration tests might not be worth the effort until the value of the feature is verified.

The appropriate level and type of coverage depends on evalulating the cost of a failure, the cost of manual testing and the cost of implementing the test.

I write this code with consideration for extensibility and maintainability; I'm coding for the next guy!

* We're only use htmlunit, for a real web app we would likely want to consider browser automation, probably with Selenium WebDriver for whichever browser the applicaiton targets:
  * IE
  * Chrome
  * Firefox
  * Safari
  * Safari for iOS
  * Android browsers
  * We could use SauceLabs as a testing platform or setup our own WebDriver hub


## What's this "AdaptiveTweetsService" thing?!

I chose to use Rails because it's gives you a lot out of the box. One thing it didn't give us in this application is a sensible place to put the behaviour concerned with fetching tweets from this remote api.

Rails provides:

* Models: it doesn't live in the Tweet model; that only knows about tweet record querying, state and data integrity
* Controllers: it doesn't live in the LandingController, that's responsible for our HTTP interface

Off the Rails:

* it doesn't fit in well with a DCI role or interaction
* it's not a conductor or a presenter

I decided that fetching tweets was a `service`. The `fetch_more_tweets` verb encapsulates the act of retrieved more tweets from the external api. It's not concerned with how they're fetched or stored, only how they're processed:

* get the from the api
* map them to an internal representation
* note how often we've seen any given tweet

