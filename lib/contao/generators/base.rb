module TechnoGate
  module Contao
    module Generators
      class Base
        def initialize(options = {})
          @options = options
        end

        def generate; end
      end
    end
  end
end
