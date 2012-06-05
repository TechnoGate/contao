require 'contao/generators/base'
require 'contao/system'

module TechnoGate
  module Contao
    module Generators
      class Application < Base
        REPO_URL = 'https://github.com/TechnoGate/contao_template.git'

        def generate
          clone_template
          rename_project
        end

        protected
        def clone_template
          git_args = "clone --recursive #{REPO_URL} #{project_path}"
          Contao::System.safe_system 'git', *git_args.split(' ')
        end

        def rename_project
          config = File.read(config_application_path)
          File.open(config_application_path, 'w') do |file|
            file.write config.gsub(/contao_template/, project_name)
          end
        end

        def config_application_path
          "#{project_path}/config/application.rb"
        end

        def project_path
          @options[:path]
        end

        def project_name
          File.basename project_path
        end
      end
    end
  end
end
