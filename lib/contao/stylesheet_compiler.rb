require 'contao/compiler'
require 'compass'
require 'compass/commands'

module TechnoGate
  module Contao
    class StylesheetCompiler < Compiler

      def initialize(options = {})
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

      end
    end
  end
end
