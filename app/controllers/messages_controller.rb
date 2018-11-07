class MessagesController < ApplicationController

  def get_all_messages
    channel = 'CDXMRPKPX' || params['channel']
    req = RestClient.get("#{SLACK_API_URL}channels.history?token=#{SLACK_TOKEN}&channel=#{channel}")
    json = JSON.parse(req)
    messages = json['messages']
    messages.each do |msg|
      user = User.find_by(slack_id: msg['user'])
      if user
        message_info = message_obj(msg, user)
        create_message(message_info)
      else
        user_info = get_user_info(SLACK_TOKEN, msg['user'])
        new_user = create_user(msg['user'], user_info)
        message_info = message_obj(msg, new_user)
        create_message(message_info)
      end
    end
    render json: Message.all()
  end

  def create_message(message_info)
    message = Message.find_by(client_msg_id: message_info['client_msg_id'])
    if (message && (message.text != message_info['text']))
      new_edit_history = EditHistory.create({text: message.text, message_id: message.id})
      message.update(message_info)
    elsif !message
      Message.create(message_info)
    end
  end

  def create_user(slack_id, user_info)
    new_user = User.create({slack_id: slack_id, user_name: user_info['name'], real_name: user_info['real_name'], team_id: user_info['team_id'], tz: user_info['tz'], tz_label: user_info['tz_label'], tz_offset: user_info['tz_offset']})
    new_user
  end

  def get_user_info(token, slack_id)
    req = RestClient.get("https://slack.com/api/users.info?token=#{token}&user=#{slack_id}")
    json = JSON.parse(req)
    return json['user']
  end

  def message_obj(message_json, user_obj)
    new_obj = {}
    new_obj["user_slack_id"] = message_json["user"]
    new_obj["text"] = message_json["text"]
    new_obj["client_msg_id"] = message_json["client_msg_id"]
    new_obj["ts"] = message_json["ts"]
    new_obj['user_id'] = user_obj.id
    new_obj['user_name'] = user_obj.user_name
    new_obj['thread_ts'] = message_json['thread_ts']
    new_obj['slack_parent_user_id'] = message_json['parent_user_id']
    return new_obj
  end


end

# ----- what messages json looks like ------
# {
#   "ok"=>true,
#   "messages"=>[
#     {"type"=>"message", "user"=>"UDXAUJ9FE", "text"=>"what does this come up as", "client_msg_id"=>"a2baf039-7238-4442-9cb8-8a6dc17caf2f", "thread_ts"=>"1541561007.000600", "parent_user_id"=>"UDXAUJ9FE", "ts"=>"1541614047.000100"},
#     {"type"=>"message", "user"=>"UDXAUJ9FE", "text"=>"whats up", "client_msg_id"=>"ef73ae44-14af-43c9-a8e9-207514c1f1ab", "ts"=>"1541608657.000400"},
#     {"type"=>"message", "user"=>"UDXAUJ9FE", "text"=>"hey hey", "client_msg_id"=>"beafdfdb-64e1-4a93-97a4-c8cf7b4ebce6", "ts"=>"1541607799.000200"},
#     {"type"=>"message", "user"=>"UDXAUJ9FE", "text"=>"WERK", "client_msg_id"=>"bcfd6193-1cce-4c5d-b32a-eddd9da9142d", "edited"=>{"user"=>"UDXAUJ9FE", "ts"=>"1541612565.000000"}, "thread_ts"=>"1541561007.000600", "reply_count"=>1, "replies"=>[{"user"=>"UDXAUJ9FE", "ts"=>"1541614047.000100"}], "subscribed"=>true, "last_read"=>"1541614047.000100", "unread_count"=>0, "ts"=>"1541561007.000600"},
#     {"type"=>"message", "user"=>"UDXAUJ9FE", "text"=>"hello", "client_msg_id"=>"3eed3b46-fc10-4457-9191-64c7deb866aa", "ts"=>"1541561003.000400"},
#     {"user"=>"UDXAUJ9FE", "text"=>"<@UDXAUJ9FE> has joined the channel", "type"=>"message", "subtype"=>"channel_join", "ts"=>"1541560977.000200"}
#   ],
#   "has_more"=>false
# }



