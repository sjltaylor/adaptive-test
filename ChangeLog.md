# Change Log

Steps 1 and 2 are commits to master and establish a baseline setup and implementation.
Subsequent steps are on feature branches.


## Step 1

Initial setup for specs (on `master`)

* clean up the default Gemfile
* include postgres
* create initial database
* include rspec and testing related gems
* setup an initial test for the landing page


## Step 2

branch: `master`

Implement baseline functionality for tweet retrieval and display


## Step 3

branch `feature/handle-api-errors`

It is documented that the "api might fail occaisionally".

The api should raise an exception which can be caught by the controller.
The controller can use a flash to notify the user.

VCR was dropped in favour of mocking because api responses are non-deterministic

The tweet model uses a numericality validation rather than inclusion validation

