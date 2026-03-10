# frozen_string_literal: true

require "active_record"

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

require_relative "../../lib/keystone_colors/templates"
require_relative "../../app/models/keystone_colors/application_record"
require_relative "../../app/models/keystone_colors/theme_preference"

class User < ActiveRecord::Base
  has_one :theme_preference, class_name: "KeystoneColors::ThemePreference", as: :owner
end

RSpec.describe KeystoneColors::ThemePreference do
  let(:user) { User.create!(name: "Test") }

  it "belongs to a polymorphic owner" do
    pref = described_class.create!(
      owner: user,
      accent: "blue",
      surface: "slate"
    )

    expect(pref.owner).to eq(user)
    expect(pref.owner_type).to eq("User")
  end

  it "validates accent is a supported value" do
    pref = described_class.new(owner: user, accent: "neon", surface: "slate")

    expect(pref).not_to be_valid
    expect(pref.errors[:accent]).to include(/is not included/)
  end

  it "validates surface is a supported value" do
    pref = described_class.new(owner: user, accent: "blue", surface: "marble")

    expect(pref).not_to be_valid
    expect(pref.errors[:surface]).to include(/is not included/)
  end

  it "validates template_name is a known template when present" do
    pref = described_class.new(owner: user, accent: "blue", surface: "slate", template_name: "unknown")

    expect(pref).not_to be_valid
    expect(pref.errors[:template_name]).to include(/is not included/)
  end
end
