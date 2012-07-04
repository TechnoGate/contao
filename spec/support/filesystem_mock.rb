def stub_filesystem!(options = {})
  [

    '/root/my_awesome_project/config',
    '/root/my_awesome_project/config/initializers',
    '/root/my_awesome_project/config/examples',
    '/root/my_awesome_project/app/assets/javascripts',
    '/root/my_awesome_project/app/assets/stylesheets',
    '/root/my_awesome_project/app/assets/images',
    '/root/my_awesome_project/contao/non_existing_folder',
    '/root/my_awesome_project/contao/system/modules/some_extension',
    '/root/my_awesome_project/public/resources',
    '/root/my_awesome_project/public/system/config',
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
  stub_localconfig!
end

def stub_localconfig!
  localconfig_path = '/root/my_awesome_project/config/examples/localconfig.php.erb'
  File.open localconfig_path, 'w' do |f|
    f.write <<-EOS
<?php if (!defined('TL_ROOT')) die('You cannot access this file directly!');

/**
 * Contao Open Source CMS
 * Copyright (C) 2005-2011 Leo Feyer
 *
 * Formerly known as TYPOlight Open Source CMS.
 *
 * This program is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program. If not, please visit the Free
 * Software Foundation website at <http://www.gnu.org/licenses/>.
 *
 * PHP version 5
 * @copyright  Leo Feyer 2005-2011
 * @author     Leo Feyer <http://www.contao.org>
 * @package    Config
 * @license    LGPL
 * @filesource
 */

### INSTALL SCRIPT START ###
$GLOBALS['TL_CONFIG']['websitePath']          = '';
$GLOBALS['TL_CONFIG']['licenseAccepted']      = true;
$GLOBALS['TL_CONFIG']['installPassword']      = '<%= config.install_password %>';
$GLOBALS['TL_CONFIG']['installCount']         = 0;
$GLOBALS['TL_CONFIG']['encryptionKey']        = '<%= config.encryption_key %>';
<% if config.db_server_app == 'mysql' -%>
$GLOBALS['TL_CONFIG']['dbDriver']             = 'MySQL';
<% end -%>
$GLOBALS['TL_CONFIG']['dbHost']               = '<%= config.db_hostname || 'localhost' %>';
$GLOBALS['TL_CONFIG']['dbPort']               = <%= config.db_port || 3306 %>;
$GLOBALS['TL_CONFIG']['dbUser']               = '<%= config.db_username %>';
$GLOBALS['TL_CONFIG']['dbPass']               = '<%= config.db_password %>';
$GLOBALS['TL_CONFIG']['dbDatabase']           = '<%= config.db_database %>';
$GLOBALS['TL_CONFIG']['dbPconnect']           = false;
$GLOBALS['TL_CONFIG']['dbCharset']            = 'UTF8';
$GLOBALS['TL_CONFIG']['adminEmail']           = '<%= config.admin_email %>';
$GLOBALS['TL_CONFIG']['cron_weekly']          = 201126;
$GLOBALS['TL_CONFIG']['latestVersion']        = '2.11.3';
$GLOBALS['TL_CONFIG']['cron_daily']           = 20110701;
$GLOBALS['TL_CONFIG']['timeZone']             = '<%= config.time_zone %>';
$GLOBALS['TL_CONFIG']['rewriteURL']           = true;
$GLOBALS['TL_CONFIG']['allowedTags']          = '<a><abbr><acronym><address><area><article><aside><b><big><blockquote><br><base><bdo><button><caption><cite><code><col><colgroup><dd><del><div><dfn><dl><dt><em><figure><figcaption><form><fieldset><footer><header><hr><h1><h2><h3><h4><h5><h6><i><iframe><img><input><ins><label><legend><li><link><map><nav><object><ol><optgroup><option><p><pre><param><q><section><select><small><span><strong><sub><sup><style><table><tbody><td><textarea><tfoot><th><thead><tr><tt><u><ul>';
<% if config.smtp.enabled -%>
$GLOBALS['TL_CONFIG']['useSMTP']              = true;
$GLOBALS['TL_CONFIG']['smtpHost']             = '<%= config.smtp.host %>';
$GLOBALS['TL_CONFIG']['smtpUser']             = '<%= config.smtp.user %>';
$GLOBALS['TL_CONFIG']['smtpPass']             = '<%= config.smtp.pass %>';
<% end -%>
<% if config.smtp.ssl -%>
$GLOBALS['TL_CONFIG']['smtpEnc']              = 'ssl';
$GLOBALS['TL_CONFIG']['smtpPort']             = <%= config.smtp.port || 465 %>;
<% end -%>
<% unless Rails.env.production? -%>
$GLOBALS['TL_CONFIG']['cacheMode']            = 'none';
$GLOBALS['TL_CONFIG']['displayErrors']        = true;
$GLOBALS['TL_CONFIG']['disableRefererCheck']  = true;
<% end -%>
### INSTALL SCRIPT STOP ###

?>
    EOS
  end
end

def stub_global_config_file!(config = {})
  condig = TechnoGate::Contao::Application.send(:default_global_config,
    'install_password' => 'password'
  ).merge(config)

  config_file = "#{ENV['HOME']}/.contao/config.yml"

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
