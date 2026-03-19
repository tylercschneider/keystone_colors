# frozen_string_literal: true

module KeystoneColors
  class ApplicationController < ::ApplicationController
    helper KeystoneUiHelper
    helper KeystoneColors::MainAppRouteHelper

    layout -> { KeystoneColors.configuration.layout }
  end
end
