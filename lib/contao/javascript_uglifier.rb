require 'fileutils'

module TechnoGate
  module Contao
    class JavascriptUglifier
      attr_accessor :js_src_paths, :js_tmp_path, :js_path, :js_file, :options

      def initialize(options = {})
        @js_src_paths = options.delete :js_src_paths
        @js_tmp_path  = options.delete :js_tmp_path
        @js_path      = options.delete :js_path
        @js_file      = options.delete :js_file
        @options      = options
      end

      # Compile javascript into one asset
      def compile
        prepare_folders
        compile_javascripts
        create_hashed_assets
      end

      protected
      # Prepare folders
      def prepare_folders
        FileUtils.mkdir_p js_tmp_path
        FileUtils.mkdir_p js_path
      end
    end
  end
end
