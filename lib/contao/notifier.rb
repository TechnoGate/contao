require 'guard'

module TechnoGate
  module Contao
    module Notifier
      extend self

      def notify(message, options = {})
        say(message, options.merge(color: 32))
      end

      def warn(message, options = {})
        say(message, options.merge(color: 33))
      end

      def error(message, options = {})
        say(message, options.merge(color: 31))
      end

      protected

      def say(message, options = {})
        color = options.delete(:color)

        if ::Guard::UI.send(:color_enabled?)
          message = "\e[0;34mContao>>\e[0m \e[0;#{color}m#{message}\e[0m"
        else
          message = "Contao>> #{message}"
        end

        ::Guard::UI.info(message, options)
      end
    end
  end
end
