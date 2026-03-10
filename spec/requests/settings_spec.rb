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

  describe "GET /keystone_colors/settings" do
    it "returns a successful response" do
      get "/keystone_colors/settings"

      expect(response).to have_http_status(:ok)
    end

    it "renders a form with accent, surface, and template fields" do
      get "/keystone_colors/settings"

      body = response.body
      expect(body).to include("theme_preference[accent]")
      expect(body).to include("theme_preference[surface]")
      expect(body).to include("theme_preference[template_name]")
    end

    it "renders a reset to defaults button when preference exists" do
      KeystoneColors::ThemePreference.create!(owner: user, accent: "violet", surface: "zinc")

      get "/keystone_colors/settings"

      expect(response.body).to include("Reset to Default")
    end
  end

  describe "PATCH /keystone_colors/settings" do
    it "creates a preference with valid accent and surface" do
      patch "/keystone_colors/settings", params: {
        theme_preference: { accent: "violet", surface: "zinc" }
      }

      expect(response).to redirect_to("/keystone_colors/settings")
      pref = user.reload.theme_preference
      expect(pref.accent).to eq("violet")
      expect(pref.surface).to eq("zinc")
    end

    it "applies a template when template_name is provided" do
      patch "/keystone_colors/settings", params: {
        theme_preference: { template_name: "forest" }
      }

      expect(response).to redirect_to("/keystone_colors/settings")
      pref = user.reload.theme_preference
      expect(pref.accent).to eq("emerald")
      expect(pref.surface).to eq("stone")
      expect(pref.template_name).to eq("forest")
    end
  end

  describe "DELETE /keystone_colors/settings" do
    it "destroys the preference and redirects" do
      KeystoneColors::ThemePreference.create!(owner: user, accent: "violet", surface: "zinc")

      delete "/keystone_colors/settings"

      expect(response).to redirect_to("/keystone_colors/settings")
      expect(user.reload.theme_preference).to be_nil
    end
  end
end
