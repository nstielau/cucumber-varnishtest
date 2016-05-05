### Gherkiny Varnishtest

This let's you use Gherkin, the language of BDD to write behavior-level checks for your VCL.

To run:

```
±  |master ✗| → cucumber
Feature: Static Server Headers

  Scenario: Simple Single Request          # features/varnishtest.feature:3
    Given varnish running with default.vcl # features/step_definitions/varnish_steps.rb:3
    When we request /images.png            # features/step_definitions/varnish_steps.rb:7
    Then the response code should be 200   # features/step_definitions/varnish_steps.rb:35
    And it should pass varnishtest         # features/step_definitions/varnish_steps.rb:27

  Scenario: Checking Response Headers                     # features/varnishtest.feature:9
    Given varnish running with default.vcl                # features/step_definitions/varnish_steps.rb:3
    When we request /images.png                           # features/step_definitions/varnish_steps.rb:7
    Then the header X-Served-By should be "My App Server" # features/step_definitions/varnish_steps.rb:23
    And it should pass varnishtest                        # features/step_definitions/varnish_steps.rb:27

  Scenario: Multiple Requests              # features/varnishtest.feature:15
    Given varnish running with default.vcl # features/step_definitions/varnish_steps.rb:3
    When we request /images.png            # features/step_definitions/varnish_steps.rb:7
    And we request /images.png             # features/step_definitions/varnish_steps.rb:7
    Then the response length should be 11  # features/step_definitions/varnish_steps.rb:19
    And it should pass varnishtest         # features/step_definitions/varnish_steps.rb:27

3 scenarios (3 passed)
13 steps (13 passed)
0m4.873s
```

Make sure you have 'varnishtest' installed!

```
brew install varnish
```
