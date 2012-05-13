require 'contao/compiler'
require 'fileutils'
require 'uglifier'

module TechnoGate
  module Contao
    class JavascriptCompiler < Compiler

      def initialize(options = {})
        super
      end

      protected

      # Compile assets
      #
      # This method compiles javascripts from
      # Application.config.javascripts_path into
      # Application.config.assets_public_path/application.js and it uglifies
      # only if the environment is equal to :production
      def compile_assets
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
        create_digest_for_file(Contao.expandify(Contao::Application.config.assets_public_path).join("application.js"))
      end

      def application_js_path
        Contao.expandify(Application.config.assets_public_path).join("application.js")
      end
    end
  end
end
