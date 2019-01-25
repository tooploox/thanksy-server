# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    require "pry"
    binding.pry
  end
end
