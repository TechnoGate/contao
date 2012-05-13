
def stub_filesystem!
  FileUtils.mkdir_p '/root/app/assets/javascripts/javascript'
  FileUtils.mkdir_p '/root/app/assets/stylesheets'
  FileUtils.mkdir_p '/root/app/assets/images'
  FileUtils.mkdir_p '/root/public/resources'
  FileUtils.mkdir_p '/root/vendor/assets/javascripts/javascript'
  FileUtils.mkdir_p '/tmp'
end
