require 'pry'

begin
  require 'binding_of_caller'
rescue LoadError
end

def pry_it
  FakeFS.deactivate! if example.metadata[:fakefs]

  if binding.respond_to? :of_caller
    binding.of_caller(1).pry
  else
    binding.pry
  end

  FakeFS.activate!   if example.metadata[:fakefs]
end
