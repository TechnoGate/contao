module TechnoGate
  module Contao
    module Generators
      class Base
        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        def generate; end

        protected

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
