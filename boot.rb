# frozen_string_literal: true

require "logger"

env = ENV["RACK_ENV"] || "development"
is_dev = env == "development"

require "dotenv/load" if is_dev
