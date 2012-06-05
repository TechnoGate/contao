require 'guard'
require 'guard/guard'

module Guard
  class Assets < ::Guard::Guard
    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super

      @coffeescript_compiler = ::TechnoGate::Contao::CoffeescriptCompiler.new
      @javascript_compiler  = ::TechnoGate::Contao::JavascriptCompiler.new
      @stylesheet_compiler  = ::TechnoGate::Contao::StylesheetCompiler.new
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
      @stylesheet_compiler.clean
      @coffeescript_compiler.clean
      @javascript_compiler.clean
      compile_stylesheet
      compile_coffeescript
      compile_javascript
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_change(paths)
      compile(paths)
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_deletion(paths)
      compile(paths)
    end

    protected
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
