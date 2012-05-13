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
        create_hashed_assets

        self
      end

      def self.compile
        new.compile
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
    end
  end
end