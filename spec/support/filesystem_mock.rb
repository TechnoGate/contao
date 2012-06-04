def stub_filesystem!
  [

    '/root/app/assets/javascripts',
    '/root/app/assets/stylesheets',
    '/root/app/assets/images',
    '/root/contao/non_existing_folder',
    '/root/contao/system/modules/some_extension',
    '/root/public/resources',
    '/root/public/system/modules/frontend',
    '/root/vendor/assets/javascripts',
    '/tmp',

  ].each do |folder|
    FileUtils.mkdir_p folder
    File.open("#{folder}/file.stub", 'w') do |f|
      f.write "Stub file"
    end
  end
end
