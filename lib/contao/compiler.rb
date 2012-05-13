require 'active_support/core_ext/string/inflections'

module TechnoGate
  module Contao
    class Compiler
      attr_accessor :options

      def initialize(options = {})
        @options = options
      end

      # Compile assets
      def compile
        prepare_folders
        compile_assets
        create_hashed_assets if Contao.env == :production
        notify

        self
      end

      def self.compile
        new.compile
      end

      def clean
        FileUtils.rm_rf Contao.expandify(Application.config.assets_public_path)
      end

      def self.clean
        new.clean
      end

      protected
      # Prepare folders
      def prepare_folders
        FileUtils.mkdir_p Contao.expandify(Application.config.assets_public_path)
      end

      def compile_assets
      end

      def create_hashed_assets
      end

      def notify
        klass_name = self.class.to_s.split('::').last

        Notifier.notify("#{klass_name.underscore.humanize} finished successfully.", title: klass_name)
      end
    end
  end
end
