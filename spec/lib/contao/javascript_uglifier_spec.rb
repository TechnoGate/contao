require 'spec_helper'

def stub_filesystem!
  FileUtils.mkdir_p '/root/app/assets/javascripts/javascript'
  FileUtils.mkdir_p '/root/app/assets/stylesheets'
  FileUtils.mkdir_p '/root/app/assets/images'
  FileUtils.mkdir_p '/root/public/resources'
  FileUtils.mkdir_p '/root/vendor/assets/javascripts/javascript'
  FileUtils.mkdir_p '/tmp'
end

module TechnoGate
  module Contao
    describe JavascriptUglifier do
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
          Uglifier = mock("Uglifier").as_null_object
        end
      end

      subject {
        JavascriptUglifier.new
      }

      describe "attributes" do
        it "should have :options as attr_accessor" do
          subject.should respond_to(:options)
          subject.should respond_to(:options=)
        end
      end

      describe "init" do
        it "should set options" do
          JavascriptUglifier.new(foo: :bar).options[:foo].should == :bar
        end
      end

      describe "#compile" do
        before :each do
          subject.stub(:prepare_folders)
          subject.stub(:compile_javascripts)
          subject.stub(:create_hashed_assets)
        end

        it {should respond_to :compile}

        it "should return self" do
          subject.compile.should == subject
        end

        it "should have the following call stack" do
          subject.should_receive(:prepare_folders).once.ordered
          subject.should_receive(:compile_javascripts).once.ordered
          subject.should_receive(:create_hashed_assets).once.ordered
          subject.compile
        end
      end

      describe "#prepare_folders", :fakefs do
        it {should respond_to :prepare_folders}

        it "should create the js_path" do
          subject.send :prepare_folders
          File.directory?("/root/public/resources")
        end
      end

      describe "#compile_javascripts", :fakefs do
        before :each do
          Uglifier.any_instance.stub(:compile)

          stub_filesystem!

          @file_path   = "/root/app/assets/javascripts/javascript/file.js"
          @app_js_path = "/root/public/resources/application.js"

          File.open(@file_path, 'w') do |file|
            file.write("not compiled js")
          end
        end

        it {should respond_to :compile_javascripts}

        it "should compile javascripts into #{@app_js_path}" do
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

      describe "#create_hashed_assets", :fakefs do
        before :each do
          stub_filesystem!

          @app_js_path = "/root/public/resources/application.js"

          File.open(@app_js_path, 'w') do |file|
            file.write('compiled js')
          end

          @digest = Digest::MD5.hexdigest('compiled js')
          @digested_js_path = "/root/public/resources/application-#{@digest}.js"
        end

        it {should respond_to :create_hashed_assets}

        it "should create a minified version of the asset" do
          subject.send :create_hashed_assets
          File.exists?(@digested_js_path).should be_true
        end

        it "should have exactly the same content (a copy of the file)" do
          subject.send :create_hashed_assets
          File.read(@digested_js_path).should == File.read(@app_js_path)
        end
      end
    end
  end
end
