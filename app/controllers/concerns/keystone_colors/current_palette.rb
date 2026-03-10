# frozen_string_literal: true

require "active_support/concern"

module KeystoneColors
  module CurrentPalette
    extend ActiveSupport::Concern

    included do
      helper_method :keystone_palette_css if respond_to?(:helper_method)
    end

    def set_current_palette
      owner = send(KeystoneColors.configuration.current_owner_method)
      return unless owner

      cached = session[:keystone_palette]

      if cached && !stale_cache?(owner, cached)
        build_palette_css(cached[:accent], cached[:surface])
        return
      end

      preference = KeystoneColors::ThemePreference.find_by(owner: owner)
      return unless preference

      build_palette_css(preference.accent, preference.surface)
      session[:keystone_palette] = {
        accent: preference.accent,
        surface: preference.surface,
        updated_at: preference.updated_at.to_f
      }
    end

    def keystone_palette_css
      @keystone_palette_css
    end

    private

    def build_palette_css(accent, surface)
      accent_shades = resolve_shades(accent, :accent)
      surface_shades = resolve_shades(surface, :surface)

      lines = []
      accent_shades.each { |shade, hex| lines << "  --color-accent-#{shade}: #{hex};" }
      surface_shades.each { |shade, hex| lines << "  --color-surface-#{shade}: #{hex};" }

      @keystone_palette_css = ":root {\n#{lines.join("\n")}\n}"
    end

    def resolve_shades(value, type)
      if value&.start_with?("#")
        KeystoneColors::Palettes.generate_shades(value)
      else
        type == :accent ? KeystoneColors::Palettes.accent(value) : KeystoneColors::Palettes.surface(value)
      end
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
