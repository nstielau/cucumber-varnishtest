Feature: Static Server Headers

  Scenario: Simple Single Request
    Given varnish running with example.vcl
    When we GET /images.png
    Then the response code should be 200
    And it should pass varnishtest

  Scenario: Checking Response Headers
    Given varnish running with example.vcl
    When we GET /images.png
    Then the response header X-Served-By should be "My App Server"
    And it should pass varnishtest

  Scenario: POST should never be cached
    Given varnish running with example.vcl
    When we POST /form
    Then there should be 1 passed requests
    And it should pass varnishtest

  Scenario: Multiple Requests without warming
    Given varnish running with example.vcl
    When we GET /images.png
    And we GET /images2.png
    And we GET /images2.png
    Then there should be 2 cache misses
    Then there should be 1 cache hit
    And it should pass varnishtest

  Scenario: Check Dynamic header
    Given varnish running with example.vcl
    When we GET /monalisa.png
    Then the response header X-Requested-URL should be /monalisa.png
    And it should pass varnishtest
