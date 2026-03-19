# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render plain: "Home"
  end
end
