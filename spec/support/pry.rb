require 'pry'
require 'binding_of_caller'

def pry_it
  FakeFS.deactivate! if example.metadata[:fakefs]
  binding.of_caller(1).pry
  FakeFS.activate!   if example.metadata[:fakefs]
end
