shared_examples_for "Singleton" do
  it "should respond to :instance" do
    klass.should respond_to :instance
  end

  it "should return an instance of the class" do
    klass.instance.should be_instance_of klass
  end

  it "should raise an error trying to instantiate the class" do
    expect { klass.new }.to raise_error NoMethodError
  end

  it "should be a singleton class" do
    klass.instance.object_id.should == klass.instance.object_id
  end
end
