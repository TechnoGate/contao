require 'spec_helper'
require 'contao/generators/application'

module TechnoGate
  module Contao
    module Generators
      describe Application do
        let(:klass) { Application }
        subject {
          Application.new path: @path
        }

        before :each do
          @path = '/root/my_awesome_project'
        end

        it_should_behave_like "Generator"

        describe "#generate" do
          before :each do
            klass.any_instance.stub :clone_template
            klass.any_instance.stub :rename_project
          end

          it "should clone the repository and then rename the project" do
            subject.should_receive(:clone_template).once.ordered
            subject.should_receive(:rename_project).once.ordered

            subject.generate
          end
        end

        describe "#clone_template" do
          it {should respond_to :clone_template}

          it "should clone the repository to path provided to the initializer" do
            System.should_receive(:system).with(
              'git',
              'clone',
              '--recursive',
              Application::REPO_URL,
              @path
            ).once.and_return true

            subject.send :clone_template
          end
        end

        describe "#rename_project", :fakefs do
          before :each do
            stub_filesystem!(:application_name => 'contao_template')
          end

          it {should respond_to :rename_project}

          it "should rename the application" do
            subject.send :rename_project

            File.read('/root/my_awesome_project/config/application.rb').should =~
              /config\.application_name\s+=\s+'my_awesome_project'/
          end
        end
      end
    end
  end
end

