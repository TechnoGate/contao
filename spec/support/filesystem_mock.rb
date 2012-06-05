def stub_filesystem!(options = {})
  [

    '/root/my_awesome_project/config',
    '/root/my_awesome_project/app/assets/javascripts',
    '/root/my_awesome_project/app/assets/stylesheets',
    '/root/my_awesome_project/app/assets/images',
    '/root/my_awesome_project/contao/non_existing_folder',
    '/root/my_awesome_project/contao/system/modules/some_extension',
    '/root/my_awesome_project/public/resources',
    '/root/my_awesome_project/public/system/modules/frontend',
    '/root/my_awesome_project/vendor/assets/javascripts',
    '/tmp',

  ].each do |folder|
    FileUtils.mkdir_p folder
    File.open("#{folder}/file.stub", 'w') do |f|
      f.write "Stub file"
    end
  end

  stub_global_config_file!(options[:global_config] || {})
  stub_config_application!(options[:application_name])
end

def stub_global_config_file!(config = {})
  config = TechnoGate::Contao::Application.default_global_config(
    'install_password' => 'f0fb33dcebe5753f053b882bb49faefe7384f22e:7305d1f250f3481bac35f2839a2a4fd6',
    'encryption_key'   => 'e626cd6b8fd219b3e1803dc59620d972'
  ).merge(config)

  config_file = TechnoGate::Contao::Application.instance.global_config_path

  FileUtils.mkdir_p File.dirname(config_file)
  File.open(config_file, 'w') do |file|
    file.write YAML.dump(config)
  end
end

def stub_config_application!(application_name = 'my_awesome_project')
  File.open('/root/my_awesome_project/config/application.rb', 'w') do |f|
    f.write(<<-EOS)
require File.expand_path('../boot', __FILE__)

# Initialize the application
Dir["#{TechnoGate::Contao.root.join('config', 'initializers')}/**/*.rb"].each {|f| require f}

TechnoGate::Contao::Application.configure do
  config.application_name   = '#{application_name}'
  config.javascripts_path   = ["vendor/assets/javascripts", "lib/assets/javascripts", "app/assets/javascripts"]
  config.stylesheets_path   = 'app/assets/stylesheets'
  config.images_path        = 'app/assets/images'
  config.contao_path        = 'contao'
  config.contao_public_path = 'public'
  config.assets_public_path = 'public/resources'
end
    EOS
  end
end
