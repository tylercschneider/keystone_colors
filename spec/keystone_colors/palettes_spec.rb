# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneColors::Palettes do
  it "returns hex shades for a known accent color" do
    shades = described_class.accent(:blue)

    expect(shades[500]).to eq("#3b82f6")
    expect(shades[600]).to eq("#2563eb")
  end

  it "returns hex shades for a known surface color" do
    shades = described_class.surface(:zinc)

    expect(shades[500]).to eq("#71717a")
    expect(shades[700]).to eq("#3f3f46")
  end

  it "raises for unknown accent" do
    expect { described_class.accent(:nope) }.to raise_error(KeyError)
  end

  it "raises for unknown surface" do
    expect { described_class.surface(:nope) }.to raise_error(KeyError)
  end
end
