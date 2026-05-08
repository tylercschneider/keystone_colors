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

  it "includes shade 950 for accent palettes" do
    shades = described_class.accent(:blue)

    expect(shades[950]).to be_a(String)
    expect(shades[950]).to match(/\A#[0-9a-f]{6}\z/)
  end

  describe ".generate_shades" do
    it "generates 11 shades including 950 from a hex color" do
      shades = described_class.generate_shades("#3b82f6")

      expect(shades.keys).to eq([ 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 ])
      expect(shades[500]).to eq("#3b82f6")
      shades.each_value { |hex| expect(hex).to match(/\A#[0-9a-f]{6}\z/) }
    end
  end
end
