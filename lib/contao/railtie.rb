module TechnoGate
  module Contao
    class Railtie < Rails::Railtie
      railtie_name :contao

      rake_tasks do
        Dir["#{File.expand_path '../../tasks', __FILE__}/**/*.rake"].each {|f| load f}
      end
    end
  end
end
