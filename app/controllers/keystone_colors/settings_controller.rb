# frozen_string_literal: true

module KeystoneColors
  class SettingsController < ApplicationController
    def show
      @preference = theme_preference
    end

    private

    def current_owner
      send(KeystoneColors.configuration.current_owner_method)
    end

    def theme_preference
      ThemePreference.find_or_initialize_by(owner: current_owner)
    end
  end
end
