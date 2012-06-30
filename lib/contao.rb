require 'contao/version'
require 'contao/core_ext/object'
require 'singleton'
require 'ostruct'

module TechnoGate
  module Contao
  end
end

# Contao
require 'contao/application'
require 'contao/notifier'
require 'contao/railtie' if defined?(Rails)
