# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cucumber/varnishtest/version"

Gem::Specification.new do |s|
  s.name        = "cucumber-varnishtest"
  s.version     = Cucumber::Varnishtest::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nick Stielau"]
  s.email       = ["nick.stielau@gmail.com"]
  s.homepage    = "https://github.com/nstielau/varnishtest_cucumber"
  s.summary     = %q{Cucumber steps to easily create and execute varnishtest tests.}
  s.description = %q{Cucumber steps to easily create and execute varnishtest tests.}
  s.licenses    = ['MIT']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency              'cucumber',       '>= 2.0.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
