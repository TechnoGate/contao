# Contao

Welcome to Contao!
[![Build
Status](https://secure.travis-ci.org/TechnoGate/contao.png?branch=master)](http://travis-ci.org/TechnoGate/contao)
[![Gemnasium](https://gemnasium.com/TechnoGate/contao.png)](https://gemnasium.com/TechnoGate/contao)

This gem will help you to quickly generate an application using [Contao
CMS](http://www.contao.org/en/) which has pre-built support for Sass,
Compass, CoffeeScript, Jasmine and Capistrano.

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
not support Ruby 1.8, to check the version you are running, uee the
following command:

```bash
ruby --version
```

If you're running a ruby version below 1.9, please install a 1.9 version
by following the guide at the [Rbenv
Installer](https://github.com/fesplugas/rbenv-installer) project.

## Installation

Install contao with the following command

```ruby
gem install contao
```

Don't forget to run `rbenv rehash` if you are using
**[rbenv](https://github.com/sstephenson/rbenv)** as this gem provides
an executable.

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

This command will generate an application called `my\_project` in the
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
understand how it actually works.


## Database name

Locally, the database name is the same as the application name, so if
you named your project is named **my_project**, the database name will be
named **my_project**.

On the server, Capistrano will append the environment on which the
deployment occured (check the deployment section below for more
information) to the application name, so if your project is named
**my_project** and you are deployment to the staging environment, the
database name would default to **my_project_staging**

## Deploying

TODO: Write this section

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

- [Google Groups](http://groups.google.com/group/janus-vimius)
- [Github private message](https://github.com/inbox/new/eMxyzptlk)
- Email: [contact@technogate.fr](mailto:contact@technogate.fr)

Don't forget to follow me on [Github](https://github.com/eMxyzptlk) and
[Twitter](https://twitter.com/eMxyzptlk) for news and updates.

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
