require 'spec_helper'

module TechnoGate
  module Contao
    describe JavascriptUglifier do
      describe "attributes" do
        [:js_src_paths, :js_tmp_path, :js_path, :js_file, :options].each do |attr|
          it "should have #{attr} as attr_accessor" do
            subject.should respond_to(attr)
            subject.should respond_to("#{attr}=")
          end
        end
      end

      describe "init" do
        it "I can init the class js_src_paths" do
          mock("js_src_paths").tap do |mock|
            JavascriptUglifier.new(js_src_paths: mock).js_src_paths.should == mock
          end
        end

        it "I can init the class js_tmp_path" do
          mock("js_tmp_path").tap do |mock|
            JavascriptUglifier.new(js_tmp_path: mock).js_tmp_path.should == mock
          end
        end

        it "I can init the class js_path" do
          mock("js_path").tap do |mock|
            JavascriptUglifier.new(js_path: mock).js_path.should == mock
          end
        end

        it "I can init the class js_file" do
          mock("js_file").tap do |mock|
            JavascriptUglifier.new(js_file: mock).js_file.should == mock
          end
        end
      end
    end
  end
end
