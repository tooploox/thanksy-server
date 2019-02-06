# frozen_string_literal: true

require "rails_helper"

describe Adapters::Slack do
  let(:slack_client) { double("Slack::Web::Client") }
  let(:adapter) { Adapters::Slack.new(slack_client) }
  let(:user_name) { "user_name" }

  before { allow_any_instance_of(Adapters::Slack).to receive(:sleep) }

  it "#users_info should successfully return user if exist" do
    expected_user = {
      id: "test-id",
    }
    expect(slack_client)
      .to receive(:users_info)
      .with(user: user_name)
      .and_return(expected_user)

    expect(adapter.users_info(user_name)).to eq expected_user
  end

  it "#users_info should retry call if slack API raise TooManyRequestsError" do
    api_response = double("response")
    headers = {
      "retry-after" => 1,
    }
    expect(api_response)
      .to receive(:headers)
      .and_return(headers)
      .exactly(5).times
    expect(slack_client)
      .to receive(:users_info)
      .with(user: user_name)
      .and_raise(Slack::Web::Api::Errors::TooManyRequestsError.new(api_response))
      .exactly(5).times

    expect(adapter.users_info(user_name)).to eq nil
  end

  it "#users_info should return nil if if slack API raise Slack::Web::Api::Errors::SlackError" do
    expect(slack_client)
      .to receive(:users_info)
      .with(user: user_name)
      .and_raise(Slack::Web::Api::Errors::SlackError, "some message")
      .exactly(1).times

    expect(adapter.users_info(user_name)).to eq nil
  end

  it "#usergroups_list should successfully return user groups if exist" do
    expected_group = [{
      id: "test-id",
    }]
    expect(slack_client)
      .to receive(:usergroups_list)
      .with(include_users: true)
      .and_return(expected_group)

    expect(adapter.usergroups_list).to eq expected_group
  end

  it "#usergroups_list should return nil if if slack API raise Slack::Web::Api::Errors::SlackError" do
    expected_group = [{
      id: "test-id",
    }]
    expect(slack_client)
      .to receive(:usergroups_list)
      .with(include_users: true)
      .and_raise(Slack::Web::Api::Errors::SlackError, "some message")

    expect(adapter.usergroups_list).to eq nil
  end
end
