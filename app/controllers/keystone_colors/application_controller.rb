# frozen_string_literal: true

module KeystoneColors
  class ApplicationController < ::ApplicationController
    before_action { send(KeystoneColors.configuration.authentication_method) }
    helper KeystoneUiHelper

    layout -> { KeystoneColors.configuration.layout }
  end
end
