require 'spec_helper'
require 'contao/generators/base'

module TechnoGate
  module Contao
    module Generators
      describe Base do
        let(:klass) { Base }

        it_should_behave_like "Generator"
      end
    end
  end
end
