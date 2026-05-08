# frozen_string_literal: true

require "application_system_test_case"

class ColorSettingsTest < ApplicationSystemTestCase
  def user
    @user ||= User.create!(name: "Test")
  end

  def setup
    uid = user.id
    KeystoneColors::ApplicationController.define_method(:current_user) { User.find(uid) }
    KeystoneColors::ApplicationController.define_method(:authenticate_user!) { true }
    KeystoneColors::ApplicationController.allow_forgery_protection = false
  end

  def teardown
    KeystoneColors::ApplicationController.remove_method(:current_user) rescue nil
    KeystoneColors::ApplicationController.remove_method(:authenticate_user!) rescue nil
  end

  test "selects a theme preset and saves" do
    visit "/keystone_colors"

    choose("theme_preference[template_name]", option: "forest")
    click_button "Save"

    assert_text "Color settings updated."
    pref = user.reload.theme_preference
    assert_equal "emerald", pref.accent
    assert_equal "stone", pref.surface
    assert_equal "forest", pref.template_name
  end

  test "selects the default theme preset and saves" do
    visit "/keystone_colors"

    choose("theme_preference[template_name]", option: "default")
    click_button "Save"

    pref = user.reload.theme_preference
    assert_equal "blue", pref.accent
    assert_equal "zinc", pref.surface
    assert_equal "default", pref.template_name
  end

  test "renders color picker components" do
    visit "/keystone_colors"

    assert_css "[data-controller='color-picker']", count: 2
  end
end
