namespace :contao do
  desc "Link all contao files"
  task :bootstrap do
    TechnoGate::Contao::Application.linkify
    TechnoGate::Contao::Notifier.notify("The contao folder has been bootstraped, Good Luck.", title: "Contao Bootstrap")
  end
end

