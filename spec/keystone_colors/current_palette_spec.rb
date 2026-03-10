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

  it "leaves overrides unset when owner has no preference" do
    controller = controller_class.new(user: user)

    controller.set_current_palette

    expect(KeystoneUi::Current.accent_override).to be_nil
    expect(KeystoneUi::Current.surface_override).to be_nil
  end

  it "leaves overrides unset when there is no current owner" do
    controller = controller_class.new(user: nil)

    controller.set_current_palette

    expect(KeystoneUi::Current.accent_override).to be_nil
    expect(KeystoneUi::Current.surface_override).to be_nil
  end

  it "caches palette in session and skips DB on subsequent requests" do
    pref = KeystoneColors::ThemePreference.create!(owner: user, accent: "emerald", surface: "stone")
    session = {}
    controller = controller_class.new(user: user, session: session)

    controller.set_current_palette

    expect(session[:keystone_palette]).to eq(
      accent: "emerald",
      surface: "stone",
      updated_at: pref.updated_at.to_f
    )

    # Second request uses cache — change DB but session is stale check
    KeystoneUi::Current.reset
    controller2 = controller_class.new(user: user, session: session)
    expect(KeystoneColors::ThemePreference).not_to receive(:find_by)

    controller2.set_current_palette

    expect(KeystoneUi::Current.accent_override).to eq(:emerald)
  end

  it "reloads from DB when session cache is stale" do
    pref = KeystoneColors::ThemePreference.create!(owner: user, accent: "emerald", surface: "stone")
    session = {
      keystone_palette: {
        accent: "emerald",
        surface: "stone",
        updated_at: (pref.updated_at - 1).to_f
      }
    }
    controller = controller_class.new(user: user, session: session)

    pref.update!(accent: "violet", surface: "zinc")
    controller.set_current_palette

    expect(KeystoneUi::Current.accent_override).to eq(:violet)
    expect(KeystoneUi::Current.surface_override).to eq(:zinc)
    expect(session[:keystone_palette][:accent]).to eq("violet")
  end
end
