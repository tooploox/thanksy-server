# frozen_string_literal: true

require "roda"

class App < Roda
  plugin :indifferent_params
  plugin :json
  plugin :json_parser

  route do |r|
    r.on "thanks", method: :post do |data|
      puts r.body.read
    end
  end
end
