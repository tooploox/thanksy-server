# frozen_string_literal: true

class SlackResponse
  def in_channel(creators_user_name, thanks)
    {
      response_type: "in_channel",
      text: "<@#{creators_user_name}> just sent a thanks",
      attachments: [
        {
          text: thanks.text.gsub(/@([\w.]+)/, '<@\1>'),
          fallback: "You are unable to choose a game",
          callback_id: "thanksy_response",
          color: "#e5e5e5",
          attachment_type: "default",
          actions: actions(thanks),
        },
      ],
    }
  end

  def actions(thanks)
    [
      {
        name: "love",
        text: ":heart: #{thanks.love_count}",
        type: "button",
        value: thanks.id,
      },
      {
        name: "confetti",
        text: ":tada: #{thanks.confetti_count}",
        type: "button",
        value: thanks.id,
      },
      {
        name: "clap",
        text: ":clap: #{thanks.clap_count}",
        type: "button",
        value: thanks.id,
      },
      {
        name: "wow",
        text: ":open_mouth: #{thanks.wow_count}",
        type: "button",
        value: thanks.id,
      },
    ]
  end
end
