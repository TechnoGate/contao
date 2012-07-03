require 'contao/version'
require 'contao/core_ext/object'
require 'singleton'
require 'ostruct'

# Utilities
require 'contao/password'

# Contao
require 'contao/application'
require 'contao/notifier'
require 'contao/railtie' if defined?(Rails)
