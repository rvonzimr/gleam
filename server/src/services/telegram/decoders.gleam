import gleam/dynamic/decode
import gleam/option.{type Option, None, Some}
import gleam/time/timestamp
import services/telegram/models

pub fn user_decoder() -> decode.Decoder(models.User) {
  use id <- decode.field("id", decode.int)
  use first_name <- decode.field("first_name", decode.string)
  use last_name <- maybe_absent_or_none("last_name", decode.string)
  use username <- maybe_absent_or_none("username", decode.string)
  use is_bot <- decode.field("is_bot", decode.bool)
  decode.success(models.User(id:, first_name:, last_name:, username:, is_bot:))
}

fn maybe_absent_or_none(
  field: String,
  decoder: decode.Decoder(b),
  next: fn(Option(b)) -> decode.Decoder(a),
) -> decode.Decoder(a) {
  decode.optional_field(field, None, decoder |> decode.map(Some), next)
}

fn chat_type_decoder() -> decode.Decoder(models.ChatType) {
  decode.string
  |> decode.map(fn(raw_type) {
    case raw_type {
      "sender" -> models.SenderChat
      "private" -> models.PrivateChat
      "group" -> models.GroupChat
      "supergroup" -> models.SupergroupChat
      "channel" -> models.ChannelChat
      _ -> models.UnknownChat
    }
  })
}

pub fn chat_decoder() -> decode.Decoder(models.Chat) {
  use id <- decode.field("id", decode.int)
  use chat_type <- decode.field("type", chat_type_decoder())
  use title <- maybe_absent_or_none("title", decode.string)
  use username <- maybe_absent_or_none("username", decode.string)
  use first_name <- maybe_absent_or_none("first_name", decode.string)
  use last_name <- maybe_absent_or_none("last_name", decode.string)
  use is_forum <- maybe_absent_or_none("is_forum", decode.bool)
  use is_direct_messages <- maybe_absent_or_none(
    "is_direct_messages",
    decode.bool,
  )

  decode.success(models.Chat(
    id:,
    chat_type:,
    title:,
    username:,
    first_name:,
    last_name:,
    is_forum:,
    is_direct_messages:,
  ))
}

pub fn chat_member_updated_decoder() -> decode.Decoder(models.ChatMemberUpdated) {
  use chat <- decode.field("chat", chat_decoder())
  use from <- decode.field("from", user_decoder())
  use date <- decode.field(
    "date",
    decode.int |> decode.map(timestamp.from_unix_seconds),
  )

  decode.success(models.ChatMemberUpdated(chat:, from:, date:))
}

pub fn update_decoder() -> decode.Decoder(List(models.Update)) {
  {
    use update_id <- decode.field("update_id", decode.int)

    decode.one_of(
      decode.at(
        ["my_chat_member"],
        chat_member_updated_decoder()
          |> decode.map(models.MyChatMemberUpdated(update_id:, result: _)),
      ),
      or: [
        decode.at(
          ["message"],
          message_decoder()
            |> decode.map(models.NewMessage(update_id:, result: _)),
        ),
      ],
    )
  }
  |> decode.list()
}

pub fn message_decoder() -> decode.Decoder(models.Message) {
  use id <- decode.field("message_id", decode.int)
  use thread_id <- maybe_absent_or_none("message_thread_id", decode.int)
  use from <- maybe_absent_or_none("from", user_decoder())
  use sender_chat <- maybe_absent_or_none("sender_chat", chat_decoder())
  use sender_boost_count <- maybe_absent_or_none(
    "sender_boost_count",
    decode.int,
  )
  use sender_business_bot <- maybe_absent_or_none(
    "sender_business_bot",
    user_decoder(),
  )
  use date <- decode.field(
    "date",
    decode.int |> decode.map(timestamp.from_unix_seconds),
  )
  use business_connection_id <- maybe_absent_or_none(
    "business_connection_id",
    decode.string,
  )
  use chat <- decode.field("chat", chat_decoder())

  decode.success(models.Message(
    id:,
    thread_id:,
    from:,
    sender_chat:,
    sender_boost_count:,
    sender_business_bot:,
    date:,
    business_connection_id:,
    chat:,
  ))
}
