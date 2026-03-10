# frozen_string_literal: true

module KeystoneColors
  module MainAppRoutesHelper
    def method_missing(method, *args, **kwargs, &block)
      if main_app.respond_to?(method)
        main_app.send(method, *args, **kwargs, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      main_app.respond_to?(method, include_private) || super
    end
  end
end
