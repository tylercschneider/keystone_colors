# frozen_string_literal: true

module KeystoneColors
  class Configuration
    attr_accessor :owner_class_name, :current_owner_method, :default_template, :layout

    def initialize
      @owner_class_name = "User"
      @current_owner_method = :current_user
      @default_template = :ocean
      @layout = "application"
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end
end
