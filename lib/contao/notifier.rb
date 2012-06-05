require 'singleton'
require 'guard'

module TechnoGate
  module Contao
    class Notifier
      include Singleton

      def notify(message, options = {})
        if ::Guard::UI.send(:color_enabled?)
          message = "\e[0;34mContao>>\e[0m \e[0;32m#{message}\e[0m"
        else
          message = "Contao>> #{message}"
        end

        ::Guard::UI.info(message, options)
      end

      def self.notify(*args, &block)
        instance.notify(*args, &block)
      end

      def warn(message, options = {})
        if ::Guard::UI.send(:color_enabled?)
          message = "\e[0;34mContao>>\e[0m \e[0;33m#{message}\e[0m"
        else
          message = "Contao>> #{message}"
        end

        ::Guard::UI.info(message, options)
      end

      def self.warn(*args, &block)
        instance.warn(*args, &block)
      end
    end
  end
end
