require 'contao/generators/base'
require 'contao/application'
require 'contao/notifier'
require 'fileutils'

module TechnoGate
  module Contao
    module Generators
      class Config < Base
        class ConfigAlreadyExists < RuntimeError; end

        def generate
          FileUtils.mkdir_p File.dirname(global_config_path)
          File.open global_config_path, 'w' do |config|
            config.write YAML.dump(Contao::Application.default_global_config)
          end

          message = <<-EOS.gsub(/ [ ]+/, '').gsub("\n", ' ').chop
          The configuration file has been created at ~/.contao/config.yml,
          you need to edit this file before working with contao
          EOS
          Notifier.notify message, title: 'Config Generator'
        end

        def global_config_path
          Contao::Application.instance.global_config_path
        end
      end
    end
  end
end
