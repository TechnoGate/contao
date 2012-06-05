require 'contao/version'
require 'contao/core_ext/object'
require 'singleton'
require 'ostruct'

module TechnoGate
  module Contao

    class RootNotSet < RuntimeError; end

    # Get the currently running environment
    #
    # @return [Symbol] Currently running environment
    def self.env
      @@env
    end

    # Set the environment
    #
    # @param [Symbol] Environment
    def self.env=(env)
      @@env = env
    end

    # Get the currently running rootironment
    #
    # @return [Symbol] Currently running rootironment
    def self.root
      @@root
    end

    # Set the rootironment
    #
    # @param [Symbol] rootironment
    def self.root=(root)
      @@root = Pathname.new(root).expand_path
    end

    # Expandify a path
    #
    # @param [String] Path
    # @return [Pathname] Path converted to absolute path
    # raises RootNotSet
    def self.expandify(path)
      raise RootNotSet unless root

      if path.to_s.start_with? "/"
        Pathname(path).expand_path
      else
        root.join(path)
      end
    end
  end
end

# Contao
require 'contao/application'
require 'contao/notifier'
require 'contao/coffeescript_compiler'
require 'contao/javascript_compiler'
require 'contao/stylesheet_compiler'

# Guard
require 'guard/assets'

# Monkey patches
require 'monkey_patches'
