# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneColors::Templates do
  SUPPORTED_ACCENTS = %i[blue emerald cyan indigo violet rose].freeze
  SUPPORTED_SURFACES = %i[zinc slate gray neutral stone].freeze

  it "provides exactly 5 preset templates" do
    expect(described_class.names.size).to eq(5)
  end

  it "exposes all template names" do
    expect(described_class.names).to contain_exactly(:ocean, :forest, :twilight, :coral, :arctic)
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

  it "uses distinct accent/surface combinations" do
    combos = described_class.all.values.map { |t| [t[:accent], t[:surface]] }
    expect(combos.uniq.size).to eq(combos.size)
  end
end
