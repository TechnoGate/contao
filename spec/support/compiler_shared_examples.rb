shared_examples_for "Compiler" do
  describe "attributes" do
    it "should have :options as attr_accessor" do
      subject.should respond_to(:options)
      subject.should respond_to(:options=)
    end
  end

  describe "init" do
    it "should set options" do
      subject.class.new(foo: :bar).options[:foo].should == :bar
    end
  end

  describe "#compile" do
    before :each do
      subject.class.any_instance.stub(:prepare_folders)
      subject.class.any_instance.stub(:compile_assets)
      subject.class.any_instance.stub(:create_hashed_assets)
    end

    it {should respond_to :compile}

    it "should be accessible at class level" do
      subject.class.any_instance.should_receive(:compile).once
      subject.class.compile
    end

    it "should return self" do
      subject.compile.should == subject
      subject.class.compile.should be_instance_of subject.class
    end

    it "should have the following call stack" do
      subject.should_receive(:prepare_folders).once.ordered
      subject.should_receive(:compile_assets).once.ordered
      subject.should_receive(:create_hashed_assets).once.ordered
      subject.compile
    end
  end

  describe "#clean", :fakefs do
    it {should respond_to :clean}

    it "should be accessible at class level" do
      subject.class.any_instance.should_receive(:clean).once
      subject.class.clean
    end

    it "should remove the entire assets_public_path" do
      stub_filesystem!
      File.directory?("/root/public/resources").should be_true
      subject.clean
      File.directory?("/root/public/resources").should be_false
    end
  end

  describe "#prepare_folders", :fakefs do
    it {should respond_to :prepare_folders}

    it "should create the js_path" do
      subject.send :prepare_folders
      File.directory?("/root/public/resources")
    end
  end

  describe "#compile_assets" do
    it {should respond_to :compile_assets}
  end

  describe "#create_hashed_assets" do
    it {should respond_to :create_hashed_assets}
  end
end
