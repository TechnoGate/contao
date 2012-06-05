def print_help
  puts <<-EOH.gsub(/ [ ]+/, ' ')
    Welcome to Contao!

    This gem will help you to quickly generate an application using Contao
    CMS which has pre-built support for Sass, Compass, CoffeeScript, Jasmine
    and Capistrano.

    It also feature hashed assets served by the Contao Assets extension,
    which allows you to have an md5 appended to each of your assets URL on
    the production site.

    The integration with Capistrano allows you to quickly deploy, copy
    assets, import database and even upload media such as images and PDFs
    all from the command line using Capistrano.

    To generate a new project, use the following command:

    	$ contao new /path/to/application

    The generated application will be created at /path/to/application and the
    application name would be set to the last component in the path, in this
    case it would be application
  EOH
end
