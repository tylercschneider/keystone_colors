# frozen_string_literal: true

module KeystoneColors
  class Engine < ::Rails::Engine
    isolate_namespace KeystoneColors

    initializer "keystone_colors.url_helpers" do
      ActiveSupport.on_load(:action_controller) do
        helper Rails.application.routes.url_helpers
      end
    end
  end
end
