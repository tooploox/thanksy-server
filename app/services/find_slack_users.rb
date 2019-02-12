# frozen_string_literal: true

class FindSlackUsers
  class SlackUserNotFound < StandardError; end

  class SearchResult
    attr_reader :cached_users, :unknown_users

    def initialize
      @cached_users = []
      @unknown_users = []
    end

    def add_cached_user(slack_user)
      @cached_users << slack_user
    end

    def add_unknown_user(slack_user)
      @unknown_users << slack_user
    end

    def merge!(finding_result)
      @cached_users += finding_result.cached_users
      @unknown_users += finding_result.unknown_users
    end
  end

  def initialize(slack_client)
    @slack_client = slack_client
  end

  def call(user_names_or_ids)
    result = find_slack_users(user_names_or_ids, find_groups: true)
    result.cached_users.each { |user| refresh_slack_user_async(user) }
    result.cached_users + fetch_users_from_slack(result.unknown_users)
  end

  private

  def find_slack_users(slack_users, find_groups: false)
    slack_users.each_with_object(SearchResult.new) do |slack_user_name, result|
      if (slack_user = find_slack_user_in_db(slack_user_name))
        result.add_cached_user(slack_user)
      elsif find_groups && (group = find_group_on_slack(slack_user_name))
        result.merge!(find_slack_users(group))
      else
        result.add_unknown_user(slack_user_name)
      end
    end
  end

  def fetch_users_from_slack(slack_users)
    fetch_slack_users_concurrently(slack_users).map do |slack_user_data|
      map_slack_user_data_to_new_user_record(slack_user_data)
    end
  end

  def fetch_slack_users_concurrently(slack_users)
    slack_users
      .map { |slack_user| Thread.new { { name: slack_user, data: find_user_on_slack(slack_user) } } }
      .map(&:value)
      .map { |slack_user| slack_user[:data] || raise_exception(slack_user[:name]) }
  end

  def find_user_on_slack(user_name_or_id)
    fetch_slack_user_data(user_name_or_id) || fetch_slack_user_data("@#{user_name_or_id}")
  end

  def fetch_slack_user_data(user_name)
    @slack_client.users_info(user_name)
  end

  def find_group_on_slack(name)
    usergroups = @slack_client.usergroups_list&.dig(:usergroups)
    group = usergroups.find { |usergroup| usergroup[:handle] == name } if usergroups
    group&.dig(:users)
  end

  def find_slack_user_in_db(user_name)
    SlackUser.where(id: user_name).or(SlackUser.where(name: user_name)).first
  end

  def raise_exception(name)
    raise SlackUserNotFound, "User or group #{name} doesn't exist"
  end

  def map_slack_user_data_to_new_user_record(user)
    SlackUser.new(
      id: user[:user][:id],
      name: user[:user][:name],
      real_name: user[:user][:real_name],
      avatar_url: user[:user][:profile][:image_72],
    )
  end

  def refresh_slack_user_async(user)
    RefreshSlackUser.perform_async(@slack_client, user)
  end
end
