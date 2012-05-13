require 'contao/version'
require 'singleton'
require 'ostruct'

module TechnoGate
  module Contao

    class RootNotSet < RuntimeError; end

    class Application < OpenStruct
      include Singleton

      def initialize
        super
        self.config = OpenStruct.new
      end

      def self.configure(&block)
        instance.instance_eval(&block)
      end

      def self.config
        instance.config
      end
    end

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

      if path.start_with? "/"
        path
      else
        root.join(path)
      end
    end
  end
end

require 'contao/javascript_compiler'
