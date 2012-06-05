require 'contao/version'

if ['--version', '-v'].include? ARGV.first
  puts "Contao #{Contao::VERSION}"
  exit(0)
end

case ARGV[0]
when 'new'
  require 'contao/generators/application'
  TechnoGate::Contao::Generators::Application.new(path: ARGV[1]).generate
when 'generate'
  case ARGV[1]
  when 'config'
    require 'contao/generators/config'
    begin
      TechnoGate::Contao::Generators::Config.new.generate
    rescue TechnoGate::Contao::Generators::Config::AlreadyExists
      require 'contao/notifier'
      TechnoGate::Contao::Notifier.error "The configuration file exists and cannot be overwritten", title: "Config Generator"
    end
  else
    require 'contao/commands/help'
    print_help
  end
else
  require 'contao/commands/help'
  print_help
end