# -------- SCOPE NEEDED --------
# CONVERSATIONS	---------
# --- channels:history --- Access user’s public channels
# --- channels:read --- Access information about user’s public channels
# --- chat:write:bot --- Send messages as bot-bot
# USERS	-----------------
# --- users:read ---Access your workspace’s profile information
# --- users.profile:read --- Access user’s profile and workspace profile fields

# example response from channels.history
# {"ok"=>true,
#  "messages"=>
#   [{"type"=>"message",
#     "user"=>"UDXAUJ9FE",
#     "text"=>"hellooololo",
#     "client_msg_id"=>"bcfd6193-1cce-4c5d-b32a-eddd9da9142d",
#     "ts"=>"1541561007.000600"},
#    {"type"=>"message",
#     "user"=>"UDXAUJ9FE",
#     "text"=>"hello",
#     "client_msg_id"=>"3eed3b46-fc10-4457-9191-64c7deb866aa",
#     "ts"=>"1541561003.000400"},
#    {"user"=>"UDXAUJ9FE",
#     "text"=>"<@UDXAUJ9FE> has joined the channel",
#     "type"=>"message",
#     "subtype"=>"channel_join",
#     "ts"=>"1541560977.000200"}],
#  "has_more"=>false}

# example response from users.info
# {
# "ok"=>true,
# "user"=>
#  {"id"=>"UDXAUJ9FE",
#   "team_id"=>"TDXCW6XA7",
#   "name"=>"terrancekoar",
#   "deleted"=>false,
#   "color"=>"9f69e7",
#   "real_name"=>"terrance",
#   "tz"=>"America/New_York",
#   "tz_label"=>"Eastern Standard Time",
#   "tz_offset"=>-18000,
#   "profile"=>
#    {"title"=>"",
#     "phone"=>"",
#     "skype"=>"",
#     "real_name"=>"terrance",
#     "real_name_normalized"=>"terrance",
#     "display_name"=>"",
#     "display_name_normalized"=>"",
#     "status_text"=>"",
#     "status_emoji"=>"",
#     "status_expiration"=>0,
#     "avatar_hash"=>"g16f6dd1ab69",
#     "image_24"=>
#      "https://secure.gravatar.com/avatar/16f6dd1ab69db7d11b8cac6913c4c08b.jpg?s=24&d=https%3A%2F%2Fa.slack-edge.com%2F66f9%2Fimg%2Favatars%2Fava_0011-24.png",
#     "image_32"=>
#      "https://secure.gravatar.com/avatar/16f6dd1ab69db7d11b8cac6913c4c08b.jpg?s=32&d=https%3A%2F%2Fa.slack-edge.com%2F66f9%2Fimg%2Favatars%2Fava_0011-32.png",
#     "image_48"=>
#      "https://secure.gravatar.com/avatar/16f6dd1ab69db7d11b8cac6913c4c08b.jpg?s=48&d=https%3A%2F%2Fa.slack-edge.com%2F66f9%2Fimg%2Favatars%2Fava_0011-48.png",
#     "image_72"=>
#      "https://secure.gravatar.com/avatar/16f6dd1ab69db7d11b8cac6913c4c08b.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2F3654%2Fimg%2Favatars%2Fava_0011-72.png",
#     "image_192"=>
#      "https://secure.gravatar.com/avatar/16f6dd1ab69db7d11b8cac6913c4c08b.jpg?s=192&d=https%3A%2F%2Fa.slack-edge.com%2F7fa9%2Fimg%2Favatars%2Fava_0011-192.png",
#     "image_512"=>
#      "https://secure.gravatar.com/avatar/16f6dd1ab69db7d11b8cac6913c4c08b.jpg?s=512&d=https%3A%2F%2Fa.slack-edge.com%2F7fa9%2Fimg%2Favatars%2Fava_0011-512.png",
#     "status_text_canonical"=>"",
#     "team"=>"TDXCW6XA7"},
#   "is_admin"=>true,
#   "is_owner"=>true,
#   "is_primary_owner"=>true,
#   "is_restricted"=>false,
#   "is_ultra_restricted"=>false,
#   "is_bot"=>false,
#   "is_app_user"=>false,
#   "updated"=>1541560977,
#   "has_2fa"=>false}
# }
