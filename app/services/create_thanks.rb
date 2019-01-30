# frozen_string_literal: true

class CreateThanks
  class UserDoesNotExist < StandardError
  end

  def initialize(slack_client = Slack::Web::Client.new)
    @slack_client = slack_client
  end

  def call(params)
    thank_recivers = extract_recivers(params)
    creators_user_name = params[:user_name]
    creator = find_user(creators_user_name)
    users = thank_recivers.map do |user_name|
      find_user(user_name)
    end
    thanks = create_thanks(creator, users, params[:text])
    SlackResponse.new.in_channel(creators_user_name, thanks)
  end

  private

  def extract_recivers(params)
    params[:text].scan(/@([\w.]+)/).flatten
  end

  def find_user(user_name)
    find_slack_user_in_db(user_name) || find_user_in_slack(user_name)
  end

  def find_user_in_slack(user_name)
    user = @slack_client.users_info(user: "@#{user_name}")
    create_user(user)
  rescue Slack::Web::Api::Errors::SlackError
    raise UserDoesNotExist, "User #{user_name} does not exist in our organization!"
  end

  def find_slack_user_in_db(user_name)
    SlackUser.where(name: user_name).take
  end

  def create_user(user)
    SlackUser.create(
      id: user[:user][:id],
      name: user[:user][:name],
      real_name: user[:user][:real_name],
      avatar_url: user[:user][:profile][:image_72],
    )
  end

  def create_thanks(creator, users, text)
    Thanks.create(
      giver: creator.as_json,
      receivers: users.as_json,
      text: text,
    )
  end
end
