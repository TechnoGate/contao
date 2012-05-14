module TechnoGate
  module Contao
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
  end
end
