require 'spec_helper'

module TechnoGate
  module Contao
    describe Notifier do
      describe '#notify' do
        before :each do
          @message = "Hello"
          @output  = "Contao>> #{@message}"
          @colored_output = "\e[0;34mContao>>\e[0m \e[0;32m#{@message}\e[0m"
          @options = {title: "Hello, World!"}

          ::Guard::UI.stub(:color_enabled?).and_return(false)
        end

        it {should respond_to :notify}

        it "should call guard ui" do
          ::Guard::UI.should_receive(:info).with(@output, {})

          subject.notify(@message)
        end

        it "should send whatever options passed to the info method" do
          ::Guard::UI.should_receive(:info).with(@output, @options)

          subject.notify(@message, @options)
        end

        it "should use colors if enabled" do
          ::Guard::UI.should_receive(:color_enabled?).once.and_return(true)
          ::Guard::UI.should_receive(:info).with(@colored_output, @options)

          subject.notify(@message, @options)
        end

        it "should be accessible at class level" do
          subject.should_receive(:notify).with(@message, @options)

          subject.notify(@message, @options)
        end
      end

      describe '#warn' do
        before :each do
          @message = "Hello"
          @output  = "Contao>> #{@message}"
          @colored_output = "\e[0;34mContao>>\e[0m \e[0;33m#{@message}\e[0m"
          @options = {title: "Hello, World!"}

          ::Guard::UI.stub(:color_enabled?).and_return(false)
        end

        it {should respond_to :warn}

        it "should call guard ui" do
          ::Guard::UI.should_receive(:info).with(@output, {})

          subject.warn(@message)
        end

        it "should send whatever options passed to the info method" do
          ::Guard::UI.should_receive(:info).with(@output, @options)

          subject.warn(@message, @options)
        end

        it "should use colors if enabled" do
          ::Guard::UI.should_receive(:color_enabled?).once.and_return(true)
          ::Guard::UI.should_receive(:info).with(@colored_output, @options)

          subject.warn(@message, @options)
        end

        it "should be accessible at class level" do
          subject.should_receive(:warn).with(@message, @options)

          subject.warn(@message, @options)
        end
      end
    end
  end
end
