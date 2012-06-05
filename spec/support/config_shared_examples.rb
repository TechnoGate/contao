shared_examples_for "Config" do
  it_should_behave_like "Singleton"

  it "should be an open struct" do
    subject.class.superclass.should == OpenStruct
  end

  it "should have a config as a superclass" do
    subject.config.class.should == OpenStruct
  end

  describe "config" do
    it "should set a configuration variable using a block" do
      klass.configure do
        config.foo = :bar
      end

      klass.instance.config.foo.should == :bar
    end

    it "should be accessible form the class level" do
      klass.configure do
        config.foo = :bar
      end

      klass.config.foo.should == :bar
    end
  end
end
