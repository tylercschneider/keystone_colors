# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module KeystoneColors
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Installs KeystoneColors: copies migration and prints setup instructions."

      def copy_migration
        migration_template(
          "create_keystone_colors_theme_preferences.rb.erb",
          "db/migrate/create_keystone_colors_theme_preferences.rb"
        )
      end

      def copy_stimulus_controller
        js_source = File.expand_path("../../../../app/javascript/keystone_colors/theme_settings_controller.js", __dir__)
        create_file "app/javascript/controllers/keystone_colors/theme_settings_controller.js", File.read(js_source)
      end

      def show_instructions
        say ""
        say "KeystoneColors installed! Next steps:", :green
        say ""
        say "  1. Run migrations:"
        say "       rails db:migrate"
        say ""
        say "  2. Mount the engine in config/routes.rb:"
        say "       mount KeystoneColors::Engine => '/keystone_colors'"
        say ""
        say "  3. Include the concern in your ApplicationController:"
        say "       include KeystoneColors::CurrentPalette"
        say "       before_action :set_current_palette"
        say ""
      end
    end
  end
end
