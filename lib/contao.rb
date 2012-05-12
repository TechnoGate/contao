require 'contao/version'

module TechnoGate
  module Contao

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
  end
end

require 'contao/javascript_uglifier'
