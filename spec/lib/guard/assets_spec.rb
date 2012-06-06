require 'spec_helper'

module Guard
  describe Assets do
    before :each do
      @stylesheet_compiler = mock('stylesheet_compiler', clean: true, compile: true)
      @coffeescript_compiler  = mock('coffeescript_compiler', clean: true, compile: true)
      @javascript_compiler  = mock('javascript_compiler', clean: true, compile: true)
      @compilers =
        [@stylesheet_compiler, @coffeescript_compiler, @javascript_compiler]

      subject.instance_variable_set :@stylesheet_compiler, @stylesheet_compiler
      subject.instance_variable_set :@coffeescript_compiler, @coffeescript_compiler
      subject.instance_variable_set :@javascript_compiler, @javascript_compiler
      subject.instance_variable_set :@compilers, @compilers
    end

    it "should inherit from Guard" do
      subject.class.superclass.should == ::Guard::Guard
    end

    describe '#init' do
      before :each do
        @assets = Assets.new
      end

      it "should create @coffeescript_compiler" do
        @assets.instance_variable_get(:@coffeescript_compiler).
          should be_instance_of TechnoGate::Contao::CoffeescriptCompiler
      end

      it "should create @javascript_compiler" do
        @assets.instance_variable_get(:@javascript_compiler).
          should be_instance_of TechnoGate::Contao::JavascriptCompiler
      end

      it "should create @stylesheet_compiler" do
        @assets.instance_variable_get(:@stylesheet_compiler).
          should be_instance_of TechnoGate::Contao::StylesheetCompiler
      end

      it "should create @compilers with a specific order with compilers specified" do
        @assets = Assets.new([], compilers: [:javascript, :coffeescript, :stylesheet])
        @assets.instance_variable_get(:@compilers).size.should == 3
        @assets.instance_variable_get(:@compilers).should == [
          @assets.instance_variable_get(:@stylesheet_compiler),
          @assets.instance_variable_get(:@coffeescript_compiler),
          @assets.instance_variable_get(:@javascript_compiler),
        ]
      end

      it "should create @compilers with a specific order" do
        subject.instance_variable_get(:@compilers).size.should == 3
        subject.instance_variable_get(:@compilers).should == [
          subject.instance_variable_get(:@stylesheet_compiler),
          subject.instance_variable_get(:@coffeescript_compiler),
          subject.instance_variable_get(:@javascript_compiler),
        ]
      end
    end

    describe "#start" do
      before :each do
        subject.stub(:run_all)
      end

      it {should respond_to :start}

      it "should call :run_all" do
        subject.should_receive(:run_all).once

        subject.start
      end
    end

    describe '#run_all' do
      it {should respond_to :run_all}

      it "Should clean assets" do
        @stylesheet_compiler.should_receive(:clean).once.ordered
        @coffeescript_compiler.should_receive(:clean).once.ordered
        @javascript_compiler.should_receive(:clean).once.ordered

        subject.run_all
      end

      it "Should recompile assets" do
        @stylesheet_compiler.should_receive(:compile).once.ordered
        @coffeescript_compiler.should_receive(:compile).once.ordered
        @javascript_compiler.should_receive(:compile).once.ordered

        subject.run_all
      end
    end

    describe '#run_on_changes' do
      before :each do
        @paths = mock('paths').as_null_object
      end

      it {should respond_to :run_on_changes}

      it "should call #compile" do
        subject.should_receive(:compile).with(@paths).once

        subject.send(:run_on_changes, @paths)
      end
    end

    describe '#run_on_removals' do
      before :each do
        @paths = mock('paths').as_null_object
      end

      it {should respond_to :run_on_removals}

      it "should call #compile" do
        subject.should_receive(:compile).with(@paths).once

        subject.send(:run_on_removals, @paths)
      end
    end

    describe '#compile' do
      it "should call compile_stylesheet only if some stylesheet paths has changed" do
        @stylesheet_compiler.should_receive(:compile).once

        subject.send :compile, ["app/assets/stylesheets/file.css"]
      end

      it "should call compile_coffeescript only if some coffeescript paths has changed" do
        @coffeescript_compiler.should_receive(:compile).once

        subject.send :compile, ["app/assets/javascripts/file.js.coffee"]
      end

      it "should call compile_javascript only if some javascript paths has changed" do
        @javascript_compiler.should_receive(:compile).once

        subject.send :compile, ["app/assets/javascripts/file.js"]
      end

      it "should compile stylesheets only once" do
        @stylesheet_compiler.should_receive(:compile).once

        subject.send :compile, ["app/assets/stylesheets/file.css", "app/assets/stylesheets/file2.css"]
      end

      it "should compile coffeescripts only once" do
        @coffeescript_compiler.should_receive(:compile).once

        subject.send :compile, ["app/assets/javascripts/file.js.coffee", "app/assets/javascripts/file2.js.coffee"]
      end

      it "should compile javascripts only once" do
        @javascript_compiler.should_receive(:compile).once

        subject.send :compile, ["app/assets/javascripts/file.js", "app/assets/javascripts/file2.js"]
      end

      it "should compile javascript if coffeescript was used" do
        @coffeescript_compiler.should_receive(:compile).once
        @javascript_compiler.should_receive(:compile).once

        subject.send :compile, ["app/assets/javascripts/file.js.coffee"]
      end

      it "should not try to compile javascript if compiler not available even if path is a js" do
        @compilers = [@stylesheet_compiler, @coffeescript_compiler]
        subject.instance_variable_set :@compilers, @compilers
        @javascript_compiler.should_not_receive(:compile)

        subject.send :compile, ["app/assets/javascripts/file.js"]
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

    describe "#is_coffeescript?" do
      it "should return true for coffeescript file" do
        subject.send(:is_coffeescript?, "app/assets/javascripts/file.js.coffee").should be_true
      end

      it "should return false for non-coffeescript files" do
        subject.send(:is_coffeescript?, "app/assets/stylesheets/file.css").should_not be_true
        subject.send(:is_coffeescript?, "app/assets/stylesheets/file.js").should_not be_true
      end
    end

    describe "#is_javascript?" do
      it "should return true for javascript file" do
        subject.send(:is_javascript?, "app/assets/javascripts/file.js").should be_true
      end

      it "should return false for non-coffeescript files" do
        subject.send(:is_javascript?, "app/assets/stylesheets/file.css").should_not be_true
      end
    end
  end
end
