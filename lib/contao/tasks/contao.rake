namespace :contao do
  desc "Link all contao files"
  task :bootstrap do
    TechnoGate::Contao::Application.linkify
  end
end

