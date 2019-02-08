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

foo_bar = {
  user: {
    id: "AFN6FJUR4",
    name: "foo.bar",
    real_name: "Foo Bar",
    profile: {
      image_72: "http://test.image.foo",
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
  "@foo.bar" => foo_bar,
  "AFN6FJUR4" => foo_bar,
  "@joe.doe" => joe_doe,
  "AFN6FJUR5" => joe_doe,
}

describe FetchStatistics do
  let(:fake_slack) { Adapters::FakeSlack.new(slack_users) }
  let(:create_thanks_service) { CreateThanks.new(fake_slack) }
  let(:handle_reaction_service) { HandleReaction.new }
  let(:service) { FetchStatistics.new(fake_slack) }
  let(:command_1_text) { "Thanks @joe.doe for food" }
  let(:command_2_text) { "Thanks @joe.doe for tests" }
  let(:command_3_text) { "Thanks @foo.bar for something" }
  let(:command_4_text) { "Thanks @tomek.ryba for review" }
  let(:thanks_request_1) { thanks_request_params("tomek.ryba", command_1_text) }
  let(:thanks_request_2) { thanks_request_params("tomek.ryba", command_2_text) }
  let(:thanks_request_3) { thanks_request_params("tomek.ryba", command_3_text) }
  let(:thanks_request_4) { thanks_request_params("foo.bar", command_4_text) }

  it "should show valid stats" do
    create_thanks_service.perform(build_thanksy_request(thanks_request_1))
    create_thanks_service.perform(build_thanksy_request(thanks_request_2))
    create_thanks_service.perform(build_thanksy_request(thanks_request_3))
    create_thanks_service.perform(build_thanksy_request(thanks_request_4))
    thanks = Thanks.order(created_at: :desc).all

    %w[love clap confetti wow].each do |reaction|
      thanks.each do |t|
        thanks_reaction = thanks_reaction_params(reaction, t.id)
        handle_reaction_service.(thanks_reaction)
      end
    end

    thanks_sent_top_user = SlackUser.order("thanks_sent DESC").limit(3)
    thanks_recived_top_user = SlackUser.order("thanks_recived DESC").limit(3)
    most_reacted_thanks = Thanks.order("popularity DESC").limit(3)

    expected_stats = SlackResponse.new.stats(thanks_sent_top_user, thanks_recived_top_user, most_reacted_thanks)
    request_params = fetch_statistics_params
    service.perform(request_params)

    expect(fake_slack.responses[request_params[:response_url]]).to eq expected_stats
  end

  private

  def build_thanksy_request(request_params)
    ThanksyRequest.new(request_params)
  end
end
