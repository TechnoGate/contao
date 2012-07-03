require 'binding_of_caller'

def pry_it
  FakeFS.deactivate! if example.metadata[:fakefs]
  binding.of_caller(1).pry
  FakeFS.activate!   if example.metadata[:fakefs]
end

#Pry.config.hooks.add_hook :before_session, :stop_fakefs do
  #FakeFS.deactivate! if current_context.example.metadata[:fakefs]
#end

#Pry.config.hooks.add_hook :after_session, :start_fakefs do
  #FakeFS.activate!   if current_context.example.metadata[:fakefs]
#end
