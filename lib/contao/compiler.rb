require 'active_support/core_ext/string/inflections'

module TechnoGate
  module Contao
    class Compiler
      attr_accessor :options

      def initialize(options = {})
        @options = options
        @manifest_path = Contao.expandify(Contao::Application.config.assets_public_path).join('manifest.json')
      end

      # Compile assets
      def compile
        prepare_folders
        compile_assets
        create_hashed_assets if Contao.env == :production
        generate_manifest
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

      # Create a diges for a given file
      #
      # This method creates a digested file for a given file path
      #
      # @param [Pathname | String] file_path
      def create_digest_for_file(file_path)
        digest = Digest::MD5.hexdigest File.read(file_path)
        FileUtils.cp file_path,
          "#{file_path.to_s.chomp(File.extname(file_path))}-#{digest}#{File.extname(file_path)}"
      end

      # This method generates a manifest of all generated files
      # so it can be parsed and processed by the PHP application
      #
      # This method is expected to be overridden
      def generate_manifest
      end
    end
  end
end
