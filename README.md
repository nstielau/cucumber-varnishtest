# Varnishtest Cucumber

This let's you use Gherkin, the language of BDD, to write behavior-level checks for your VCL.

## To run

To run, simply run `cucumber` from this directory.

You can use your own VCL and write your own features in a .feature file.

```
±  |master ✗| → cucumber
Feature: Static Server Headers

  Scenario: Simple Single Request          # features/varnishtest.feature:3
    Given varnish running with default.vcl # features/step_definitions/varnish_steps.rb:3
    When we request /images.png            # features/step_definitions/varnish_steps.rb:7
    Then the response code should be 200   # features/step_definitions/varnish_steps.rb:35
    And it should pass varnishtest         # features/step_definitions/varnish_steps.rb:27

  Scenario: Checking Response Headers                              # features/varnishtest.feature:9
    Given varnish running with default.vcl                         # features/step_definitions/varnish_steps.rb:3
    When we request /images.png                                    # features/step_definitions/varnish_steps.rb:7
    Then the response header X-Served-By should be "My App Server" # features/step_definitions/varnish_steps.rb:23
    And it should pass varnishtest                                 # features/step_definitions/varnish_steps.rb:27

  Scenario: Multiple Requests              # features/varnishtest.feature:15
    Given varnish running with default.vcl # features/step_definitions/varnish_steps.rb:3
    When we request /images.png            # features/step_definitions/varnish_steps.rb:7
    And we request /images.png             # features/step_definitions/varnish_steps.rb:7
    Then there should be 1 cache hits      # features/step_definitions/varnish_steps.rb:39
    And there should be 1 cache misses     # features/step_definitions/varnish_steps.rb:43
    And it should pass varnishtest         # features/step_definitions/varnish_steps.rb:27

  Scenario: Multiple Requests without warming # features/varnishtest.feature:23
    Given varnish running with default.vcl    # features/step_definitions/varnish_steps.rb:3
    When we request /images2.png              # features/step_definitions/varnish_steps.rb:7
    And we request /images.png                # features/step_definitions/varnish_steps.rb:7
    And we request /images.png                # features/step_definitions/varnish_steps.rb:7
    Then there should be 2 cache misses       # features/step_definitions/varnish_steps.rb:43
    Then there should be 1 cache hits         # features/step_definitions/varnish_steps.rb:39
    And it should pass varnishtest            # features/step_definitions/varnish_steps.rb:27

  Scenario: Check Dynamic header                                     # features/varnishtest.feature:32
    Given varnish running with default.vcl                           # features/step_definitions/varnish_steps.rb:3
    When we request /monalisa.png                                    # features/step_definitions/varnish_steps.rb:7
    Then the response header X-Requested-URL should be /monalisa.png # features/step_definitions/varnish_steps.rb:23
    And it should pass varnishtest                                   # features/step_definitions/varnish_steps.rb:27

5 scenarios (5 passed)
25 steps (25 passed)
0m7.568s

```

## How to use your own VCL

Simply put the .vcl file in this directory, and specify in your
`Given` clause of your Scenario:

```
Scenario: Multiple Requests without warming
  Given varnish running with MyCustomConfig.vcl
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
