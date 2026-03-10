# frozen_string_literal: true

module KeystoneColors
  class SettingsController < ApplicationController
    def show
      @preference = theme_preference
    end

    def update
      @preference = theme_preference
      @preference.assign_attributes(preference_params)

      if @preference.save
        redirect_to settings_path
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def current_owner
      send(KeystoneColors.configuration.current_owner_method)
    end

    def theme_preference
      ThemePreference.find_or_initialize_by(owner: current_owner)
    end

    def preference_params
      params.require(:theme_preference).permit(:accent, :surface, :template_name)
    end
  end
end
