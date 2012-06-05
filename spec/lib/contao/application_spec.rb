require 'spec_helper'

module TechnoGate
  module Contao
    describe Application do
      subject { Contao::Application.instance }
      let(:klass) { Contao::Application }

      it_should_behave_like 'Config'

      describe '#linkify', :fakefs do
        before :each do
          stub_filesystem!
        end

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

      describe '#exhaustive_list_of_files_to_link', :fakefs do
        before :each do
          stub_filesystem!
        end

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

        it "should return the correct name" do
          subject.name.should == 'root'
        end

        it "should be accessible at class level" do
          Application.name.should == 'root'
        end
      end
    end
  end
end
