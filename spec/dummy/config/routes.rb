# frozen_string_literal: true

Rails.application.routes.draw do
  mount KeystoneColors::Engine => "/keystone_colors"
end
