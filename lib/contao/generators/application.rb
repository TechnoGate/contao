require 'contao/generators/base'
require 'contao/system'

module TechnoGate
  module Contao
    module Generators
      class Application < Base
        REPO_URL = 'https://github.com/TechnoGate/contao_template.git'

        protected
        def clone_template
          git_args = "clone --recursive #{REPO_URL} "
          git_args << "#{@options[:path]}"
          Contao::System.safe_system 'git', git_args
        end

        def rename_project

        end
      end
    end
  end
end
