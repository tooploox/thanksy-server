# frozen_string_literal: true

require "rails_helper"

describe ThanksyRequest do
  let(:command_text) { "Thanks @joe.doe for food" }
  let(:command_with_slack_variables) { "Thanks <!subteam^SEQ8LFHR7|@Test> for food" }
  let(:too_long_command) do
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo" \
      "ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis" \
      "parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec," \
      "pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec.!!!!!"
  end
  let(:valid_request_params) { thanks_request_params("tomek.ryba", command_text) }
  let(:valid_request_with_slack_val) { thanks_request_params("tomek.ryba", command_with_slack_variables) }
  let(:missing_user_name) { thanks_request_params("", command_text) }
  let(:empty_text) { thanks_request_params("tomek.ryba", "") }
  let(:to_long_text) { thanks_request_params("tomek.ryba", too_long_command) }

  it "should create valid request" do
    request = ThanksyRequest.new(valid_request_params)

    expect(request.valid?).to eq true
    expect(request.thanksy_text).to eq valid_request_params[:text]
    expect(request.user_name).to eq valid_request_params[:user_name]
  end

  it "should filter slack variables from thanksy text" do
    request = ThanksyRequest.new(valid_request_with_slack_val)

    expect(request.valid?).to eq true
    expect(request.thanksy_text).to eq "Thanks @Test for food"
    expect(request.user_name).to eq valid_request_with_slack_val[:user_name]
  end

  it "should fail if user_name is empty" do
    request = ThanksyRequest.new(missing_user_name)

    expect(request.valid?).to eq false
    expect(request.errors.full_messages).to eq ["User name can't be empty. Please contact support"]
  end

  it "should fail if response_url is empty" do
    params = valid_request_params.tap do |p|
      p[:response_url] = ""
    end
    request = ThanksyRequest.new(params)

    expect(request.valid?).to eq false
    expect(request.errors.full_messages).to eq ["Response url can't be empty. Please contact support"]
  end

  it "should fail if thanks_text is empty" do
    request = ThanksyRequest.new(empty_text)

    expect(request.valid?).to eq false
    expect(request.errors.full_messages).to eq ["Thanksy text can't be empty"]
  end

  it "should fail if thanks_text is longer than 300 characters" do
    request = ThanksyRequest.new(to_long_text)

    expect(request.valid?).to eq false
    expect(request.errors.full_messages).to eq ["Thanksy text can't be longer than 300 characters"]
  end
end
