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
          run_bundle_install
          run_cap_multistage_setup
          commit_everything
          replace_origin_with_template
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

        def run_bundle_install
          Dir.chdir project_path do
            Contao::System.safe_system 'bundle', 'install'
          end
        end

        def run_cap_multistage_setup
          Dir.chdir project_path do
            Contao::System.safe_system 'bundle', 'exec', 'cap', 'multistage:setup'
          end
        end

        def commit_everything
          Dir.chdir project_path do
            Contao::System.safe_system('git', 'add', '-A', '.')
            Contao::System.safe_system(
              'git',
              'commit',
              '-m',
              'Import generated files inside the repository'
            )
          end
        end

        def replace_origin_with_template
          Dir.chdir project_path do
            Contao::System.safe_system 'git', 'remote', 'rm', 'origin'
            Contao::System.safe_system 'git', 'remote', 'add', 'template', REPO_URL
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
