require 'guard'
require 'guard/guard'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/try'

module Guard
  class Assets < ::Guard::Guard
    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super

      @options   = options
      @compilers = instantiate_compilers
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      run_all
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      @compilers.each do |compiler|
        compiler.clean
      end
      compile_stylesheet
      compile_coffeescript
      compile_javascript
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_changes has failed
    def run_on_changes(paths)
      compile(paths)
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_changes has failed
    def run_on_removals(paths)
      compile(paths)
    end

    protected
    def instantiate_compilers
      @options.merge!(compilers: [:stylesheet, :coffeescript, :javascript]) unless @options[:compilers]

      sort_compilers(@options[:compilers]).map(&:to_s).map do |compiler|
        self.instance_variable_set(
          "@#{compiler}_compiler",
          "::TechnoGate::Contao::#{compiler.camelize}Compiler".constantize.new(@options)
        )

        self.instance_variable_get "@#{compiler}_compiler"
      end
    end

    def sort_compilers(unsorted_compilers)
      compilers = []
      compilers << :stylesheet  if unsorted_compilers.include? :stylesheet
      compilers << :coffeescript if unsorted_compilers.include? :coffeescript
      compilers << :javascript  if unsorted_compilers.include? :javascript
    end

    def compile(paths)
      coffeescript = javascript = stylesheet = false

      paths.each do |path|
        coffeescript = true if !coffeescript && is_coffeescript?(path)
        javascript = true if !javascript && is_javascript?(path)
        stylesheet = true if !stylesheet && is_stylesheet?(path)
      end

      compile_stylesheet if stylesheet
      compile_coffeescript if coffeescript
      compile_javascript if coffeescript || javascript
    end

    def compile_stylesheet
      @stylesheet_compiler.compile
    end

    def compile_coffeescript
      @coffeescript_compiler.compile
    end

    def compile_javascript
      @javascript_compiler.compile
    end

    def is_coffeescript?(path)
      file_in_path?(path, TechnoGate::Contao::Application.config.javascripts_path) && File.extname(path) == '.coffee'
    end

    def is_javascript?(path)
      file_in_path?(path, TechnoGate::Contao::Application.config.javascripts_path) && File.extname(path) == '.js'
    end

    def is_stylesheet?(path)
      file_in_path?(path, TechnoGate::Contao::Application.config.stylesheets_path)
    end

    def file_in_path?(file, paths)
      paths = [paths] if paths.is_a?(String)

      paths.each do |path|
        return true if file.start_with?(path)
      end

      false
    end
  end
end
