# frozen_string_literal: true

require "rack"
require "./app"

run Application.freeze.app
