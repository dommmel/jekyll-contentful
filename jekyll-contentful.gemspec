# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-contentful/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-contentful"
  spec.version       = Jekyll::Contentful::VERSION
  spec.authors       = ["Dommmel"]
  spec.email         = ["dommmel@gmail.com"]

  spec.summary       = %q{jekyll plugin that generates pages from contentful entries}
  spec.description   = %q{jekyll plugin that generates pages from contentful entries}
  spec.homepage      = "https://github.com/dommmel/jekyll-contentful"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'jekyll'
  spec.add_dependency "contentful"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
