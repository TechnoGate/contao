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

      def compiler_name
        :javascript
      end

      def input_from_config_path
        Application.config.javascripts_path
      end

      def output_from_config_path
        Contao.expandify(Application.config.assets_public_path)
      end

      # Compile assets
      #
      # This method compiles javascripts from
      # Application.config.javascripts_path into
      # Application.config.assets_public_path/application.js and it uglifies
      # only if the environment is equal to :production
      def compile_assets
        tmp_app_js = Contao.root.join('tmp/application.js')
        FileUtils.mkdir_p File.dirname(tmp_app_js)

        File.open(tmp_app_js, 'w') do |compressed|
          javascripts_path.each do |src_path|
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

      # Generate source folders give the exact source and the folder
      # under tmp/compiled_javascript on which CoffeeScript compiler
      # adds javascript files to.
      def javascripts_path
        input_path.map do |path|
          ["tmp/compiled_javascript/#{path.gsub('/', '_')}", path]
        end.flatten
      end

      # This function creates a hashed version of the assets
      def create_hashed_assets
        create_digest_for_file(Contao.expandify(Contao::Application.config.assets_public_path).join("application.js"))
      end

      def application_js_path
        Pathname(output_from_config_path).join("application.js")
      end

      def generate_manifest
        generate_manifest_for("javascripts", "js")
      end
    end
  end
end
