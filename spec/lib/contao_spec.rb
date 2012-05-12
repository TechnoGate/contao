require 'spec_helper'

module TechnoGate
  describe Contao do
    describe "#env" do
      it {should respond_to :env}
      it {should respond_to :env=}

      it "should return @@env" do
        mock("env").tap do |env|
          subject.class_variable_set(:@@env, env)
          subject.env.should == env
        end
      end

      it "should set the @@env" do
        mock("env").tap do |env|
          subject.env = env
          subject.class_variable_get(:@@env).should == env
        end
      end
    end
  end
end
