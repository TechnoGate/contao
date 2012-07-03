require 'spec_helper'
require 'contao/generators/contao_initializer.rb'

module TechnoGate
  module Contao
    module Generators
      describe ContaoInitializer, :fakefs => true do
        let(:klass) { ContaoInitializer }

        subject {
          klass.new path: @path
        }

        before :each do
          @path = '/root/my_awesome_project'

          stub_filesystem! :global_config => {
            'admin_email' => 'test@example.com',
            'time_zone'   => 'Europe/Paris',
            'smtp' => {
              'enabled' => true,
              'host'    => 'localhost',
              'user'    => 'myuser',
              'pass'    => 'mypass',
              'ssl'     => true,
              'port'    => 465,
            },
          }
        end

        it_should_behave_like "Generator"

        describe '#generate' do
          before :each do
            FakeFS.deactivate!
            template = File.read ContaoInitializer::TEMPLATE
            FakeFS.activate!
            FileUtils.mkdir_p File.dirname(ContaoInitializer::TEMPLATE)
            File.open ContaoInitializer::TEMPLATE, 'w' do |f|
              f.write template
            end
          end

          it 'should generate an initializer file' do
            subject.generate
            File.exists?('/root/my_awesome_project/config/initializers/contao.rb').should be_true
          end
        end

        describe '#build_config' do

          it 'should build a config variable for the template' do
            Password.any_instance.stub(:to_s).and_return 'encrypted_password'
            SecureRandom.stub(:hex).and_return 'e626cd6b8fd219b3e1803dc59620d972'

            config = subject.send :build_config
            config.install_password.should     == 'encrypted_password'
            config.encryption_key.should       == 'e626cd6b8fd219b3e1803dc59620d972'
            config.admin_email.should          == 'test@example.com'
            config.time_zone.should            == 'Europe/Paris'
            config.smtp_host.should            == 'localhost'
            config.smtp_user.should            == 'myuser'
            config.smtp_pass.should            == 'mypass'
            config.smtp_port.should            == 465
            config.smtp_enabled.should         be_true
            config.smtp_ssl.should             be_true
          end
        end
      end
    end
  end
end
