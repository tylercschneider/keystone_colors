# frozen_string_literal: true

require_relative "../rails_helper"
require "rails/generators"
require "generators/keystone_colors/update/update_generator"

RSpec.describe KeystoneColors::Generators::UpdateGenerator do
  let(:destination) { File.expand_path("../../tmp/generator_test", __dir__) }

  before do
    FileUtils.mkdir_p(destination)
  end

  after do
    FileUtils.rm_rf(destination)
  end

  it "copies the Stimulus controller" do
    Rails::Generators.invoke("keystone_colors:update", [], destination_root: destination, quiet: true)

    js_path = "#{destination}/app/javascript/controllers/keystone_colors/theme_settings_controller.js"
    expect(File.exist?(js_path)).to be true
    expect(File.read(js_path)).to include("@hotwired/stimulus")
  end
end
