import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}

pub type User {
  User(
    id: Int,
    is_bot: Bool,
    first_name: String,
    last_name: Option(String),
    username: Option(String),
  )
}

pub type ChatType {
  SenderChat
  PrivateChat
  GroupChat
  SupergroupChat
  ChannelChat
  UnknownChat
}

// https://core.telegram.org/bots/api#chat
pub type Chat {
  Chat(
    id: Int,
    chat_type: ChatType,
    title: Option(String),
    username: Option(String),
    first_name: Option(String),
    last_name: Option(String),
    is_forum: Option(Bool),
    is_direct_messages: Option(Bool),
  )
}

pub type MessageOrigin {
  MessageOriginuser(date: Timestamp, sender: User)
  MessageOriginHiddenUser(date: Timestamp, sender: String)
  MessageOriginChat(date: Timestamp, chat: Chat, author_signature: String)
  MessageOriginChannel(
    date: Timestamp,
    chat: Chat,
    message_id: Int,
    author_signature: String,
  )
}

// https://core.telegram.org/bots/api#message
// Lots of Options here, but some can probably
// be removed by splitting on the context of a message.
pub type Message {
  Message(
    id: Int,
    thread_id: Option(Int),
    from: Option(User),
    sender_chat: Option(Chat),
    sender_boost_count: Option(Int),
    sender_business_bot: Option(User),
    date: Timestamp,
    //originally unix time
    business_connection_id: Option(String),
    chat: Chat,
  )
}

// Updates are mutually exclusive:
// https://core.telegram.org/bots/api#getting-updates
pub type ChatMemberUpdated {
  ChatMemberUpdated(chat: Chat, from: User, date: Timestamp)
}

pub type Update {
  MyChatMemberUpdated(update_id: Int, result: ChatMemberUpdated)
  NewMessage(update_id: Int, result: Message)
}
