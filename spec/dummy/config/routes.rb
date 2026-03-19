# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"
  mount KeystoneColors::Engine => "/keystone_colors"
end
