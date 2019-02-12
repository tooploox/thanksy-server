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

  # rubocop:disable Metrics/AbcSize
  def stats(top_senders, top_receivers, most_reacted_thanks)
    {
      "text": "*Top 3 givers:* \n " \
      ":one: <@#{top_senders[0].name}>  | " \
      " Thanks sent: #{top_senders[0].thanks_sent} \n " \
      ":two: <@#{top_senders[1].name}>  | " \
      "Thanks sent: #{top_senders[1].thanks_sent} \n " \
      ":three: <@#{top_senders[2].name}>  | " \
      "Thanks sent: #{top_senders[2].thanks_sent} \n ---------------------------- \n " \
      "*Top 3 receivers:* \n " \
      ":one: <@#{top_receivers[0].name}>  |  " \
      "Thanks received: #{top_receivers[0].thanks_received} \n " \
      ":two: <@#{top_receivers[1].name}>  | " \
      "Thanks received: #{top_receivers[1].thanks_received} \n " \
      ":three: <@#{top_receivers[2].name}>  | " \
      "Thanks received: #{top_receivers[2].thanks_received} \n ---------------------------- \n " \
      "*Top 3 Thanks with the most reactions:* \n " \
      ":one: <@#{most_reacted_thanks[0].giver['name']}>  | " \
      "Reactions: #{most_reacted_thanks[0].popularity} \n `#{most_reacted_thanks[0].text}` \n\n " \
      ":two: <@#{most_reacted_thanks[1].giver['name']}>  | " \
      "Reactions: #{most_reacted_thanks[1].popularity} \n `#{most_reacted_thanks[1].text}` \n\n " \
      ":three: <@#{most_reacted_thanks[2].giver['name']}>  | " \
      "Reactions: #{most_reacted_thanks[2].popularity} \n `#{most_reacted_thanks[2].text}` \n\n",
    }
  end
  # rubocop:enable Metrics/AbcSize

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
