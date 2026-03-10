# frozen_string_literal: true

module KeystoneColors
  class ThemePreference < ApplicationRecord
    self.table_name = "keystone_colors_theme_preferences"

    belongs_to :owner, polymorphic: true

    SUPPORTED_ACCENTS = %w[blue emerald cyan indigo violet rose].freeze

    SUPPORTED_SURFACES = %w[zinc slate gray neutral stone].freeze

    validates :accent, inclusion: { in: SUPPORTED_ACCENTS }
    validates :surface, inclusion: { in: SUPPORTED_SURFACES }
    validates :template_name, inclusion: { in: Templates.names.map(&:to_s) }, allow_nil: true
  end
end
