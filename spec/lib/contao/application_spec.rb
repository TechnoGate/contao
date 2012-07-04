require 'spec_helper'

module TechnoGate
  module Contao
    describe Application, :fakefs do
      subject { Contao::Application }
      let(:klass) { Contao::Application }

      before :each do
        stub_filesystem!(:global_config => {'install_password' => 'some install password'})
        subject.load_global_config!
      end

      describe "Global Config" do

        it "should parse the global config file if the file exists" do
          subject.config.contao.global.should_not be_empty
        end

        it "should correctly parse the global config" do
          subject.config.contao.global.install_password.should == 'some install password'
        end
      end

      describe '#linkify' do
        it "should call #exhaustive_list_of_files_to_link" do
          subject.should_receive(:exhaustive_list_of_files_to_link).with(
            Rails.root.join(Rails.application.config.contao.path),
            Rails.public_path
          ).once.and_return []

          subject.linkify
        end

        it "should actually link the files" do
          subject.linkify

          File.exists?('/root/my_awesome_project/public/non_existing_folder').should be_true
          File.exists?('/root/my_awesome_project/public/system/modules/some_extension').should be_true
        end

        it "should be accessible at class level" do
          subject.should_receive(:linkify).once

          Application.linkify
        end
      end

      describe '#exhaustive_list_of_files_to_link' do
        it "should return the correct list of files" do
          list = subject.send :exhaustive_list_of_files_to_link, '/root/my_awesome_project/contao', '/root/my_awesome_project/public'
          list.should == [
            ['/root/my_awesome_project/contao/non_existing_folder', '/root/my_awesome_project/public/non_existing_folder'],
            ['/root/my_awesome_project/contao/system/modules/some_extension', '/root/my_awesome_project/public/system/modules/some_extension']
          ]
        end
      end

      describe '#name' do
        it {should respond_to :name}

        describe "without it being set in the configuration" do
          before :each do
            Rails.config.tap do |config|
              config.contao.application_name = nil
            end
          end

          it "should return the correct name" do
            subject.name.should == 'my_awesome_project'
          end

          it "should be accessible at class level" do
            Application.name.should == 'my_awesome_project'
          end
        end

        describe "with it being set in the configuration" do
          before :each do
            Rails.config.tap do |config|
              config.contao.application_name = 'my_super_awesome_project'
            end
          end

          it "should be my_awesome_project" do
            subject.name.should == 'my_super_awesome_project'
          end

          it "should be accessible at class level" do
            Application.name.should == 'my_super_awesome_project'
          end
        end
      end
    end
  end
end
