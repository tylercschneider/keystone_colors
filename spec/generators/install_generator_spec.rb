# frozen_string_literal: true

require_relative "../rails_helper"
require "rails/generators"
require "generators/keystone_colors/install/install_generator"

RSpec.describe KeystoneColors::Generators::InstallGenerator do
  let(:destination) { File.expand_path("../../tmp/generator_test", __dir__) }

  before do
    FileUtils.mkdir_p(destination)
    Rails::Generators.invoke("keystone_colors:install", [], destination_root: destination, quiet: true)
  end

  after do
    FileUtils.rm_rf(destination)
  end

  it "copies the create_theme_preferences migration" do
    migration_files = Dir.glob("#{destination}/db/migrate/*_create_keystone_colors_theme_preferences.rb")

    expect(migration_files.length).to eq(1)
    content = File.read(migration_files.first)
    expect(content).to include("create_table :keystone_colors_theme_preferences")
  end
end
