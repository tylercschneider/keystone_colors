# frozen_string_literal: true

module KeystoneColors
  class Engine < ::Rails::Engine
    isolate_namespace KeystoneColors

    # Make host app route helpers available in engine views so shared layouts
    # (navbar, sidebar, etc.) can link back to host app pages.
    initializer "keystone_colors.url_helpers" do
      ActiveSupport.on_load(:action_controller) do
        helper Rails.application.routes.url_helpers
      end
    end

    # Clear SCRIPT_NAME so host app route helpers generate correct paths
    # instead of prefixing them with the engine mount path (e.g. /app_colors/).
    # The engine's own engine_root_path is preserved from the original value.
    initializer "keystone_colors.clear_script_name" do
      config.to_prepare do
        KeystoneColors::ApplicationController.before_action :_keystone_colors_clear_script_name

        KeystoneColors::ApplicationController.class_eval do
          private

          def _keystone_colors_clear_script_name
            @_engine_mount_path = request.env["SCRIPT_NAME"]
            request.env["SCRIPT_NAME"] = ""
          end
        end
      end
    end
  end
end
