require 'compass'

module Compass::SassExtensions::Functions::Urls
  module ImageUrl
    def image_url(path, only_path = Sass::Script::Bool.new(false), cache_buster = Sass::Script::Bool.new(true))
      path = path.value # get to the string value of the literal.

      if path =~ %r{^#{Regexp.escape(Compass.configuration.http_images_path)}/(.*)}
        # Treat root relative urls (without a protocol) like normal if they start with
        # the images path.
        path = $1
      elsif absolute_path?(path)
        # Short curcuit if they have provided an absolute url.
        return Sass::Script::String.new("url(#{path})")
      end

      # Compute the path to the image, either root relative or stylesheet relative
      # or nil if the http_images_path is not set in the configuration.
      http_images_path = if relative?
                           compute_relative_path(Compass.configuration.images_path)
                         elsif Compass.configuration.http_images_path
                           Compass.configuration.http_images_path
                         else
                           Compass.configuration.http_root_relative(Compass.configuration.images_dir)
                         end

      # Compute the real path to the image on the file stystem if the images_dir is set.
      real_path = if Compass.configuration.images_dir
                    File.join(Compass.configuration.project_path, Compass.configuration.images_dir, path)
                  end

      # Generate the digested image (if production)
      if ::TechnoGate::Contao.env == :production
        digested_path = ::TechnoGate::Contao::Compiler.new.send(:create_digest_for_file, real_path)
        real_path = File.join(Compass.configuration.project_path, Compass.configuration.css_dir, File.dirname(path), File.basename(digested_path))
        FileUtils.mkdir_p File.dirname(real_path)
        FileUtils.mv digested_path, real_path
      else
        non_digested_path = File.join(Compass.configuration.project_path, Compass.configuration.css_dir, path)
        FileUtils.mkdir_p File.dirname(non_digested_path)
        FileUtils.cp real_path, non_digested_path

        real_path = non_digested_path
      end

      # prepend the path to the image if there's one
      if http_images_path
        http_images_path = "#{http_images_path}/" unless http_images_path[-1..-1] == "/"
        path = "#{http_images_path}#{path}"
      end

      # Generate the digested image (if production)
      if ::TechnoGate::Contao.env == :production
        path = path.gsub(File.basename(path), File.basename(digested_path))
      end

      # Compute the asset host unless in relative mode.
      asset_host = if !relative? && Compass.configuration.asset_host
                     Compass.configuration.asset_host.call(path)
                   end

      # Compute and append the cache buster if there is one.
      if cache_buster.to_bool
        if cache_buster.is_a?(Sass::Script::String)
          path += "?#{cache_buster.value}"
        else
          path = cache_busted_path(path, real_path)
        end
      end

      # prepend the asset host if there is one.
      path = "#{asset_host}#{'/' unless path[0..0] == "/"}#{path}" if asset_host

      if only_path.to_bool
        Sass::Script::String.new(clean_path(path))
      else
        clean_url(path)
      end
    end
  end
end
