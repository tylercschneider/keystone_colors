# frozen_string_literal: true

module KeystoneColors
  module MainAppRouteHelper
    def method_missing(method, *args, &block)
      if method.to_s.end_with?('_path', '_url') && main_app.respond_to?(method)
        main_app.public_send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      (method.to_s.end_with?('_path', '_url') && main_app.respond_to?(method, include_private)) || super
    end
  end
end
