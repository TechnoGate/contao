require 'spec_helper'

module Guard
  describe Assets do
    it "should inherit from Guard" do
      subject.class.superclass.should == ::Guard::Guard
    end

    describe '#init' do
      it "should create @javascript_compiler" do
        subject.instance_variable_get(:@javascript_compiler).
          should be_instance_of TechnoGate::Contao::JavascriptCompiler
      end

      it "should create @stylesheet_compiler" do
        subject.instance_variable_get(:@stylesheet_compiler).
          should be_instance_of TechnoGate::Contao::StylesheetCompiler
      end
    end

    describe '#run_all' do
      before :each do
        @stylesheet_compiler = mock('stylesheet_compiler', :clean => true)
        @javascript_compiler  = mock('javascript_compiler', :clean => true)

        subject.instance_variable_set(:@stylesheet_compiler, @stylesheet_compiler)
        subject.instance_variable_set(:@javascript_compiler, @javascript_compiler)

        subject.stub(:compile_stylesheet)
        subject.stub(:compile_javascript)
      end

      it {should respond_to :run_all}

      it "Should clean assets" do
        @stylesheet_compiler.should_receive(:clean).once.ordered
        @javascript_compiler.should_receive(:clean).once.ordered

        subject.run_all
      end

      it "Should recompile assets" do
        subject.should_receive(:compile_stylesheet).once.ordered
        subject.should_receive(:compile_javascript).once.ordered

        subject.run_all
      end
    end

    describe '#run_on_change' do
      before :each do
        @paths = mock('paths').as_null_object
      end

      it {should respond_to :run_on_change}

      it "should call #compile" do
        subject.should_receive(:compile).with(@paths).once

        subject.send(:run_on_change, @paths)
      end
    end

    describe '#run_on_deletion' do
      before :each do
        @paths = mock('paths').as_null_object
      end

      it {should respond_to :run_on_deletion}

      it "should call #compile" do
        subject.should_receive(:compile).with(@paths).once

        subject.send(:run_on_deletion, @paths)
      end
    end

    describe '#compile_stylesheet' do
      before :each do
        @stylesheet_compiler = mock('stylesheet_compiler', :clean => true)

        subject.instance_variable_set(:@stylesheet_compiler, @stylesheet_compiler)
      end

      it {should respond_to :compile_stylesheet}

      it "should call @stylesheet_compiler.compile" do
        @stylesheet_compiler.should_receive(:compile).once

        subject.send :compile_stylesheet
      end
    end

    describe '#compile_javascript' do
      before :each do
        @javascript_compiler  = mock('javascript_compiler', :clean => true)

        subject.instance_variable_set(:@javascript_compiler, @javascript_compiler)
      end

      it {should respond_to :compile_javascript}

      it "should call @javascript_compiler.compile" do
        @javascript_compiler.should_receive(:compile).once

        subject.send :compile_javascript
      end
    end

    describe '#compile' do
      before :each do
        subject.stub :compile_stylesheet
        subject.stub :compile_javascript
      end

      it "should call compile_stylesheet only if some stylesheet paths has changed" do
        subject.should_receive(:compile_stylesheet).once

        subject.send :compile, ["app/assets/stylesheets/file.css"]
      end

      it "should call compile_javascript only if some javascript paths has changed" do
        subject.should_receive(:compile_javascript).once

        subject.send :compile, ["app/assets/javascripts/javascript/file.js"]
      end

      it "should compile stylesheets only once" do
        subject.should_receive(:compile_stylesheet).once

        subject.send :compile, ["app/assets/stylesheets/file.css", "app/assets/stylesheets/file2.css"]
      end

      it "should compile javascripts only once" do
        subject.should_receive(:compile_javascript).once

        subject.send :compile, ["app/assets/javascripts/javascript/file.css", "app/assets/javascripts/javascript/file2.css"]
      end
    end

    describe "#file_in_path?" do
      it "should return true" do
        subject.send(:file_in_path?, "app/file.js", "app").should be_true
        subject.send(:file_in_path?, "app/file.js", ["app"]).should be_true
      end

      it "should return false" do
        subject.send(:file_in_path?, "app/file.js", "lib").should_not be_true
        subject.send(:file_in_path?, "app/file.js", ["lib"]).should_not be_true
      end
    end

    describe "#is_stylesheet?" do
      it "should return true for stylesheet file" do
        subject.send(:is_stylesheet?, "app/assets/stylesheets/file.css").should be_true
      end

      it "should return false for non-stylesheet files" do
        subject.send(:is_stylesheet?, "app/assets/javascripts/file.css").should_not be_true
      end
    end

    describe "#is_javascript?" do
      it "should return true for stylesheet file" do
        subject.send(:is_javascript?, "app/assets/javascripts/javascript/file.js").should be_true
      end

      it "should return false for non-stylesheet files" do
        subject.send(:is_javascript?, "app/assets/stylesheets/file.css").should_not be_true
      end
    end
  end
end
