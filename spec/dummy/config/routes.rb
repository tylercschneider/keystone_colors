# frozen_string_literal: true

Rails.application.routes.draw do
  get "settings", to: "settings#index"
  mount KeystoneColors::Engine => "/keystone_colors"
end
