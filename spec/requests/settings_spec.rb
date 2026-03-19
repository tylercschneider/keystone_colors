# frozen_string_literal: true

require_relative "../rails_helper"

RSpec.describe "Settings", type: :request do
  let(:user) { User.create!(name: "Test") }

  before do
    uid = user.id
    KeystoneColors::ApplicationController.define_method(:current_user) { User.find(uid) }
    KeystoneColors::ApplicationController.allow_forgery_protection = false
  end

  after do
    KeystoneColors::ApplicationController.remove_method(:current_user)
  end

  describe "GET /keystone_colors" do
    it "returns a successful response" do
      get "/keystone_colors"

      expect(response).to have_http_status(:ok)
    end

    it "renders color pickers and theme presets" do
      get "/keystone_colors"

      body = response.body
      expect(body).to include('data-controller="color-picker"')
      expect(body).to include("Default")
      expect(body).to include("Ocean")
      expect(body).to include("Custom")
    end

    it "renders selected state for current theme" do
      KeystoneColors::ThemePreference.create!(owner: user, accent: "violet", surface: "zinc", template_name: "twilight")

      get "/keystone_colors"

      body = response.body
      expect(body).to include("data-selected-template=\"twilight\"")
    end
  end

  describe "PATCH /keystone_colors" do
    it "creates a preference with valid accent and surface" do
      patch "/keystone_colors", params: {
        theme_preference: {accent: "violet", surface: "zinc"}
      }

      expect(response).to redirect_to("/keystone_colors/")
      pref = user.reload.theme_preference
      expect(pref.accent).to eq("violet")
      expect(pref.surface).to eq("zinc")
    end

    it "saves custom hex colors" do
      patch "/keystone_colors", params: {
        theme_preference: {accent: "#e11d48", surface: "#44403c"}
      }

      expect(response).to redirect_to("/keystone_colors/")
      pref = user.reload.theme_preference
      expect(pref.accent).to eq("#e11d48")
      expect(pref.surface).to eq("#44403c")
    end

    it "applies a template when template_name is provided" do
      patch "/keystone_colors", params: {
        theme_preference: {template_name: "forest"}
      }

      expect(response).to redirect_to("/keystone_colors/")
      pref = user.reload.theme_preference
      expect(pref.accent).to eq("emerald")
      expect(pref.surface).to eq("stone")
      expect(pref.template_name).to eq("forest")
    end
  end

  describe "DELETE /keystone_colors" do
    it "destroys the preference and redirects" do
      KeystoneColors::ThemePreference.create!(owner: user, accent: "violet", surface: "zinc")

      delete "/keystone_colors"

      expect(response).to redirect_to("/keystone_colors/")
      expect(KeystoneColors::ThemePreference.find_by(owner: user)).to be_nil
    end
  end

  describe "form action" do
    it "uses the engine route helper for the form url" do
      get "/keystone_colors"

      expect(response.body).to include('action="/keystone_colors/"')
    end
  end
end
