# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-angular-motion/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-assets-angular-motion"
  spec.version       = RailsAssetsAngularMotion::VERSION
  spec.authors       = ["rails-assets.org"]
  spec.description   = "AngularMotion - Fancy CSS3 animations for AngularJS 1.2+"
  spec.summary       = "AngularMotion - Fancy CSS3 animations for AngularJS 1.2+"
  spec.homepage      = "https://github.com/mgcrea/angular-motion"

  spec.files         = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency "rails-assets-angular", "~> 1.2"
  spec.add_dependency "rails-assets-angular-animate", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
