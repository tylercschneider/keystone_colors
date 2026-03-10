# frozen_string_literal: true

require_relative "../rails_helper"

RSpec.describe "Settings", type: :request do
  let(:user) { User.create!(name: "Test") }

  before do
    uid = user.id
    KeystoneColors::ApplicationController.define_method(:current_user) { User.find(uid) }
  end

  after do
    KeystoneColors::ApplicationController.remove_method(:current_user)
  end

  describe "GET /keystone_colors/settings" do
    it "returns a successful response" do
      get "/keystone_colors/settings"

      expect(response).to have_http_status(:ok)
    end
  end
end
