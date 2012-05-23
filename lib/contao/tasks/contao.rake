require 'highline'

def ask(what, options = {})
  default = options[:default]
  validate = options[:validate] || /(y(es)?)|(no?)|(a(bort)?|\n)/i
  echo = (options[:echo].nil?) ? true : options[:echo]

  ui = HighLine.new
  ui.ask("#{what}?  ") do |q|
    q.overwrite = false
    q.default = default
    q.validate = validate
    q.responses[:not_valid] = what
    unless echo
      q.echo = "*"
    end
  end
end

namespace :contao do
  desc "Link all contao files"
  task :bootstrap do
    public = TechnoGate::Contao.expandify(TechnoGate::Contao::Application.config.contao_public_path)

    TechnoGate::Contao::Application.linkify

    FileUtils.mkdir_p public.join('system/logs')
    File.open(public.join('sitemap.xml'), 'w') {|f| f.write ''}

    Rake::Task['contao:fix_permissions'].invoke
    Rake::Task['contao:generate_localconfig'].invoke
    Rake::Task['contao:generate_htaccess'].invoke
    Rake::Task['assets:precompile'].invoke

    TechnoGate::Contao::Notifier.notify("The contao folder has been bootstraped, Good Luck.", title: "Contao Bootstrap")
  end

  desc "Fix permissions"
  task :fix_permissions do
    require 'fileutils'

    public = TechnoGate::Contao.expandify(TechnoGate::Contao::Application.config.contao_public_path)
    paths = [
      'system/html',
      'system/logs',
      'system/scripts',
      'system/tmp',
      'system/cache',
    ].map {|p| public.join p}.reject {|p| !File.exists? p}

    FileUtils.chmod 0777, paths

    Dir["#{public}/system/modules/efg/**/*"].each do |f|
      if File.directory?(f)
        FileUtils.chmod 0777, f
      else
        FileUtils.chmod 0666, f
      end
    end

    FileUtils.chmod 0666, public.join('sitemap.xml')

    TechnoGate::Contao::Notifier.notify("The contao folder's permissions has been fixed.", title: "Contao Bootstrap")
  end

  desc "Generate the localconfig.php"
  task :generate_localconfig do
    require 'parseconfig'

    my_cnf_path = File.expand_path("#{ENV['HOME']}/.my.cnf")
    localconfig_template = TechnoGate::Contao.expandify('config/examples/localconfig.php.erb')
    localconfig_path = TechnoGate::Contao.expandify(TechnoGate::Contao::Application.config.contao_public_path).join('system/config/localconfig.php')

    if File.exists?(my_cnf_path)
      my_cnf = ParseConfig.new(my_cnf_path)
      mysql_host = my_cnf.params['client']['host']
      mysql_user = my_cnf.params['client']['user']
      mysql_password = my_cnf.params['client']['password']
    else
      puts "Please add these details to #{my_cnf_path}"
      mysql_host = ask("What host is mysql running on", default: 'localhost', validate: /.+/)
      mysql_user = ask("What user to use with mysql", validate: /.+/)
      mysql_password = ask("What is the user's password", validate: /.+/, echo: false)
    end
    mysql_database = TechnoGate::Contao::Application.name
    contao_env = TechnoGate::Contao.env

    localconfig = ERB.new(File.read(localconfig_template)).result(binding)
    File.open(localconfig_path, 'w') {|f| f.write localconfig }

    TechnoGate::Contao::Notifier.notify("The configuration file localconfig.php was generated successfully.", title: "Contao Bootstrap")
  end

  desc "Generate the htaccess file"
  task :generate_htaccess do
    public = TechnoGate::Contao.expandify(TechnoGate::Contao::Application.config.contao_public_path)
    FileUtils.cp public.join('.htaccess.default'), public.join('.htaccess')

    TechnoGate::Contao::Notifier.notify("The .htaccess was successfully generated.", title: "Contao Bootstrap")
  end
end
