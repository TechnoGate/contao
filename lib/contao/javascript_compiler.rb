require 'fileutils'
require 'uglifier'

module TechnoGate
  module Contao
    class JavascriptCompiler
      attr_accessor :options

      def initialize(options = {})
        @options      = options
      end

      # Compile javascript into one asset
      def compile
        prepare_folders
        compile_javascripts
        create_hashed_assets

        self
      end

      protected
      # Prepare folders
      def prepare_folders
        FileUtils.mkdir_p Contao.expandify(Application.config.assets_public_path)
      end

      # Compile javascripts
      #
      # This method compiles javascripts from
      # Application.config.javascripts_path into
      # Application.config.assets_public_path/application.js and it uglifies
      # only if the environment is equal to :production
      def compile_javascripts
        tmp_app_js = "/tmp/application-#{Time.now.usec}.js"

        File.open(tmp_app_js, 'w') do |compressed|
          Application.config.javascripts_path.each do |src_path|
            Dir["#{Contao.expandify(src_path)}/**/*.js"].sort.each do |f|
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

        FileUtils.mv tmp_app_js, application_js_path
      end

      # This function creates a hashed version of the assets
      def create_hashed_assets
        digest = Digest::MD5.hexdigest(File.read(application_js_path))
        hashed_app_js_path = "#{application_js_path.to_s.chomp(File.extname(application_js_path))}-#{digest}#{File.extname(application_js_path)}"
        FileUtils.cp application_js_path, hashed_app_js_path
      end

      def application_js_path
        Contao.expandify(Application.config.assets_public_path).join("application.js")
      end
    end
  end
end
