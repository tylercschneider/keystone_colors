# frozen_string_literal: true

module KeystoneColors
  class ApplicationController < ::ApplicationController
    helper KeystoneUiHelper

    layout -> { KeystoneColors.configuration.layout }
  end
end
