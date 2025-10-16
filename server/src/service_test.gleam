import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None}
import services/telegram/api
import services/telegram/models
// fn build_service() {
//   api.new("8276771545:AAHQ02AKqfn7lU9d6dpLhTVK3Fv7ikYe1zA")
// }
//
// pub fn main() {
//   let service = build_service()
//   let assert Ok(updates) =
//     service
//     |> api.get_updates(
//       api.GetUpdateRequest(offset: None, limit: None, allowed_updates: [
//         api.MyChatMemberUpdate,
//         api.MessageUpdate,
//       ]),
//     )
//
//   updates
//   |> list.map(fn(update) {
//     case update {
//       models.NewMessage(update_id, _) -> {
//         io.println("New message update! " <> update_id |> int.to_string())
//       }
//       models.MyChatMemberUpdated(update_id, _) -> {
//         io.println("chat member update " <> update_id |> int.to_string())
//       }
//     }
//   })
//
//   let assert Ok(_) =
//     api.send_message(
//       service,
//       api.SendMessageRequest(
//         -4_846_588_190,
//         "This is a test of sending messages.",
//       ),
//     )
// }
