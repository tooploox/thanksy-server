# frozen_string_literal: true

require "rails_helper"

describe ThanksController, type: :controller do
  it "#index should return empty result if thanks are missing" do
    get :index
    expect(response).to have_http_status(:success)
    expect(parse_body(response)).to match_array([])
  end
end

def parse_body(response)
  JSON.parse(response.body)
end
