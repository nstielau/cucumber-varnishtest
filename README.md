# Varnishtest Cucumber

This let's you use Gherkin, the language of BDD, to write behavior-level
checks for your VCL.

## Project status
This is currently a Proof of Concept.  

I think this is probably the easiest/best way to get started with
testing your Varnish config, but it might take a bit of extended as
you test out your use-cases.  

Definitely fork and don't rely on this code not changing, though ;)

I'm working on getting this packaged as a ruby gem to further simplify
the setup for getting testable VCLs.  Once it's packaged and versioned
it should be in a sustainable, usable place.

## To run

To run, simply run `cucumber` from this directory.

You can use your own VCL and write your own features in a .feature file.

```
±  |master ✗| → cucumber
Feature: Static Server Headers

  Scenario: Simple Single Request          # features/varnishtest.feature:3
    Given varnish running with example.vcl # features/step_definitions/varnish_steps.rb:4
    When we GET /images.png                # features/step_definitions/varnish_steps.rb:9
    Then the response code should be 200   # features/step_definitions/varnish_steps.rb:29
    And it should pass varnishtest         # features/step_definitions/varnish_steps.rb:25

  Scenario: Checking Response Headers                              # features/varnishtest.feature:9
    Given varnish running with example.vcl                         # features/step_definitions/varnish_steps.rb:4
    When we GET /images.png                                        # features/step_definitions/varnish_steps.rb:9
    Then the response header X-Served-By should be "My App Server" # features/step_definitions/varnish_steps.rb:21
    And it should pass varnishtest                                 # features/step_definitions/varnish_steps.rb:25

  Scenario: POST should never be cached    # features/varnishtest.feature:15
    Given varnish running with example.vcl # features/step_definitions/varnish_steps.rb:4
    When we POST /form                     # features/step_definitions/varnish_steps.rb:9
    Then there should be 1 passed requests # features/step_definitions/varnish_steps.rb:49
    And it should pass varnishtest         # features/step_definitions/varnish_steps.rb:25

  Scenario: Multiple Requests without warming # features/varnishtest.feature:21
    Given varnish running with example.vcl    # features/step_definitions/varnish_steps.rb:4
    When we GET /images.png                   # features/step_definitions/varnish_steps.rb:9
    And we GET /images2.png                   # features/step_definitions/varnish_steps.rb:9
    And we GET /images2.png                   # features/step_definitions/varnish_steps.rb:9
    Then there should be 2 cache misses       # features/step_definitions/varnish_steps.rb:41
    Then there should be 1 cache hit          # features/step_definitions/varnish_steps.rb:37
    And it should pass varnishtest            # features/step_definitions/varnish_steps.rb:25

  Scenario: Check Dynamic header                                     # features/varnishtest.feature:30
    Given varnish running with example.vcl                           # features/step_definitions/varnish_steps.rb:4
    When we GET /monalisa.png                                        # features/step_definitions/varnish_steps.rb:9
    Then the response header X-Requested-URL should be /monalisa.png # features/step_definitions/varnish_steps.rb:21
    And it should pass varnishtest                                   # features/step_definitions/varnish_steps.rb:25

5 scenarios (5 passed)
23 steps (23 passed)
0m7.467s
```

## Installation

Add the following line to your Gemfile, preferably in the test or cucumber group:

```
gem 'cucumber-varnishtest', :require => false
```

Then add the following line to your env.rb to make the step definitions available in your features:

```
require 'cucumber/varnishtest'
```

## How to use your own VCL

Simply put the .vcl file in this directory, and specify in your
`Given` clause of your Scenario:

```
Scenario: Multiple Requests without warming
  Given varnish running with MyCustomConfig.vcl <==== YOUR VCL FILE
  When we request /images.png
  Then it should pass varnishtest
```

## Dependencies

Make sure you have 'varnishtest' installed!

```
# On OSX
$ brew install varnish
$ varnishtest -h
usage: varnishtest [options] file ...
    -b size                      # Set internal buffer size (default: 512K)
    -D name=val                  # Define macro
    -i                           # Find varnishd in build tree
    -j jobs                      # Run this many tests in parallel
    -k                           # Continue on test failure
    -L                           # Always leave temporary vtc.*
    -l                           # Leave temporary vtc.* if test fails
    -n iterations                # Run tests this many times
    -q                           # Quiet mode: report only failures
    -t duration                  # Time tests out after this long
    -v                           # Verbose mode: always report test log
    -W                           # Enable the witness facility for locking
```

Install cucumber

```
gem install bundler
bundle install
bundle exec cucumber --version
```

## References

Read more about varnish test at
* http://www.clock.co.uk/blog/getting-started-with-varnishtest
* http://blog.zenika.com/2012/08/27/introducing-varnishtest/

## Thanks

Thanks to
* jayzes for examples on how to [package cucumber steps](http://github.com/jayzes/cucumber-api-steps)
