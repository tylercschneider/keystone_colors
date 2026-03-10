# frozen_string_literal: true

module KeystoneColors
  class ApplicationController < ::ApplicationController
    helper KeystoneUiHelper
    helper Rails.application.routes.url_helpers
  end
end
