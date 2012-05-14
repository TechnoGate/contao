require 'spec_helper'

module TechnoGate
  module Contao
    describe Application do
      subject { Contao::Application.instance }
      let(:klass) { Contao::Application }

      it_should_behave_like "Singleton"

      it "should be an open struct" do
        subject.class.superclass.should == OpenStruct
      end

      it "should have a config as a superclass" do
        subject.config.class.should == OpenStruct
      end

      describe "config" do
        it "should set a configuration variable using a block" do
          Contao::Application.configure do
            config.foo = :bar
          end

          Contao::Application.instance.config.foo.should == :bar
        end

        it "should be accessible form the class level" do
          Contao::Application.configure do
            config.foo = :bar
          end

          Contao::Application.config.foo.should == :bar
        end
      end
    end
  end
end
