require 'spec_helper'

module TechnoGate
  module Contao
    describe JavascriptUglifier do
      before :each do
        TechnoGate::Contao.env = :development

        silence_warnings do
          Uglifier = mock("Uglifier").as_null_object
        end
      end

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

      describe "#compile" do
        it {should respond_to :compile}

        it "should have the following call stack" do
          subject.should_receive(:prepare_folders).once.ordered
          subject.should_receive(:compile_javascripts).once.ordered
          subject.should_receive(:create_hashed_assets).once.ordered
          subject.compile
        end
      end

      describe "#prepare_folders", :fakefs do
        before :each do
          subject.js_tmp_path = '/tmp'
          subject.js_path     = '/src'
        end

        it {should respond_to :prepare_folders}

        it "should create the js_tmp_path" do
          subject.send :prepare_folders
          File.directory?(subject.js_tmp_path).should be_true
        end

        it "should create the js_path" do
          subject.send :prepare_folders
          File.directory?(subject.js_path).should be_true
        end
      end

      describe "#compile_javascripts", :fakefs do
        before :each do
          Uglifier.any_instance.stub(:compile)

          subject.js_src_paths = ["/src"]
          subject.js_tmp_path  = "/tmp"
          subject.js_path      = "/js"
          subject.js_file      = "app.js"

          FileUtils.mkdir_p subject.js_src_paths.first
          FileUtils.mkdir_p subject.js_tmp_path
          FileUtils.mkdir_p subject.js_path

          @file_path   = File.join(subject.js_src_paths.first, "file.js")
          @app_js_path = File.join(subject.js_path, subject.js_file)

          File.open(@file_path, 'w') do |file|
            file.write("not compiled js")
          end
        end

        it {should respond_to :compile_javascripts}

        it "should compile javascripts into js_path/js_file" do
          subject.send :compile_javascripts
          File.exists?(@app_js_path).should be_true
        end

        it "should add the contents of file.js to app.js un-minified if env is development" do
          subject.send :compile_javascripts
          File.read(@app_js_path).should ==
            "// #{@file_path}\n#{File.read(@file_path)}\n"
        end

        it "should add the contents of file.js to app.js minified if env is production" do
          TechnoGate::Contao.env = :production
          Uglifier.any_instance.should_receive(:compile).once.and_return("compiled js")

          subject.send :compile_javascripts
          File.read(@app_js_path).should == "compiled js"
        end
      end
    end
  end
end
