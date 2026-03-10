# frozen_string_literal: true

class User < ActiveRecord::Base
  has_one :theme_preference, class_name: "KeystoneColors::ThemePreference", as: :owner
end
