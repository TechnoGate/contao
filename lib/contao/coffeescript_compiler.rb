require 'coffee_script'
require 'contao/compiler'
require 'fileutils'

module TechnoGate
  module Contao
    class CoffeescriptCompiler < Compiler

      def initialize(options = {})
        super
      end

      def clean
        FileUtils.rm_rf output_path.to_s if File.exists?(output_path)

        super
      end

      protected

      def input_from_config_path
        Application.config.javascripts_path
      end

      def output_from_config_path
        Contao.expandify("tmp/compiled_javascript")
      end

      def compiler_name
        :coffeescript
      end

      # Compile assets
      #
      # This method compiled coffeescripts from
      # Application.config.javascripts_path into
      # Contao.root.join('tmp/compiled_javascript')
      def compile_assets
        input_path.each do |src_path|
          Dir["#{Contao.expandify(src_path)}/**/*.coffee"].sort.each do |file|
            dest = compute_destination_filename(src_path, file)
            FileUtils.mkdir_p File.dirname(dest)
            File.open(dest, 'w') do |f|
              f.write ::CoffeeScript.compile(File.read(file))
            end
          end
        end
      end

      def compute_destination_filename(src_path, file)
        dest = "#{output_path}/#{src_path.gsub('/', '_')}/"
        dest << file.gsub(/.*#{Regexp.escape src_path}\//, '').gsub(/\.coffee$/, '')
        dest << '.js' unless File.extname(dest) == '.js'
        dest
      end
    end
  end
end
