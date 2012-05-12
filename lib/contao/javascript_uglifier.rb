require 'fileutils'
require 'uglifier'

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

      # Compile javascripts
      #
      # This method compiles javascripts from js_src_paths into
      # js_path/js_file and it uglifies only if the environment is equal
      # to :production
      def compile_javascripts
        File.open(tmp_app_js, 'w') do |compressed|
          js_src_paths.each do |src_path|
            Dir["#{src_path}/**/*.js"].sort.each do |f|
              if TechnoGate::Contao.env == :production
                compressed.write(Uglifier.new.compile(File.read(f)))
              else
                compressed.write("// #{f}\n")
                compressed.write(File.read(f))
                compressed.write("\n")
              end
            end
          end
        end

        FileUtils.mv tmp_app_js, app_js
      end

      # This function creates a hashed version of the assets
      def create_hashed_assets
        digest = Digest::MD5.hexdigest(File.read(app_js))
        hashed_app_js_filename = "#{js_file.chomp(File.extname(js_file))}-#{digest}#{File.extname(js_file)}"
        hashed_app_js_path = File.join(js_path, hashed_app_js_filename)
        FileUtils.ln_s js_file, hashed_app_js_path
      end

      def tmp_app_js
        File.join js_tmp_path, js_file
      end

      def app_js
        File.join js_path, js_file
      end
    end
  end
end
