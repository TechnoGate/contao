require 'contao/version'

module TechnoGate
  module Contao

    # Get the currently running environment
    #
    # @return [Symbol] Currently running environment
    def self.env
      @@env
    end

    def self.env=(env)
      @@env = env
    end
  end
end

require 'contao/javascript_uglifier'
