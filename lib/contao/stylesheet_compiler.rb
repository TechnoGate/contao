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
