# frozen_string_literal: true

require "active_record"
require "active_support/current_attributes"
require "active_support/concern"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table :keystone_colors_theme_preferences do |t|
    t.string :accent, null: false
    t.string :surface, null: false
    t.string :template_name
    t.references :owner, polymorphic: true, null: false
    t.timestamps
  end

  create_table :users do |t|
    t.string :name
  end
end

require_relative "../../lib/keystone_colors/configuration"
require_relative "../../lib/keystone_colors/templates"
require_relative "../../app/models/keystone_colors/application_record"
require_relative "../../app/models/keystone_colors/theme_preference"

# Stub KeystoneUi::Current
module KeystoneUi
  class Current < ActiveSupport::CurrentAttributes
    attribute :accent_override, :surface_override
  end
end

require_relative "../../app/controllers/concerns/keystone_colors/current_palette"

class User < ActiveRecord::Base
  has_one :theme_preference, class_name: "KeystoneColors::ThemePreference", as: :owner
end

RSpec.describe KeystoneColors::CurrentPalette do
  let(:controller_class) do
    Class.new do
      include KeystoneColors::CurrentPalette

      attr_accessor :current_user, :session

      def initialize(user:, session: {})
        @current_user = user
        @session = session
      end
    end
  end

  let(:user) { User.create!(name: "Test") }

  after { KeystoneUi::Current.reset }

  it "sets accent and surface overrides from the owner's preference" do
    KeystoneColors::ThemePreference.create!(owner: user, accent: "emerald", surface: "stone")
    controller = controller_class.new(user: user)

    controller.set_current_palette

    expect(KeystoneUi::Current.accent_override).to eq(:emerald)
    expect(KeystoneUi::Current.surface_override).to eq(:stone)
  end
end
