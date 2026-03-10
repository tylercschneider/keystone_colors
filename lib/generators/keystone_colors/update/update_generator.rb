# frozen_string_literal: true

require "rails/generators"

module KeystoneColors
  module Generators
    class UpdateGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../app/javascript/keystone_colors", __dir__)

      desc "Updates KeystoneColors assets (Stimulus controller)."

      def copy_stimulus_controller
        copy_file "theme_settings_controller.js",
          "app/javascript/controllers/keystone_colors/theme_settings_controller.js"
      end
    end
  end
end
