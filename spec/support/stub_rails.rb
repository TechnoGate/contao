require 'active_support/ordered_options'

module Rails
  def self.env=(env)
    @@env = env
  end

  def self.env
    @@env
  end

  def self.root=(root)
    @@root = Pathname.new root
  end

  def self.root
    @@root
  end

  def self.config
    @@config ||= begin
                  cc              = ActiveSupport::OrderedOptions.new
                  cc.contao       = ActiveSupport::OrderedOptions.new
                  cc.smtp         = ActiveSupport::OrderedOptions.new
                  cc.smtp.enabled = false
                  cc
                end
  end

  def self.application
    self
  end

  def self.public_path
    root.join 'public'
  end
end
