require 'spec_helper'

module TechnoGate
  module Contao
    describe StylesheetCompiler do
      before :each do
        Contao.env  = @env  = :development
        Contao.root = @root = "/root"
        Application.configure do
          config.javascripts_path   = ["vendor/assets/javascripts/javascript", "app/assets/javascripts/javascript"]
          config.stylesheets_path   = 'app/assets/stylesheets'
          config.images_path        = 'app/assets/images'
          config.assets_public_path = 'public/resources'
        end

        silence_warnings do
          ::Compass::Commands::UpdateProject = stub.as_null_object
        end
      end

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
    end
  end
end
