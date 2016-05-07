require './lib/varnishtest_context_manager'
require './lib/varnishtest_request'

Given(/^varnish running with (.*)$/) do |vcl_file|
  # Load  a particular varnish VCL file
  VarnishTestContextManager.instance.vcl_file vcl_file
end

When(/^we (GET|POST) (.*)$/) do |method, path|
  VarnishTestContextManager.instance.request path, method
end

When(/^we send header (.*)=(.*)$/) do |header, value|
  VarnishTestContextManager.instance.add_context "#{header}=#{value}"
end

Then(/^the response should be 200$/) do
  VarnishTestContextManager.instance.client_expect 'resp.status', 200
end

Then(/^the response length should be (\d+)$/) do |bytes|
  VarnishTestContextManager.instance.client_expect 'resp.bodylen', bytes.to_i
end

Then(/^the response header (.*) should be (.*)$/) do |header, value|
  VarnishTestContextManager.instance.client_expect "resp.http.#{header}", "#{value}"
end

Then(/^it should pass varnishtest$/) do
  VarnishTestContextManager.instance.test!
end

Then(/^the response code should be (\d+)$/) do |code|
  VarnishTestContextManager.instance.client_expect "resp.status", 200
end

Then(/^the server should receive (\d+) requests$/) do |count|
  VarnishTestContextManager.instance.expected_request_count = count
end

Then(/^there should be (\d+) cache hits$/) do |count|
  VarnishTestContextManager.instance.expected_cache_hits = count
end

Then(/^there should be (\d+) cache misses$/) do |count|
  VarnishTestContextManager.instance.expected_cache_misses = count
end

Then(/^there should be (\d+) piped requests$/) do |count|
  VarnishTestContextManager.instance.expected_piped_requests = count
end

Then(/^there should be (\d+) passed requests$/) do |count|
  VarnishTestContextManager.instance.expected_passed_requests = count
end

After do |scenario|
  # Reset the context manager for a fresh scenario
  VarnishTestContextManager.reset!
end
