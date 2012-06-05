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
          @path = '/path/to/application'
        end

        it_should_behave_like "Generator"

        describe "#clone_template" do
          it {should respond_to :clone_template}

          it "should clone the repository to path provided to the initializer" do
            System.should_receive(:system).with(
              'git',
              "clone --recursive #{Application::REPO_URL} #{@path}"
            ).once.and_return true

            subject.send :clone_template
          end
        end

        describe "#rename_project", :fakefs do
          before :each do

          end

          it {should respond_to :rename_project}


        end
      end
    end
  end
end

