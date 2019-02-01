# frozen_string_literal: true

require "rails_helper"

tomek_ryba = {
  user: {
    id: "AFN6FJUR3",
    name: "tomek.ryba",
    real_name: "Tomek Ryba",
    profile: {
      image_72: "http://test.image.tomek",
    },
  },
}

joe_doe = {
  user: {
    id: "AFN6FJUR5",
    name: "joe.doe",
    real_name: "Joe Doe",
    profile: {
      image_72: "http://test.image.joe",
    },
  },
}

slack_users = {
  "@tomek.ryba" => tomek_ryba,
  "AFN6FJUR3" => tomek_ryba,
  "@joe.doe" => joe_doe,
  "AFN6FJUR5" => joe_doe,
}

describe HandleReaction do
  let(:fake_slack) { Adapters::FakeSlack.new(slack_users) }
  let(:create_thanks_service) { CreateThanks.new(fake_slack) }
  let(:service) { HandleReaction.new }
  let(:command_text) { "Thanks @joe.doe for food" }
  let(:thanks_request) { thanks_request_params("tomek.ryba", command_text) }

  before do
    @time = Time.zone.now
    Timecop.freeze(@time)
  end

  it "should create thanks" do
    create_thanks_service.perform(thanks_request)
    thanks = Thanks.order(created_at: :desc).last

    %w[love clap confetti wow].each do |reaction|
      thanks_reaction = thanks_reaction_params(reaction, thanks.id)
      service.(thanks_reaction)
    end

    thanks.reload

    expect(thanks.love_count).to eq 1
    expect(thanks.confetti_count).to eq 1
    expect(thanks.clap_count).to eq 1
    expect(thanks.wow_count).to eq 1
    expect(thanks.popularity).to eq 4
  end

  it "should create thanks" do
    create_thanks_service.perform(thanks_request)
    thanks = Thanks.order(created_at: :desc).last
    thanks_reaction = thanks_reaction_params("love", thanks.id)
    result = service.(thanks_reaction)
    thanks.reload

    expected_result = {
      "attachments" => [{
        "actions" => SlackResponse.new.actions(thanks),
      }],
    }

    expect(result).to eq expected_result
  end
end
