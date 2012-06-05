require 'spec_helper'
require 'contao/generators/config'

module TechnoGate
  module Contao
    module Generators
      describe Config do
        let(:klass) { Config }
        subject {
          Config.new path: @path
        }

        before :each do
          @path = '/root/my_awesome_project'
          @config_path = "#{ENV['HOME']}/.contao/config.yml"
          Notifier.stub :notify
        end

        it_should_behave_like "Generator"

        describe '#generate', :fakefs do
          before :each do
            stub_filesystem!
            FileUtils.rm_rf File.dirname(@config_path)
          end

          it "should create ~/.contao" do
            subject.generate

            File.exists?(File.dirname(@config_path)).should be_true
          end

          it "the config file should exists" do
            subject.generate

            File.exists?(@config_path).should be_true
          end

          it "should generate the config file" do
            subject.generate

            File.read("#{ENV['HOME']}/.contao/config.yml").should ==
              YAML.dump(Contao::Application.default_global_config)
          end

          it "should call the Notifier" do
            message = <<-EOS.gsub(/ [ ]+/, '').gsub("\n", ' ').chop
            The configuration file has been created at ~/.contao/config.yml,
            you need to edit this file before working with contao
            EOS
            Notifier.should_receive(:notify).with(message, title: 'Config Generator').once

            subject.generate
          end
        end
      end
    end
  end
end
