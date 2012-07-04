require 'spec_helper'
require 'contao/generators/application'

module TechnoGate
  module Contao
    module Generators
      describe Application do
        let(:klass) { Application }

        subject {
          klass.new path: @path
        }

        before :each do
          @path = '/root/my_awesome_project'
        end

        it_should_behave_like "Generator"

        describe "#generate" do
          before :each do
            klass.any_instance.stub :clone_template
            klass.any_instance.stub :rename_project
            klass.any_instance.stub :run_bundle_install
            klass.any_instance.stub :run_rake_contao_generate_initializer
            klass.any_instance.stub :commit_everything
            klass.any_instance.stub :replace_origin_with_template
            System.stub(:system)
          end

          it "should have the following call stack" do
            subject.should_receive(:clone_template).once.ordered
            subject.should_receive(:rename_project).once.ordered
            subject.should_receive(:run_bundle_install).once.ordered
            subject.should_receive(:run_rake_contao_generate_initializer).once.ordered
            subject.should_receive(:commit_everything).once.ordered
            subject.should_receive(:replace_origin_with_template).once.ordered

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
              /config\.contao\.application_name\s+=\s+'my_awesome_project'/
          end
        end

        describe "#run_bundle_install", :fakefs do
          before :each do
            stub_filesystem!
          end

          it {should respond_to :run_bundle_install}

          it 'should change the folder to the path' do
            Dir.should_receive(:chdir).once

            subject.send :run_bundle_install
          end

          it 'should run bundle install' do
            System.should_receive(:system).with('bundle', 'install').once.and_return true

            subject.send :run_bundle_install
          end
        end

        describe '#run_rake_contao_generate_initializer', :fakefs do
          before :each do
            stub_filesystem!
          end

          it {should respond_to :run_rake_contao_generate_initializer}

          it 'should change the folder to the path' do
            Dir.should_receive(:chdir).once

            subject.send :run_rake_contao_generate_initializer
          end

          it 'should run bundle exec rake contao:generate_initializer' do
            System.should_receive(:system).with(
              'bundle',
              'exec',
              'rake',
              'contao:generate_initializer'
            ).once.and_return true

            subject.send :run_rake_contao_generate_initializer
          end
        end

        describe "#commit_everything", :fakefs do
          before :each do
            stub_filesystem!
          end

          it {should respond_to :commit_everything}

          it "should change the folder to the path" do
            Dir.should_receive(:chdir).once

            subject.send :commit_everything
          end

          it "should run git commit -am 'Generated project'" do
            System.should_receive(:system).with('git', 'add', '-A', '.').once.ordered.and_return true
            System.should_receive(:system).with(
              'git',
              'commit',
              '-m',
              'Freshly generated project'
            ).once.ordered.and_return true

            subject.send :commit_everything
          end
        end

        describe '#replace_origin_with_template', :fakefs do
          before :each do
            stub_filesystem!
          end

          it {should respond_to :replace_origin_with_template}

          it "should change the folder to the path" do
            Dir.should_receive(:chdir).once

            subject.send :replace_origin_with_template
          end

          it "should replace origin with template" do
            System.should_receive(:system).with('git', 'remote', 'rm', 'origin').once.ordered.and_return true
            System.should_receive(:system).with(
              'git',
              'remote',
              'add',
              'template',
              Application::REPO_URL
            ).once.ordered.and_return true

            subject.send :replace_origin_with_template
          end
        end
      end
    end
  end
end
