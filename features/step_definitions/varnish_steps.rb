require './lib/cucumber/varnishtest/context_manager'
require './lib/cucumber/varnishtest/request'

Given(/^varnish running with (.*)$/) do |vcl_file|
  # Load  a particular varnish VCL file
  ContextManager.instance.vcl_file = vcl_file
end

When(/^we (GET|PATCH|POST|PUT|DELETE) (.*)$/) do |method, path|
  ContextManager.instance.request path, method
end

Then(/^the response should be 200$/) do
  ContextManager.instance.client_expect 'resp.status', 200
end

Then(/^the response length should be (\d+)$/) do |bytes|
  ContextManager.instance.client_expect 'resp.bodylen', bytes.to_i
end

Then(/^the response header (.*) should be (.*)$/) do |header, value|
  ContextManager.instance.client_expect "resp.http.#{header}", "#{value}"
end

Then(/^it should pass varnishtest$/) do
  ContextManager.instance.test!
end

Then(/^the response code should be (\d+)$/) do |code|
  ContextManager.instance.client_expect "resp.status", 200
end

Then(/^the server should receive (\d+) requests$/) do |count|
  ContextManager.instance.expected_request_count = count
end

Then(/^there should be (\d+) cache hit[s]*$/) do |count|
  ContextManager.instance.expected_cache_hits = count
end

Then(/^there should be (\d+) cache misses$/) do |count|
  ContextManager.instance.expected_cache_misses = count
end

Then(/^there should be (\d+) piped request[s]*$/) do |count|
  ContextManager.instance.expected_piped_requests = count
end

Then(/^there should be (\d+) passed request[s]*$/) do |count|
  ContextManager.instance.expected_passed_requests = count
end

After do |scenario|
  # Reset the context manager for a fresh scenario
  ContextManager.reset!
end
