# -*- encoding: utf-8 -*-
require File.expand_path('../lib/contao/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wael Nasreddine"]
  gem.email         = ["wael.nasreddine@gmail.com"]
  gem.description   = %q{Contao integration}
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

  # Development dependencies
  gem.add_development_dependency  'rspec'
end
