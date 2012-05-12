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

      def compile(env = :development)

      end
    end
  end
end
