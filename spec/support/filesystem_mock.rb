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

# Pick the frameworks you want:
require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module ContaoTemplate
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The application name
    config.contao.application_name = '#{application_name}'

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(\#{config.root}/extras)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Change the prefix of the assets
    config.assets.prefix = 'resources'

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Contao configurations
    config.contao.path = 'contao'
  end
end
    EOS
  end
end
