shared_examples_for "Generator" do
  describe "Initialization" do
    it "should store any passed info in the @options" do
      klass.new(path: '/path/to/application').instance_variable_get(:@options).should ==
        {path: '/path/to/application'}
    end
  end
end
