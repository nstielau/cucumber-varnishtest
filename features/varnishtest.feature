Feature: Static Server Headers

  Scenario: Simple Single Request
    Given varnish running with default.vcl
    When we request /images.png
    Then the response code should be 200
    And it should pass varnishtest

  Scenario: Checking Response Headers
    Given varnish running with default.vcl
    When we request /images.png
    Then the response header X-Served-By should be "My App Server"
    And it should pass varnishtest

  Scenario: Multiple Requests
    Given varnish running with default.vcl
    When we request /images.png
    And we request /images.png
    Then there should be 1 cache hits
    And there should be 1 cache misses
    And it should pass varnishtest

  Scenario: POST should never be cached
    Given varnish running with default.vcl
    When we POST /form
    Then there should be 1 passed requests
    And it should pass varnishtest

  Scenario: Multiple Requests without warming
    Given varnish running with default.vcl
    When we POST /images2.png
    And we GET /images.png
    And we request /images.png
    Then there should be 1 cache misses
    Then there should be 1 cache hits
    And it should pass varnishtest

  Scenario: Check Dynamic header
    Given varnish running with default.vcl
    When we request /monalisa.png
    Then the response header X-Requested-URL should be /monalisa.png
    And it should pass varnishtest
