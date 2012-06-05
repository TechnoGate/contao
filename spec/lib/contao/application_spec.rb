require 'spec_helper'

module TechnoGate
  module Contao
    describe Application, :fakefs do
      subject { Contao::Application.instance }
      let(:klass) { Contao::Application }

      before :each do
        stub_filesystem!(:global_config => {'install_password' => 'some install password'})
        subject.send :parse_global_config
      end

      it_should_behave_like 'Config'

      describe "Global Config" do

        it "should parse the global config file if the file exists" do
          subject.config.global.should_not be_empty
        end

        it "should correctly parse the global config" do
          subject.config.global.install_password.should == 'some install password'
        end
      end

      describe '#linkify' do
        it "should call #exhaustive_list_of_files_to_link" do
          subject.should_receive(:exhaustive_list_of_files_to_link).with(
            Contao.expandify(Application.config.contao_path),
            Contao.expandify(Application.config.contao_public_path)
          ).once.and_return []

          subject.linkify
        end

        it "should actually link the files" do
          subject.linkify

          File.exists?('/root/public/non_existing_folder').should be_true
          File.exists?('/root/public/system/modules/some_extension').should be_true
        end

        it "should be accessible at class level" do
          subject.should_receive(:linkify).once

          Application.linkify
        end
      end

      describe '#exhaustive_list_of_files_to_link' do
        it "should return the correct list of files" do
          list = subject.send :exhaustive_list_of_files_to_link, '/root/contao', '/root/public'
          list.should == [
            ['/root/contao/non_existing_folder', '/root/public/non_existing_folder'],
            ['/root/contao/system/modules/some_extension', '/root/public/system/modules/some_extension']
          ]
        end
      end

      describe '#name' do
        it {should respond_to :name}

        describe "without it being set in the configuration" do
          before :each do
            TechnoGate::Contao::Application.configure do
              config.application_name = nil
            end
          end

          it "should return the correct name" do
            subject.name.should == 'root'
          end

          it "should be accessible at class level" do
            Application.name.should == 'root'
          end
        end

        it "should be my_awesome_project" do
          subject.name.should == 'my_awesome_project'
        end

        it "should be accessible at class level" do
          Application.name.should == 'my_awesome_project'
        end
      end
    end
  end
end
