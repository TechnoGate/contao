namespace :assets do
  desc "Compile javascript"
  task :javascript do
    TechnoGate::Contao::JavascriptCompiler.compile
  end

  desc "Compile stylesheet"
  task :stylesheet do
    TechnoGate::Contao::StylesheetCompiler.compile
  end

  desc "Clean assets"
  task :clean do
    TechnoGate::Contao::StylesheetCompiler.clean
    TechnoGate::Contao::JavascriptCompiler.clean
  end

  desc "Precompile assets"
  task :precompile => [:clean, :stylesheet, :javascript]
end
