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

def public_path
  Pathname.new Rails.public_path
end

namespace :contao do
  desc "Link all contao files"
  task :bootstrap do
    TechnoGate::Contao::Application.linkify

    FileUtils.mkdir_p public_path.join('system/logs')
    File.open(public_path.join('sitemap.xml'), 'w') {|f| f.write ''}

    Rake::Task['contao:generate_localconfig'].invoke
    Rake::Task['contao:generate_htaccess'].invoke
    Rake::Task['contao:apply_patches'].invoke
    Rake::Task['assets:precompile'].invoke if Rails.env.production?
    Rake::Task['contao:fix_permissions'].invoke

    TechnoGate::Contao::Notifier.notify("The contao folder has been bootstraped, Good Luck.", title: "Contao Bootstrap")
  end

  desc 'Apply Patches'
  task :apply_patches do
    path = File.expand_path "../../../contao_patches/#{Rails.env}", __FILE__
    Dir["#{path}/**/*.patch"].each do |patch|
      TechnoGate::Contao::Notifier.notify("Applying patch #{File.basename patch}", title: "Contao Bootstrap")
      result = system <<-CMD
        cd #{public_path}
        patch -Nfp1 -i #{patch} --no-backup-if-mismatch
      CMD

      if !result
        TechnoGate::Contao::Notifier.notify("Patch #{File.basename patch} failed to apply", title: "Contao Bootstrap")
        abort "Please fix patches before bootstrapping"
      end
    end
  end

  desc 'Fix permissions'
  task :fix_permissions do
    require 'fileutils'

    paths = [
      'system/html',
      'system/logs',
      'system/scripts',
      'system/tmp',
      'system/cache',
      'system/config',
    ].map {|p| public_path.join p}.reject {|p| !File.exists? p}

    FileUtils.chmod 0777, paths

    FileUtils.chmod 0666, Dir["#{public_path}/system/config/**/*.php"]

    Dir["#{public_path}/system/modules/efg/**/*"].each do |f|
      if File.directory?(f)
        FileUtils.chmod 0777, f
      else
        FileUtils.chmod 0666, f
      end
    end

    FileUtils.chmod 0666, public_path.join('sitemap.xml')

    TechnoGate::Contao::Notifier.notify("The contao folder's permissions has been fixed.", title: "Contao Bootstrap")
  end

  desc "Generate the localconfig.php"
  task :generate_localconfig do
    require 'active_support/core_ext/object/blank'
    config = TechnoGate::Contao::Application.config.contao_global_config

    if !config && config.install_password.blank? || config.encryption_key.blank?
      message = <<-EOS
        You did not set the install password, and the encryption key in your
        #{ENV['HOME']}/.contao/config.yml, I cannot generate a localconfig
        since the required configuration keys are missing.
      EOS
      message.gsub!(/ [ ]+/, ' ').gsub!(/\n/, '').gsub!(/^ /, '')
      TechnoGate::Contao::Notifier.warn(message, title: "Contao Bootstrap")
    else
      config = config.clone
      config.application_name = TechnoGate::Contao::Application.name
      config.mysql.database = TechnoGate::Contao::Application.name

      localconfig_template = Rails.root.join 'config/examples/localconfig.php.erb'
      localconfig_path = public_path.join 'system/config/localconfig.php'

      localconfig = ERB.new(File.read(localconfig_template)).result(binding)
      File.open(localconfig_path, 'w') {|f| f.write localconfig }

      TechnoGate::Contao::Notifier.notify("The configuration file localconfig.php was generated successfully.", title: "Contao Bootstrap")
    end
  end

  desc "Generate the htaccess file"
  task :generate_htaccess do
    FileUtils.cp public_path.join('.htaccess.default'), public_path.join('.htaccess')

    TechnoGate::Contao::Notifier.notify("The .htaccess was successfully generated.", title: "Contao Bootstrap")
  end
end
