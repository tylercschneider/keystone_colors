# frozen_string_literal: true

module KeystoneColors
  class ThemePreference < ApplicationRecord
    self.table_name = "keystone_colors_theme_preferences"

    belongs_to :owner, polymorphic: true
  end
end
