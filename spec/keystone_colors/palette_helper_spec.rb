# frozen_string_literal: true

require "spec_helper"
require "action_view"
require_relative "../../app/helpers/keystone_colors/palette_helper"

RSpec.describe KeystoneColors::PaletteHelper do
  let(:helper) do
    Class.new {
      include ActionView::Helpers::TagHelper
      include KeystoneColors::PaletteHelper

      attr_accessor :keystone_palette_css, :output_buffer
    }.new
  end

  it "returns a style tag with CSS variables using content_tag" do
    helper.keystone_palette_css = ":root {\n  --color-accent-500: #3b82f6;\n}"

    result = helper.keystone_palette_style_tag
    expect(result).to include("<style>")
    expect(result).to include("--color-accent-500: #3b82f6")
    expect(result).to include("</style>")
    expect(result).to be_html_safe
  end

  it "returns nil when no palette is set" do
    helper.keystone_palette_css = nil

    expect(helper.keystone_palette_style_tag).to be_nil
  end
end
