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

  describe ".generate_shades" do
    it "generates 10 shades from a hex color with 500 as the base" do
      shades = described_class.generate_shades("#3b82f6")

      expect(shades.keys).to eq([50, 100, 200, 300, 400, 500, 600, 700, 800, 900])
      expect(shades[500]).to eq("#3b82f6")
      shades.each_value { |hex| expect(hex).to match(/\A#[0-9a-f]{6}\z/) }
    end
  end
end
