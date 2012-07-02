# Contao

Welcome to Contao!
[![Build
Status](https://secure.travis-ci.org/TechnoGate/contao.png?branch=master)](http://travis-ci.org/TechnoGate/contao)
[![Gemnasium](https://gemnasium.com/TechnoGate/contao.png)](https://gemnasium.com/TechnoGate/contao)

This gem will help you to quickly generate an application using [Contao
CMS](http://www.contao.org/en/) which has pre-built support for
[Sass](http://sass-lang.com), [Compass](http://compass-style.org),
[CoffeeScript](http://coffeescript.org),
[Jasmine](http://pivotal.github.com/jasmine/) and
[Capistrano](https://github.com/capistrano/capistrano).

It also feature hashed assets served by the [Contao Assets
extension](https://github.com/TechnoGate/contao_assets), which allows you
to have an md5 appended to each of your assets URL on the production
site.

The integration with Capistrano allows you to quickly deploy, copy
assets, import database and even upload media such as images and PDFs
all from the command line using Capistrano.

## Pre-requisites

Before installing the gem, you need to make you are running on a Ruby
version 1.9.2 or greater as this Gem and most of it's dependencies do
not support Ruby 1.8, to check the version you are running, using the
following command:

```bash
ruby --version
```

If you're running a ruby version below 1.9, please install a 1.9 version
by following the guide at the [Rbenv
Installer](https://github.com/fesplugas/rbenv-installer) project.

Contao depends on Qt (for headless javascript testing using
[jasmine](https://github.com/pivotal/jasmine) and
[jasmine-headless-webkit](http://johnbintz.github.com/jasmine-headless-webkit),
to install it, refer to [Capybara Webkit
Installation](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)

## Installation

Install contao with the following command

```ruby
gem install contao
```

Don't forget to run `rbenv rehash` if you are using
**[rbenv](https://github.com/sstephenson/rbenv)** as this gem provides
an executable.

## Database name

Locally, the database name is the same as the application name, so if
you named your project is named **my_project**, the database name will be
named **my_project**.

On the server, Capistrano will append the environment on which the
deployment occured (check the deployment section below for more
information) to the application name, so if your project is named
**my_project** and you are deployment to the staging environment, the
database name would default to **my_project_staging**

## Usage

### Generating a config file

To start using contao, you need to generate a config file, issue the
command

```bash
contao generate config
```

and follow the on-screen instructions.

### Generate a new project

Generating a new project is very easy, just use the following command:

```bash
contao new /path/to/my_project
```

This command will generate an application called `my_project` in the
folder `/path/to`, the application name is very important as it defaults
to the name of your database, check the [Database name](#database-name)
section below for more information.

### Initialising the project

Once the project generator has completed, cd into the newsly created
project and bootstrap contao by running

```bash
bundle exec rake contao:bootstrap
```

Now visit `/contao/install.php` or just visit the website and you should
be redirected to the Installation script, from here on it is the usual
Contao installation procedure, please check [Contao's user
guide](http://www.contao.org/en/installing-contao.html#install-tool) for
detailed information

### Work on the project

To be able to develop with this version of Contao, you first need to
understand how it actually works, take a look at the [project
structure](#project-structure) for more information on how files are
organised

Contao is integrated with Rails, actually only the asset pipeline
functionality is being used, Compass is also integrated with the project
so you can develop your CSS using Compass functions and mixins as well
as sprites.

To start working on the project, you need to run the rails server by
running

```bash
bundle exec foreman start
```

This will start a rails process on port **9876** and serve the assets
from their, The [Contao Assets
Extension](https://github.com/TechnoGate/contao_assets) automatically
detect that you are running in development and will use assets from the
rails server directly.

## Deploying

### Introduction

Before deploying the project, you need to edit Capistrano config files
located at `config/deploy.rb` and `config/deploy/development.rb`.

For a standard project tracked by [Git](http://git-scm.com), you do not
need to edit the file `config/deploy.rb` but you **do need** to edit
`config/deploy/development.rb` which is auto-documented.

### Multistage

Capistrano comes with support for multiple stages, you could have
`development`, `staging`, `production` or any other stage, all you need
to have is the stage name mentioned in `config/deploy.rb`

```ruby
set :stages, ['development', 'staging', 'production']
```

and a config file by the same name of the stage located at
`config/deploy/`, the Template is pre-configured for **development**,
**staging** and **production** but comes with only one config file
for **development**, to configure another stage just duplicate the
**development** file to the desired stage.

### Deploying

#### Provisioning the server

To deploy your project, you need to first configure the server, if you
are deploying to a server managed by yourself and using **Nginx**
(Apache templates will be added later), you can generate a config file
for your new site, add a user to the database and create the database
using the following command:

```shell
bundle exec cap development deploy:server:setup
```

The above step is optional and only useful if you manage your own
server, but if you are using a shared server (Hosting), running that
command would not be possible as you don't have root access.

NOTE: This command must be used only once per stage per project.

#### Setup the project

Before deploying you need to setup the project structure, generate the
**localconfig.php**, and the **.htaccess**, to do that just run

```shell
bundle exec cap development deploy:setup
```

NOTE: This command must be used only once per stage per project.

#### Deploy the project

To deploy the project simply run

```shell
bundle exec cap development deploy
```

#### Multistage

As you may have noticed, all the above commands had the **development**
stage as the first argument (first argument to **cap**), to deploy to
any other stage just use that stage's name instead.

The contao template comes pre-configured with **development** as the
**default stage**

```ruby
set :default_stage, :development
```

So if you omit the stage (the first argument) when calling **cap**

```shell
bundle exec cap deploy
```

The stage would be set to whatever `default_stage` is set to, in this
case **development**


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Or

[![Click here to lend your support to: Open Source Projects and make a donation at www.pledgie.com!](http://pledgie.com/campaigns/16123.png?skin_name=chrome)](http://www.pledgie.com/campaigns/16123)

## Contact

For bugs and feature request, please use __Github issues__, for other
requests, you may use:

- Email: [contact@technogate.fr](mailto:contact@technogate.fr)

Don't forget to follow me on [Github](https://github.com/eMxyzptlk) and
[Twitter](https://twitter.com/eMxyzptlk) for news and updates.

## Credits

I'd like to give a special thanks to the guys at [Agence
Durable](http://www.agence-durable.com) for supporting and testing this
project, [Leo Feyer](https://github.com/leofeyer) for creating an
awesome and easy to use CMS, and of course all Contao contributors, and
Finally The [Rails Core Team](http://rubyonrails.org/core) and the
entire Ruby community which are simply **awesome**.

## TODO

* The `contao` folder is a mess and can become a lot messier pretty
  quickly so we need to extract each extension into it's folder (make it
  modularized)
* Add Capistrano tasks for Starting/Stopping/Reloading Nginx
* Add Capistrano support for Apache
* The install password should be different for each website and the
  developer should be able to modify it, Basically the install password
  in `~/.contao/config.yml` should be stored in clear-text (or encrypted
  but decryptable), and once we generate a new project we should generate
  a new salt, store it in an initializer, generate the install password
  and store it in an initializer as well
* A new rake task should be created to help the user easly modify the
  install password
* The **encryption_key** should be generated for each project and not
  stored in the `~/.contao/config.yml`
* The assets takes a considerably amount of time to be uploaded,
  specially if you have many images, we should compress the entire
  folder, upload it and then extract it on the server, as it would be
  much faster to upload one file.

## Project structure

```shell
contao_template
├── Capfile
├── Gemfile
├── Procfile
├── Rakefile
├── app
│   └── assets
│       ├── images
│       ├── javascripts
│       │   └── application.js
│       └── stylesheets
│           ├── application.css.sass
│           ├── definitions
│           │   ├── _all.sass
│           │   ├── _mixins.sass
│           │   ├── _sprites.sass
│           │   └── _variables.sass
│           └── thirdparty
│               └── _pie.sass
├── config
│   ├── application.rb
│   ├── boot.rb
│   ├── compass.rb
│   ├── deploy
│   │   ├── development.rb
│   │   └── production.rb
│   ├── deploy.rb
│   ├── environment.rb
│   ├── environments
│   │   ├── development.rb
│   │   ├── production.rb
│   │   └── test.rb
│   ├── examples
│   │   └── localconfig.php.erb
│   ├── initializers
│   │   ├── secret_token.rb
│   │   └── session_store.rb
│   └── routes.rb
├── config.ru
├── contao
│   ├── plugins
│   ├── system
│   │   ├── drivers
│   │   ├── libraries
│   │   │   ├── Spyc.php -> ../../../lib/contao/libraries/spyc/spyc.php
│   │   └── modules
│   │       ├── BackupDB
│   │       ├── assets
│   │       ├── efg
│   │       ├── favicon
│   │       ├── googleanalytics
│   │       ├── listing
│   │       ├── parentslist
│   │       ├── subcolumns
│   │       ├── template-override
│   │       ├── videobox
│   │       └── videobox_vimeo
├── lib
│   ├── assets
│   │   └── javascripts
│   │       ├── form_default_values
│   │       │   ├── autoload.js.coffee
│   │       │   └── main.js.coffee
│   │       ├── form_default_values.js
│   │       └── slider.js.coffee
│   ├── contao
│   │   └── libraries
│   │       └── spyc
│   └── tasks
├── public
├── script
│   └── rails
├── spec
│   └── javascripts
│       ├── fixtures
│       │   └── slider.html
│       ├── helpers
│       │   └── spec_helper.js.coffee
│       ├── slider_spec.coffee
│       └── support
│           └── jasmine.yml
└── vendor
    └── assets
        ├── javascripts
        └── stylesheets
```


## License

### This code is free to use under the terms of the MIT license.

Copyright (c) 2011 TechnoGate &lt;support@technogate.fr&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
