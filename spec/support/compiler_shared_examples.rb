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

    it "should set the manifest_path as an instance variable" do
      subject.instance_variable_get(:@manifest_path).should ==
        Pathname('/root/public/resources/manifest.json')
    end
  end

  describe "#compile" do
    before :each do
      subject.class.any_instance.stub(:prepare_folders)
      subject.class.any_instance.stub(:compile_assets)
      subject.class.any_instance.stub(:create_hashed_assets)
      subject.class.any_instance.stub(:generate_manifest)
      subject.class.any_instance.stub(:notify)
    end

    it {should respond_to :compile}

    it "should be accessible at class level" do
      subject.class.any_instance.should_receive(:compile).once
      subject.class.compile
    end

    it "should return self" do
      subject.compile.should == subject
    end

    it "should have the following call stack for development" do
      subject.should_receive(:prepare_folders).once.ordered
      subject.should_receive(:compile_assets).once.ordered
      subject.should_receive(:generate_manifest).once.ordered
      subject.should_receive(:notify).once.ordered

      subject.compile
    end

    it "should have the following call stack for production" do
      TechnoGate::Contao.env = :production
      subject.should_receive(:prepare_folders).once.ordered
      subject.should_receive(:compile_assets).once.ordered
      subject.should_receive(:create_hashed_assets).once.ordered
      subject.should_receive(:notify).once.ordered

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

  describe '#create_digest_for_file', :fakefs do
    before :each do
      stub_filesystem!

      @file_path = '/root/file.something.extension'
      File.open(@file_path, 'w') do |f|
        f.write('some data')
      end

      @digest = Digest::MD5.hexdigest('some data')
      @digested_file_path = "/root/file.something-#{@digest}.extension"
    end

    it "should be able to create a hashed file" do
      subject.send(:create_digest_for_file, @file_path)
      File.exists?(@digested_file_path).should be_true
    end

    it "should have exactly the same content (a copy of the file)" do
      subject.send(:create_digest_for_file, @file_path)
      File.read(@digested_file_path).should == File.read(@file_path)
    end
  end

  describe '#generate_manifest_for', :fakefs do
    before :each do
      stub_filesystem!

      @files = [
        '/root/public/resources/application.js',
        '/root/public/resources/application-d41d8cd98f00b204e9800998ecf8427e.js'
      ].each {|f| File.open(f, 'w') {|fh| fh.write ""}}

      @manifest_path = '/root/public/resources/manifest.json'
    end

    it "should a create a JSON manifest" do
      subject.send(:generate_manifest_for, "javascripts", "js")

      File.exists?(@manifest_path).should be_true
    end

    it "should create a JSON manifest with only non-digested files if the env is development" do
      subject.send(:generate_manifest_for, "javascripts", "js")

      manifest = JSON.parse(File.read(@manifest_path))
      manifest.should have_key('javascripts')
      manifest['javascripts'].should include('application.js')
      manifest['javascripts'].should_not include('application-d41d8cd98f00b204e9800998ecf8427e.js')
    end

    it "should create a JSON manifest with only the digested file if the env is production" do
      TechnoGate::Contao.env = :production
      subject.send(:generate_manifest_for, "javascripts", "js")

      manifest = JSON.parse(File.read(@manifest_path))
      manifest.should have_key('javascripts')
      manifest['javascripts'].should include('application-d41d8cd98f00b204e9800998ecf8427e.js')
      manifest['javascripts'].should_not include('application.js')
    end

    it "should not touch anything present in the manifest" do
      File.open(@manifest_path, 'w') do |manifest|
        manifest.write({"stylesheets" => [1, 2, 3]}.to_json)
      end

      subject.send(:generate_manifest_for, "javascripts", "js")

      manifest = JSON.parse(File.read(@manifest_path))
      manifest.should have_key('stylesheets')
      manifest["stylesheets"].should == [1, 2, 3]
    end
  end
end
