# frozen_string_literal: true

require "test_helper"

class SettingsTest < ActionDispatch::IntegrationTest
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

  test "GET /keystone_colors returns a successful response" do
    get "/keystone_colors"

    assert_response :ok
  end

  test "GET /keystone_colors renders color pickers and theme presets" do
    get "/keystone_colors"

    body = response.body
    assert_includes body, 'data-controller="color-picker"'
    assert_includes body, "Default"
    assert_includes body, "Ocean"
    assert_includes body, "Custom"
  end

  test "GET /keystone_colors renders selected state for current theme" do
    KeystoneColors::ThemePreference.create!(owner: user, accent: "violet", surface: "zinc", template_name: "twilight")

    get "/keystone_colors"

    assert_includes response.body, "data-selected-template=\"twilight\""
  end

  test "PATCH /keystone_colors creates a preference with valid accent and surface" do
    patch "/keystone_colors", params: {
      theme_preference: { accent: "violet", surface: "zinc" }
    }

    assert_redirected_to "/keystone_colors/"
    pref = user.reload.theme_preference
    assert_equal "violet", pref.accent
    assert_equal "zinc", pref.surface
  end

  test "PATCH /keystone_colors saves custom hex colors" do
    patch "/keystone_colors", params: {
      theme_preference: { accent: "#e11d48", surface: "#44403c" }
    }

    assert_redirected_to "/keystone_colors/"
    pref = user.reload.theme_preference
    assert_equal "#e11d48", pref.accent
    assert_equal "#44403c", pref.surface
  end

  test "PATCH /keystone_colors applies a template when template_name is provided" do
    patch "/keystone_colors", params: {
      theme_preference: { template_name: "forest" }
    }

    assert_redirected_to "/keystone_colors/"
    pref = user.reload.theme_preference
    assert_equal "emerald", pref.accent
    assert_equal "stone", pref.surface
    assert_equal "forest", pref.template_name
  end

  test "DELETE /keystone_colors destroys the preference and redirects" do
    KeystoneColors::ThemePreference.create!(owner: user, accent: "violet", surface: "zinc")

    delete "/keystone_colors"

    assert_redirected_to "/keystone_colors/"
    assert_nil KeystoneColors::ThemePreference.find_by(owner: user)
  end

  test "form action uses the engine route helper for the form url" do
    get "/keystone_colors"

    assert_includes response.body, 'action="/keystone_colors/"'
  end

  test "rejects unauthenticated requests" do
    KeystoneColors.configure do |config|
      config.authentication_method = :reject_all!
    end

    KeystoneColors::ApplicationController.define_method(:reject_all!) do
      head :unauthorized
    end

    get "/keystone_colors"

    assert_response :unauthorized

    KeystoneColors::ApplicationController.remove_method(:reject_all!)
    KeystoneColors.reset_configuration!
  end
end
