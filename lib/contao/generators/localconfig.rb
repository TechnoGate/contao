require 'contao/generators/base'

module TechnoGate
  module Contao
    module Generators
      class Localconfig < Base
        class LocalconfigRequired < RuntimeError; end

        def generate
          require_localconfig

          config = Contao::Application.config
          File.open localconfig_path, 'w' do |f|
            f.write ERB.new(File.read(options[:template]), nil, '-').result(binding)
          end
        end

        protected
        def require_localconfig
          raise LocalconfigRequired unless options[:template]
        end

        def localconfig_path
          Pathname.new(Rails.public_path).join 'system/config/localconfig.php'
        end
      end
    end
  end
end
