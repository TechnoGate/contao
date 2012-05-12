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

    describe '#root' do
      it {should respond_to :root}
      it {should respond_to :root=}

      it "should return @@root" do
        mock("root").tap do |root|
          subject.class_variable_set(:@@root, root)
          subject.root.should == root
        end
      end

      it "should set the @@root" do
        mock("root").tap do |root|
          subject.root = root
          subject.class_variable_get(:@@root).should == Pathname.new(root).expand_path
        end
      end
    end
  end
end
