module TechnoGate
  module Contao
    class System
      class ErrorDuringExecution < RuntimeError; end

      def self.system cmd, *args
        puts "#{cmd} #{args*' '}" if ARGV.verbose?
        fork do
          yield if block_given?
          args.collect!{|arg| arg.to_s}
          exec(cmd, *args) rescue nil
          exit! 1 # never gets here unless exec failed
        end
        Process.wait
        $?.success?
      end

      # Kernel.system but with exceptions
      def self.safe_system cmd, *args
        unless self.system cmd, *args
          args = args.map{ |arg| arg.to_s.gsub " ", "\\ " } * " "
          raise ErrorDuringExecution, "Failure while executing: #{cmd} #{args}"
        end
      end

      # prints no output
      def self.quiet_system cmd, *args
        self.system(cmd, *args) do
          $stdout.close
          $stderr.close
        end
      end
    end
  end
end
