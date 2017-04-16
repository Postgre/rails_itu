# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-textAngular/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-assets-textAngular"
  spec.version       = RailsAssetsTextangular::VERSION
  spec.authors       = ["rails-assets.org"]
  spec.description   = "A radically powerful Text-Editor/Wysiwyg editor for Angular.js"
  spec.summary       = "A radically powerful Text-Editor/Wysiwyg editor for Angular.js"
  spec.homepage      = "https://github.com/fraywing/textAngular"

  spec.files         = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency "rails-assets-angular", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
