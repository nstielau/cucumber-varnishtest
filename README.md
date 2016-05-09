# Cucumber Varnishtest

This let's you use Gherkin, the language of BDD, to write behavior-level
checks for your VCL.

## Project status

This project is now legit!

Install the [Gem] (https://rubygems.org/gems/cucumber-varnishtest)
and check out [this example](https://github.com/nstielau/cucumber-varnishtest-example)
to get started.

This is probably the easiest/best way to get started with testing your
Varnish config.  However, the step definitions are not sufficient for
complicated VCL use-cases.  PRs welcome ;)

If you do need to iterate on the steps, working directly out of a clone is
likely easiest.  If you want to get started testing your VCL in CI like travis /
 jenkins / CircleCI, using the steps packaged in the gem is probably easiest.

## Examples

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

## Usage

Check out [this example](https://github.com/nstielau/cucumber-varnishtest-example).

Or simply clone this repo and run `cucumber`

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
