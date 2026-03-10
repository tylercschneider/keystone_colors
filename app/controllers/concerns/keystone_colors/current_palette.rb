# frozen_string_literal: true

module KeystoneColors
  module CurrentPalette
    extend ActiveSupport::Concern

    def set_current_palette
      owner = send(KeystoneColors.configuration.current_owner_method)
      return unless owner

      cached = session[:keystone_palette]

      if cached && !stale_cache?(owner, cached)
        apply_overrides(cached[:accent], cached[:surface])
        return
      end

      preference = KeystoneColors::ThemePreference.find_by(owner: owner)
      return unless preference

      apply_overrides(preference.accent, preference.surface)
      session[:keystone_palette] = {
        accent: preference.accent,
        surface: preference.surface,
        updated_at: preference.updated_at.to_f
      }
    end

    private

    def apply_overrides(accent, surface)
      KeystoneUi::Current.accent_override = accent.to_sym
      KeystoneUi::Current.surface_override = surface.to_sym
    end

    def stale_cache?(owner, cached)
      updated_at = KeystoneColors::ThemePreference
        .where(owner: owner)
        .pick(:updated_at)

      return true unless updated_at

      updated_at.to_f != cached[:updated_at]
    end
  end
end
