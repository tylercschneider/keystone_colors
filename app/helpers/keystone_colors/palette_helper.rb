# frozen_string_literal: true

module KeystoneColors
  module PaletteHelper
    def keystone_palette_style_tag
      css = controller.keystone_palette_css
      return unless css

      "<style>#{css}</style>".html_safe
    end
  end
end
