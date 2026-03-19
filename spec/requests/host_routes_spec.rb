# frozen_string_literal: true

require_relative "../rails_helper"

RSpec.describe "Host route helpers in engine views", type: :request do
  let(:user) { User.create!(name: "Test") }

  before do
    uid = user.id
    KeystoneColors::ApplicationController.define_method(:current_user) { User.find(uid) }
    KeystoneColors::ApplicationController.allow_forgery_protection = false
  end

  after do
    KeystoneColors::ApplicationController.remove_method(:current_user)
  end

  it "renders host navbar links correctly from engine pages" do
    get "/keystone_colors"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('href="/"')
  end
end
