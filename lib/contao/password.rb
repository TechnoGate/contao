require 'digest/sha1'

module TechnoGate
  module Contao
    class Password
      SALT_SIZE = 23

      def initialize(password_hash)
        password_hash.split(':').tap do |p|
          @password_hash = p[0]
          @salt          = p[1]
        end
      end

      def self.create(password)
        salt = generate_salt
        new "#{hash_password(password, salt)}:#{salt}"
      end

      def to_s
        "#{@password_hash}:#{@salt}"
      end

      protected

      def self.hash_password(password, salt)
        Digest::SHA1.hexdigest "#{salt}#{password}"
      end

      def self.generate_salt
        Digest::SHA1.hexdigest(random)[0...SALT_SIZE]
      end

      def self.random(length = 50)
        (
          ('a'..'z').to_a +
          ('A'..'Z').to_a +
          (0..9).to_a
        ).shuffle[0, length].join
      end
    end
  end
end
