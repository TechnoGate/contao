require 'rails/railtie'

module TechnoGate
  module Contao
    class Railtie < Rails::Railtie
      railtie_name :contao

      rake_tasks do
        Dir["#{File.expand_path '../../tasks', __FILE__}/**/*.rake"].each {|f| load f}
      end

      initializer 'load_contao_configurations' do
        TechnoGate::Contao::Application.load_global_config!
      end
    end
  end
end

class Rails::Railtie::Configuration
  def contao
    @contao_configuration ||= default_contao_configuration
  end

  private

  def default_contao_configuration
    cc = ActiveSupport::OrderedOptions.new
    cc.smtp = ActiveSupport::OrderedOptions.new
    cc.smtp.enabled = false
    cc
  end
end
