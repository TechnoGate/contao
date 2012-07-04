require 'spec_helper'
require 'contao/generators/localconfig'

module TechnoGate
  module Contao
    module Generators
      describe Localconfig, :fakefs => true do
        let(:klass) { Localconfig }

        subject {
          klass.new path: @path, template: @template
        }

        before :each do
          @path = '/root/my_awesome_project'
          @template = "#{@path}/config/examples/localconfig.php.erb"

          stub_filesystem! :global_config => {
            'mysql' => {
              'host' => 'localhost',
              'user' => 'myuser',
              'pass' => 'mypass',
              'port' => 3306,
            },
          }

          Contao::Application.send :load_global_config!
        end

        it_should_behave_like 'Generator'

        describe '#generate' do
          it 'should require a template' do
            expect do
              klass.new(path: @path).generate
            end.to raise_error Localconfig::LocalconfigRequired
          end

          it 'should generate a localconfig file' do
            subject.generate
            File.exists?('/root/my_awesome_project/public/system/config/localconfig.php').should be_true
          end
        end
      end
    end
  end
end
