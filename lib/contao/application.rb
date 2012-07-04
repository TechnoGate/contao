require 'yaml'
require 'contao/core_ext/object'

module TechnoGate
  module Contao
    class Application
      class << self
        def linkify
          exhaustive_list_of_files_to_link(
            Rails.root.join(config.contao.path),
            Rails.public_path
          ).each do |list|
            FileUtils.ln_s list[0], list[1]
          end
        end

        def global_config_path
          "#{ENV['HOME']}/.contao/config.yml"
        end

        def load_global_config!
          config.contao.global =
            YAML.load(File.read(global_config_path)).to_openstruct
          config.contao.global.mysql.database = name unless config.contao.global.mysql.nil?
        end

        def config
          Rails.application.config
        end

        def name
          config.contao.application_name || File.basename(Rails.root)
        end

        protected

        def default_global_config(options = {})
          {
            'install_password' => '',
            'admin_email'      => 'admin@example.com',
            'time_zone'        => 'Europe/Paris',
            'mysql'            => {
              'host'           => 'localhost',
              'user'           => 'root',
              'pass'           => 'toor',
              'port'           => 3306,
            },
            'smtp'             => {
              'enabled'        => false,
              'host'           => '',
              'user'           => '',
              'pass'           => '',
              'ssl'            => true,
              'port'           => 465,
            },
          }.merge(options)
        end

        # Return an array of arrays of files to link
        #
        # @param [String] Absolute path to folder from which to link
        # @param [String] Absolute path to folder to which to link
        # @return [Array]
        def exhaustive_list_of_files_to_link(from, to)
          files = []
          Dir["#{from}/*"].each do |f|
            file = "#{to}/#{File.basename f}"
            if File.exists? file
              exhaustive_list_of_files_to_link(f, file).each { |f| files << f }
            else
              files << [f, file]
            end
          end

          files
        end
      end
    end
  end
end
