require 'spec_helper'

module CoffeeScript
  def self.compile(contents, *args)
    contents
  end
end

module TechnoGate
  module Contao
    describe CoffeescriptCompiler do
      it_should_behave_like "Compiler"

      describe '#compile_assets', :fakefs do
        before :each do
          stub_filesystem!

          [
            '/root/app/assets/javascripts/simple_coffeescript_file.js.coffee',
            '/root/app/assets/javascripts/simple_javascript_file.js',
            '/root/app/assets/javascripts/nested/script.js.coffee',
            '/root/lib/assets/javascripts/simple_coffeescript_file.js.coffee',
            '/root/vendor/assets/javascripts/simple_coffeescript_file.js.coffee',
          ].each do |file|
            FileUtils.mkdir_p File.dirname(file)
            File.open(file, 'w') do |f|
              f.write file.
                gsub('/root/app/assets/javascripts/', '').
                gsub('/root/lib/assets/javascripts/', '').
                gsub('/root/vendor/assets/javascripts/', '')
            end
          end
        end

        it "should compile coffeescripts" do
          subject.send :compile_assets

          File.exists?('/root/tmp/compiled_javascript/app_assets_javascripts/simple_coffeescript_file.js').should be_true
          File.exists?('/root/tmp/compiled_javascript/lib_assets_javascripts/simple_coffeescript_file.js').should be_true
          File.exists?('/root/tmp/compiled_javascript/vendor_assets_javascripts/simple_coffeescript_file.js').should be_true
          File.exists?('/root/tmp/compiled_javascript/app_assets_javascripts/simple_javascript_file').should be_false
          File.exists?('/root/tmp/compiled_javascript/app_assets_javascripts/nested/script.js').should be_true
        end
      end

      describe "#compute_destination_filename" do
        it "should be able to compute given a relative file" do
          subject.send(:compute_destination_filename, "app/js", "app/js/file.js.coffee").should ==
            "/root/tmp/compiled_javascript/app_js/file.js"
        end

        it "should be able to compute given an absolute file" do
          subject.send(:compute_destination_filename, "app/js", "/root/app/js/file.js.coffee").should ==
            "/root/tmp/compiled_javascript/app_js/file.js"
        end

        it "should add automaticallty .js extension" do
          subject.send(:compute_destination_filename, "app/js", "app/js/file.coffee").should ==
            "/root/tmp/compiled_javascript/app_js/file.js"
        end
      end

      describe "#clean", :fakefs do
        before :each do
          stub_filesystem!

          FileUtils.mkdir_p '/root/tmp/compiled_javascript'
        end

        it "should remove the temporary javascript compiled files" do
          subject.clean

          File.exists?('/root/tmp/compiled_javascript').should be_false
        end
      end
    end
  end
end
