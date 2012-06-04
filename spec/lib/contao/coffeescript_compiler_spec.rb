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
          ].each do |file|
            FileUtils.mkdir_p File.dirname(file)
            File.open(file, 'w') do |f|
              f.write file.gsub('/root/app/assets/javascripts/', '')
            end
          end
        end

        it "should compile coffeescripts" do
          subject.send :compile_assets

          File.exists?('/root/tmp/compiled_javascript/simple_coffeescript_file.js').should be_true
          File.exists?('/root/tmp/compiled_javascript/simple_javascript_file').should be_false
          File.exists?('/root/tmp/compiled_javascript/nested/script.js').should be_true
        end
      end

      describe "#compute_destination_filename" do
        it "should be able to compute given a relative file" do
          subject.send(:compute_destination_filename, "jses", "jses/file.js.coffee").should ==
            "/root/tmp/compiled_javascript/file.js"
        end

        it "should be able to compute given an absolute file" do
          subject.send(:compute_destination_filename, "jses", "/root/jses/file.js.coffee").should ==
            "/root/tmp/compiled_javascript/file.js"
        end

        it "should add automaticallty .js extension" do
          subject.send(:compute_destination_filename, "jses", "jses/file.coffee").should ==
            "/root/tmp/compiled_javascript/file.js"
        end
      end
    end
  end
end
