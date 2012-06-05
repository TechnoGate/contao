require 'yaml'

module TechnoGate
  module Contao
    class Application < OpenStruct
      include Singleton

      def initialize
        super

        init_config
        parse_global_config
      end

      def self.configure(&block)
        instance.instance_eval(&block)
      end

      def self.config
        instance.config
      end

      def linkify
        exhaustive_list_of_files_to_link(
          Contao.expandify(Application.config.contao_path),
          Contao.expandify(Application.config.contao_public_path)
        ).each do |list|
          FileUtils.ln_s list[0], list[1]
        end
      end

      def self.linkify
        instance.linkify
      end

      def self.load_tasks
        Dir["#{File.expand_path '../tasks', __FILE__}/**/*.rake"].each {|f| load f}
      end

      def name
        self.config.application_name || File.basename(Contao.root)
      end

      def self.name
        instance.name
      end

      def self.default_global_config(options = {})
        {
          'install_password' => '',
          'encryption_key'   => '',
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

      def global_config_path
        "#{ENV['HOME']}/.contao/config.yml"
      end

      protected

      # Initialize the config
      def init_config
        self.config = OpenStruct.new
      end

      # Parse the global yaml configuration file
      def parse_global_config
        if File.exists? global_config_path
          self.config.global = YAML.load(File.read(global_config_path)).to_openstruct
        end
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
