# frozen_string_literal: true

require "test_helper"
require "capybara/minitest"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test
end
