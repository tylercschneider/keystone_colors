# frozen_string_literal: true

module KeystoneColors
  module CurrentPalette
    extend ActiveSupport::Concern

    def set_current_palette
      owner = send(KeystoneColors.configuration.current_owner_method)
      return unless owner

      preference = KeystoneColors::ThemePreference.find_by(owner: owner)

      if preference
        KeystoneUi::Current.accent_override = preference.accent.to_sym
        KeystoneUi::Current.surface_override = preference.surface.to_sym
      end
    end
  end
end
