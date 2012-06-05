require 'spec_helper'

module TechnoGate
  module Contao
    describe StylesheetCompiler do
      it_should_behave_like "Compiler"

      describe "#compile_assets" do
        before :each do
          @updater = mock('updater')
          @updater.stub(:execute)

          Compass::Commands::UpdateProject.stub(:new).with(
            Contao.root,
            configuration_file: Contao.root.join('config', 'compass.rb')
          ).and_return(@updater)
        end

        it "should create a new updater" do
          Compass::Commands::UpdateProject.should_receive(:new).with(
            Contao.root,
            configuration_file: Contao.root.join('config', 'compass.rb')
          ).once.and_return(@updater)

          subject.send :compile_assets
        end

        it "should cache the updater" do
          Compass::Commands::UpdateProject.should_receive(:new).with(
            Contao.root,
            configuration_file: Contao.root.join('config', 'compass.rb')
          ).once.and_return(@updater)

          subject.send :compile_assets
          subject.send :compile_assets
        end

        it "should call execute on the updater" do
          @updater.should_receive(:execute).once

          subject.send :compile_assets
        end
      end

      describe "#generate_manifest" do
        it "should call generate_manifest_for" do
          subject.should_receive(:generate_manifest_for).with("stylesheets", "css").once

          subject.send :generate_manifest
        end
      end

      describe "#clean assets" do
        before :each do
          @cleaner = mock('cleaner')
          @cleaner.stub(:execute)

          Compass::Commands::CleanProject.stub(:new).with(
            Contao.root,
            configuration_file: Contao.root.join('config', 'compass.rb')
          ).and_return(@cleaner)
        end

        it "should create a new cleaner" do
          Compass::Commands::CleanProject.should_receive(:new).with(
            Contao.root,
            configuration_file: Contao.root.join('config', 'compass.rb')
          ).once.and_return(@cleaner)

          subject.clean
        end

        it "should cache the cleaner" do
          Compass::Commands::CleanProject.should_receive(:new).with(
            Contao.root,
            configuration_file: Contao.root.join('config', 'compass.rb')
          ).once.and_return(@cleaner)

          subject.clean
          subject.clean
        end

        it "should call execute on the cleaner" do
          @cleaner.should_receive(:execute).once

          subject.send :clean
        end
      end

      describe 'create_hashed_assets', :fakefs do
        before :each do
          stub_filesystem!

          @app_css_path = "/root/my_awesome_project/public/resources/application.css"

          File.open(@app_css_path, 'w') do |file|
            file.write('compiled css')
          end
        end

        it "should call :create_digest_for_file" do
          subject.should_receive(:create_digest_for_file).with(Pathname.new(@app_css_path)).once

          subject.send :create_hashed_assets
        end
      end

      describe "#notify" do
        it "should call Notifier.notify with the appropriate message" do
          Notifier.should_receive(:notify).with("Stylesheet compiler finished successfully.", title: "StylesheetCompiler").once

          subject.send :notify
        end
      end
    end
  end
end
