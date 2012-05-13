require 'spec_helper'

module TechnoGate
  module Contao
    describe JavascriptCompiler do
      it_should_behave_like "Compiler"

      describe "#compile_assets", :fakefs do
        before :each do
          Uglifier.any_instance.stub(:compile)

          stub_filesystem!

          @file_path   = "/root/app/assets/javascripts/javascript/file.js"
          @app_js_path = "/root/public/resources/application.js"

          File.open(@file_path, 'w') do |file|
            file.write("not compiled js")
          end
        end

        it "should compile javascripts into #{@app_js_path}" do
          subject.send :compile_assets
          File.exists?(@app_js_path).should be_true
        end

        it "should add the contents of file.js to app.js un-minified if env is development" do
          subject.send :compile_assets
          File.read(@app_js_path).should ==
            "// #{@file_path}\n#{File.read(@file_path)}\n"
        end

        it "should add the contents of file.js to app.js minified if env is production" do
          TechnoGate::Contao.env = :production
          Uglifier.any_instance.should_receive(:compile).once.and_return("compiled js")

          subject.send :compile_assets
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
