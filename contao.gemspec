# -*- encoding: utf-8 -*-
require File.expand_path('../lib/contao/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Wael Nasreddine']
  gem.email         = ['wael.nasreddine@gmail.com']
  gem.description   = 'Contao Integration with Rails Asset Pipeline, Compass and Capistrano'
  gem.summary       = <<-EOS
This gem will help you to quickly develop a website using Contao CMS
which has pre-built support for Sass, Compass, CoffeeScript, Jasmine
and Capistrano.

It also feature hashed assets served by the Contao Assets extension,
which allows you to have an md5 appended to each of your assets URL on
the production site.

The integration with Capistrano allows you to quickly deploy, copy
assets, import database and even upload media such as images and PDFs
all from the command line using Capistrano.
  EOS
  gem.homepage      = 'http://technogate.github.com/contao'
  gem.required_ruby_version = Gem::Requirement.new('>= 1.9.2')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'contao'
  gem.require_paths = ['lib']
  gem.version       = Contao::VERSION

  # Runtime dependencies
  gem.add_dependency 'rake'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'parseconfig'
  gem.add_dependency 'highline'

  # Development dependencies
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fakefs'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-doc'
  gem.add_development_dependency 'binding_of_caller'
end
