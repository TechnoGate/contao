# Taken from RefineryCMD
# https://github.com/resolve/refinerycms/blob/master/core/lib/tasks/refinery.rake
desc 'Removes trailing whitespace across the entire application.'
task :whitespace do
  require 'rbconfig'
  if RbConfig::CONFIG['host_os'] =~ /linux/
    sh %{find . -name '*.*rb' -o -name '*.*php' -o -name '*.*coffee' -o -name '*.*sass' -exec sed -i 's/\t/ /g' {} \\; -exec sed -i 's/ *$//g' {} \\; }
  elsif RbConfig::CONFIG['host_os'] =~ /darwin/
    sh %{find . -name '*.*rb' -o -name '*.*php' -o -name '*.*coffee' -o -name '*.*sass' -exec sed -i '' 's/\t/ /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
  else
    puts "This doesn't work on systems other than OSX or Linux. Please use a custom whitespace tool for your platform '#{RbConfig::CONFIG["host_os"]}'."
  end
end
