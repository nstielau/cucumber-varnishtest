require './lib/varnishtest_context_manager'

Given(/^varnish running with (.*)$/) do |vcl_file|
  VarnishTestContextManager.instance.vcl_file vcl_file
end

When(/^we request (.*)$/) do |path|
  VarnishTestContextManager.instance.request "#{path}"
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

Then(/^the server should receive (\d+) request$/) do |request_count|
  VarnishTestContextManager.instance.desired_request_count request_count
end

Then(/^the response code should be (\d+)$/) do |code|
  VarnishTestContextManager.instance.client_expect "resp.status", 200
end

Then(/^there should be (\d+) cache hits$/) do |expected_cache_hits|
  VarnishTestContextManager.instance.expected_cache_hits expected_cache_hits
end

Then(/^there should be (\d+) cache misses$/) do |expected_cache_misses|
  VarnishTestContextManager.instance.expected_cache_misses expected_cache_misses
end

After do |scenario|
  VarnishTestContextManager.reset!
end
