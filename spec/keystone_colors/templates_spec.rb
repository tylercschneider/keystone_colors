# frozen_string_literal: true

require "spec_helper"

SUPPORTED_ACCENTS = %w[blue emerald cyan indigo violet rose].flat_map { |c| [c, c.to_sym] }.freeze
SUPPORTED_SURFACES = %w[zinc slate gray neutral stone].flat_map { |c| [c, c.to_sym] }.freeze

RSpec.describe KeystoneColors::Templates do
  it "provides exactly 6 preset templates" do
    expect(described_class.names.size).to eq(6)
  end

  it "exposes all template names" do
    expect(described_class.names).to contain_exactly(:default, :ocean, :forest, :twilight, :coral, :arctic)
  end

  described_class.all.each do |name, template|
    context "template: #{name}" do
      it "uses a supported accent" do
        expect(SUPPORTED_ACCENTS).to include(template[:accent])
      end

      it "uses a supported surface" do
        expect(SUPPORTED_SURFACES).to include(template[:surface])
      end

      it "has a label and description" do
        expect(template[:label]).to be_a(String)
        expect(template[:description]).to be_a(String)
      end
    end
  end

  it "returns a template by name" do
    ocean = described_class[:ocean]
    expect(ocean[:accent]).to eq(:blue)
    expect(ocean[:surface]).to eq(:slate)
  end

  it "raises KeyError for unknown template" do
    expect { described_class[:nonexistent] }.to raise_error(KeyError)
  end

  it "default template uses configured default_accent and default_surface" do
    KeystoneColors.configuration.default_accent = "indigo"
    KeystoneColors.configuration.default_surface = "slate"

    default = described_class[:default]
    expect(default[:accent]).to eq("indigo")
    expect(default[:surface]).to eq("slate")
  ensure
    KeystoneColors.reset_configuration!
  end

  it "uses distinct accent/surface combinations" do
    combos = described_class.all.values.map { |t| [t[:accent], t[:surface]] }
    expect(combos.uniq.size).to eq(combos.size)
  end
end
