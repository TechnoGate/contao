require 'singleton'
require 'guard'

module TechnoGate
  module Contao
    class Notifier
      include Singleton

      def notify(message, options = {})
        message = "Contao>> #{message}"
        message = "\e[0;32m#{message}\e[0m" if ::Guard::UI.send(:color_enabled?)

        ::Guard::UI.info(message, options)
      end

      def self.notify(*args, &block)
        instance.notify(*args, &block)
      end
    end
  end
end
