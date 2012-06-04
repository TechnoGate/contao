# -*- encoding: utf-8 -*-
require File.expand_path('../lib/contao/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wael Nasreddine"]
  gem.email         = ["wael.nasreddine@gmail.com"]
  gem.description   = %q{Contao Integration with Compass, Sass, Coffee-script, Rake, Guard with asset pre-compiler and asset-manifest generator}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "contao"
  gem.require_paths = ["lib"]
  gem.version       = Contao::VERSION

  # Runtime dependencies
  gem.add_dependency 'rake'
  gem.add_dependency 'compass'
  gem.add_dependency 'oily_png'
  gem.add_dependency 'uglifier'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'guard'
  gem.add_dependency 'json'
  gem.add_dependency 'parseconfig'
  gem.add_dependency 'highline'
  gem.add_dependency 'coffee-script'

  # Development dependencies
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fakefs'
end
