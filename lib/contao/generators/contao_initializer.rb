require 'contao/generators/base'

module TechnoGate
  module Contao
    module Generators
      class ContaoInitializer < Base

        TEMPLATE = File.expand_path '../../templates/contao_initializer.rb.erb', __FILE__

        def generate
          config = build_config
          File.open initializer_path, 'w' do |f|
            f.write ERB.new(File.read(TEMPLATE), nil, '-').result(binding)
          end
        end

        protected

        def initializer_path
          "#{project_path}/config/initializers/contao.rb"
        end

        def build_config
          config = ActiveSupport::OrderedOptions.new

          config.install_password = install_password
          config.encryption_key   = encryption_key
          config.admin_email      = global.admin_email
          config.time_zone        = global.time_zone
          config.smtp_enabled     = global.smtp.enabled
          config.smtp_host        = global.smtp.host
          config.smtp_user        = global.smtp.user
          config.smtp_pass        = global.smtp.pass
          config.smtp_ssl         = global.smtp.ssl
          config.smtp_port        = global.smtp.port

          config
        end

        def global
          Contao::Application.config.contao.global
        end

        def install_password
          Password.create(global.install_password).to_s
        end

        def encryption_key
          SecureRandom.hex 16
        end
      end
    end
  end
end
