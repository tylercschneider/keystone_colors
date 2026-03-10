# frozen_string_literal: true

module KeystoneColors
  module Templates
    PRESETS = {
      default: {
        accent: :blue,
        surface: :zinc,
        label: "Default",
        description: "Blue accent with zinc surfaces"
      },
      ocean: {
        accent: :blue,
        surface: :slate,
        label: "Ocean",
        description: "Cool blues with slate undertones"
      },
      forest: {
        accent: :emerald,
        surface: :stone,
        label: "Forest",
        description: "Natural greens with warm stone"
      },
      twilight: {
        accent: :violet,
        surface: :zinc,
        label: "Twilight",
        description: "Deep violet with clean zinc"
      },
      coral: {
        accent: :rose,
        surface: :neutral,
        label: "Coral",
        description: "Warm rose with neutral balance"
      },
      arctic: {
        accent: :cyan,
        surface: :gray,
        label: "Arctic",
        description: "Bright cyan with crisp gray"
      }
    }.freeze

    def self.all
      PRESETS
    end

    def self.[](name)
      PRESETS.fetch(name.to_sym)
    end

    def self.names
      PRESETS.keys
    end
  end
end
