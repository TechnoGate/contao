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
          run_rake_contao_generate_initializer
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

        def run_rake_contao_generate_initializer
          Dir.chdir project_path do
            Contao::System.safe_system(
              'bundle',
              'exec',
              'rake',
              'contao:generate_initializer'
            )
          end
        end

        def commit_everything
          Dir.chdir project_path do
            Contao::System.safe_system('git', 'add', '-A', '.')
            Contao::System.safe_system(
              'git',
              'commit',
              '-m',
              'Freshly generated project'
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
      end
    end
  end
end
