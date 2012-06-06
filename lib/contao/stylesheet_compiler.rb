require 'contao/compiler'
require 'compass'
require 'compass/commands'

module TechnoGate
  module Contao
    class StylesheetCompiler < Compiler

      def initialize(options = {})
        super
      end

      def clean
        @cleaner ||= Compass::Commands::CleanProject.new(
          Contao.root,
          configuration_file: Contao.root.join('config', 'compass.rb')
        )

        @cleaner.execute

        super
      end

      protected
      def compiler_name
        :stylesheet
      end

      # This class can't be told where to get assets from or where to compile to
      # unless I figure out how to configure the UpdateProject without a file
      def input_from_config_path
      end
      def output_from_config_path
      end

      def compile_assets
        @updater ||= Compass::Commands::UpdateProject.new(
          Contao.root,
          configuration_file: Contao.root.join('config', 'compass.rb')
        )

        @updater.execute
      end

      def create_hashed_assets
        Dir["#{Contao.expandify(Contao::Application.config.assets_public_path)}/**/*.css"].each do |file|
          create_digest_for_file Pathname(file).expand_path
        end
      end

      def generate_manifest
        generate_manifest_for("stylesheets", "css")
      end
    end
  end
end
