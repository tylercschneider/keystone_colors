# frozen_string_literal: true

require "spec_helper"
require "action_view"
require_relative "../../app/helpers/keystone_colors/palette_helper"

RSpec.describe KeystoneColors::PaletteHelper do
  let(:helper) { Class.new { include KeystoneColors::PaletteHelper }.new }

  it "returns a style tag with CSS variables" do
    allow(helper).to receive(:keystone_palette_css).and_return(":root {\n  --color-accent-500: #3b82f6;\n}")

    result = helper.keystone_palette_style_tag
    expect(result).to include("<style>")
    expect(result).to include("--color-accent-500: #3b82f6")
    expect(result).to include("</style>")
  end

  it "returns nil when no palette is set" do
    allow(helper).to receive(:keystone_palette_css).and_return(nil)

    expect(helper.keystone_palette_style_tag).to be_nil
  end
end
