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
    end
  end
end
