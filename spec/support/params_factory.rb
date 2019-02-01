# frozen_string_literal: true

module ParamsFactory
  def thanks_request_params(user_name, text)
    {
      token: "token",
      team_id: "TFM9DNNQ1",
      team_domain: "testing",
      channel_id: "CFN3M0YR3",
      channel_name: "general",
      user_id: "UFNUSDWG7",
      user_name: user_name,
      command: "/thanksy",
      text: text,
      response_url: "https://hooks.slack.com/commands/TFM9DNNQ1/536955343442/BqkZE6Qvh2wwUs4dCBi5G0vc",
      trigger_id: "536796077028.531319770817.d6927828e32781ea7cc7b66aff6d8dfc",
      controller: "thanks",
      action: "create",
    }
  end

  def thanks_reaction_params(name, thanks_id)
    {
      "payload" => {
        "actions" => [
          {
            "name" => name,
            "type" => "button",
            "value" => thanks_id,
          },
        ],
        "original_message" => {
          "attachments" => [
            {
              "actions" => [],
            },
          ],
        },
      }.to_json,
    }
  end
end
