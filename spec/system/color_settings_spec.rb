# frozen_string_literal: true

require_relative "../rails_helper"

RSpec.describe "Color settings", type: :feature do

  let(:user) { User.create!(name: "Test") }

  before do
    uid = user.id
    KeystoneColors::ApplicationController.define_method(:current_user) { User.find(uid) }
    KeystoneColors::ApplicationController.allow_forgery_protection = false
  end

  after do
    KeystoneColors::ApplicationController.remove_method(:current_user)
  end

  it "selects accent and surface colors and saves" do
    visit "/keystone_colors"

    choose("theme_preference[accent]", option: "rose")
    choose("theme_preference[surface]", option: "slate")
    click_button "Save"

    pref = user.reload.theme_preference
    expect(pref.accent).to eq("rose")
    expect(pref.surface).to eq("slate")
  end

  it "selects a theme preset and saves" do
    visit "/keystone_colors"

    choose("theme_preference[template_name]", option: "forest")
    click_button "Save"

    pref = user.reload.theme_preference
    expect(pref.accent).to eq("emerald")
    expect(pref.surface).to eq("stone")
    expect(pref.template_name).to eq("forest")
  end

  it "updates an existing preference" do
    KeystoneColors::ThemePreference.create!(owner: user, accent: "blue", surface: "zinc")

    visit "/keystone_colors"

    choose("theme_preference[accent]", option: "violet")
    choose("theme_preference[surface]", option: "neutral")
    click_button "Save"

    pref = user.reload.theme_preference
    expect(pref.accent).to eq("violet")
    expect(pref.surface).to eq("neutral")
  end

  it "resets to default" do
    KeystoneColors::ThemePreference.create!(owner: user, accent: "violet", surface: "zinc")

    visit "/keystone_colors"

    click_button "Reset to Default"

    expect(user.reload.theme_preference).to be_nil
  end
end
