require 'coffee_script'
require 'contao/compiler'
require 'fileutils'

module TechnoGate
  module Contao
    class CoffeescriptCompiler < Compiler

      def initialize(options = {})
        super
      end

      protected

      # Compile assets
      #
      # This method compiled coffeescripts from
      # Application.config.javascripts_path into
      # Contao.root.join('tmp/compiled_javascript')
      def compile_assets
        Application.config.javascripts_path.each do |src_path|
          Dir["#{Contao.expandify(src_path)}/**/*.coffee"].sort.each do |file|
            dest = compute_destination_filename(src_path, file)
            p dest
            FileUtils.mkdir_p File.dirname(dest)
            File.open(dest, 'w') do |f|
              f.write ::CoffeeScript.compile(File.read(file))
            end
          end
        end
      end

      def compute_destination_filename(src_path, file)
        dest = "#{Contao.expandify("tmp/compiled_javascript")}/"
        dest << file.gsub(/.*#{Regexp.escape src_path}\//, '').gsub(/\.coffee$/, '')
        dest << '.js' unless File.extname(dest) == '.js'
        dest
      end
    end
  end
end
