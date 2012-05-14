module TechnoGate
  module Contao
    class Application < OpenStruct
      include Singleton

      def initialize
        super
        self.config = OpenStruct.new
      end

      def self.configure(&block)
        instance.instance_eval(&block)
      end

      def self.config
        instance.config
      end

      def linkify
        exhaustive_list_of_files_to_link(
          Contao.expandify(Application.config.contao_path),
          Contao.expandify(Application.config.contao_public_path)
        ).each do |list|
          FileUtils.ln_s list[0], list[1]
        end
      end

      protected

      # Return an array of arrays of files to link
      #
      # @param [String] Absolute path to folder from which to link
      # @param [String] Absolute path to folder to which to link
      # @return [Array]
      def exhaustive_list_of_files_to_link(from, to)
        files = []
        Dir["#{from}/*"].each do |f|
          file = "#{to}/#{File.basename f}"
          if File.exists? file
            exhaustive_list_of_files_to_link(f, file).each { |f| files << f }
          else
            files << [f, file]
          end
        end

        files
      end
    end
  end
end
