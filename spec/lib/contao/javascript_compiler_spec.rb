require 'spec_helper'

module TechnoGate
  module Contao
    describe JavascriptCompiler do
      it_should_behave_like "Compiler"

      describe "#compile_assets", :fakefs do
        before :each do
          Uglifier.any_instance.stub(:compile)

          stub_filesystem!

          @file_path   = "/root/app/assets/javascripts/file.js"
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
        end

        it "should call :create_digest_for_file" do
          subject.should_receive(:create_digest_for_file).with(Pathname.new(@app_js_path)).once

          subject.send :create_hashed_assets
        end
      end

      describe "#generate_manifest" do
        it "should call generate_manifest_for" do
          subject.should_receive(:generate_manifest_for).with("javascripts", "js").once

          subject.send :generate_manifest
        end
      end

      describe "#notify" do
        it "should call Notifier.notify with the appropriate message" do
          Notifier.should_receive(:notify).with("Javascript compiler finished successfully.", title: "JavascriptCompiler").once

          subject.send :notify
        end
      end
    end
  end
end
