# frozen_string_literal: true

require "rails_helper"

describe "GET /thanks/list" do
  let(:user) do
    {
      user: {
        id: "AFN6FJUR3",
        name: "tomek.ryba",
        real_name: "Tomek Ryba",
        profile: {
          image_72: "http://test.image.tomek",
        },
      },
    }
  end
  let(:thanks_request) { ThanksyRequest.new(thanks_request_params("tomek.ryba", "Foo")) }
  let(:slack_users) { { "@tomek.ryba" => user } }
  let(:fake_slack) { Adapters::FakeSlack.new(slack_users, {}) }
  let(:service) { CreateThanks.new(fake_slack) }
  let(:route) { "/thanks/list" }
  let(:parsed_body) { JSON.parse!(response.body, symbolize_names: true) }
  let(:auth_token) { "FOO_BAR" }

  before do
    service.perform(thanks_request)

    allow(ENV).to receive(:[]).with("AUTH_TOKEN").and_return(auth_token)
  end

  context "when access token is not configured in env" do
    let(:auth_token) { nil }
    it "responds with an error" do
      get route
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(401)
      expect(parsed_body[:error]).to eq "You have to set the auth token as an environmental variable called AUTH_TOKEN."
    end
  end

  context "with no access token" do
    it "responds with an error" do
      get route
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(401)
      expect(parsed_body[:error]).to eq "You have to provide a valid access token."
    end
  end

  context "with access token" do
    context "with correct access token" do
      it "responds with resources" do
        get route, headers: { "HTTP_AUTHORIZATION" => "Bearer #{auth_token}" }
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(200)
        expect(parsed_body[0][:giver][:id]).to eq user[:user][:id]
        expect(parsed_body[0][:giver][:name]).to eq user[:user][:name]
      end
    end

    context "with invalid access token" do
      it "responds with an error" do
        get route, headers: { "HTTP_AUTHORIZATION" => "Bearer INVALID_TOKEN" }
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(401)
        expect(parsed_body[:error]).to eq "You have to provide a valid access token."
      end
    end
  end
end
