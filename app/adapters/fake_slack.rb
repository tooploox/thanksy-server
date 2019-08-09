# frozen_string_literal: true

module Adapters
  class FakeSlack
    def initialize(users = {}, groups = {}, reponses = {})
      @users = users
      @groups = groups
      @responses = reponses
    end
    attr_reader :responses

    def users_info(user_name_or_id)
      @users[user_name_or_id]
    end

    def usergroups_list
      @groups
    end

    def send(response_url, response)
      @responses[response_url] = response
    end
  end
end
