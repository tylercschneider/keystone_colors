# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneColors::Configuration do
  after { KeystoneColors.reset_configuration! }

  it "has sensible defaults" do
    config = KeystoneColors.configuration

    expect(config.owner_class_name).to eq("User")
    expect(config.current_owner_method).to eq(:current_user)
    expect(config.default_template).to eq(:ocean)
    expect(config.default_accent).to eq("blue")
    expect(config.default_surface).to eq("zinc")
    expect(config.layout).to eq("application")
  end
end
