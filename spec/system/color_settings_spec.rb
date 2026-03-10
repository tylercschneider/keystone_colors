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

  it "selects a theme preset and saves" do
    visit "/keystone_colors"

    choose("theme_preference[template_name]", option: "forest")
    click_button "Save"

    expect(page).to have_text("Color settings updated.")
    pref = user.reload.theme_preference
    expect(pref.accent).to eq("emerald")
    expect(pref.surface).to eq("stone")
    expect(pref.template_name).to eq("forest")
  end

  it "selects the default theme preset and saves" do
    visit "/keystone_colors"

    choose("theme_preference[template_name]", option: "default")
    click_button "Save"

    pref = user.reload.theme_preference
    expect(pref.accent).to eq("blue")
    expect(pref.surface).to eq("zinc")
    expect(pref.template_name).to eq("default")
  end

  it "saves custom hex colors from color pickers" do
    visit "/keystone_colors"

    fill_in "theme_preference[accent]", with: "#e11d48"
    fill_in "theme_preference[surface]", with: "#44403c"
    click_button "Save"

    expect(page).to have_text("Color settings updated.")
    pref = user.reload.theme_preference
    expect(pref.accent).to eq("#e11d48")
    expect(pref.surface).to eq("#44403c")
  end

end
