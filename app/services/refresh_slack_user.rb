# frozen_string_literal: true

class RefreshSlackUser
  include SuckerPunch::Job

  def perform(slack_client, user)
    slack_user_data = slack_client.users_info(user.id)
    user.update(
      name: slack_user_data[:user][:name],
      real_name: slack_user_data[:user][:real_name],
      avatar_url: slack_user_data[:user][:profile][:image_72],
    )
  end
end
