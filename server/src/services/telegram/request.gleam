import gleam/dynamic/decode
import gleam/http.{type Method}
import gleam/json
import gleam/option.{type Option}

type ApiRequest(payload, response) {
  ApiRequest(
    payload: payload,
    endpoint: String,
    encoder: fn(payload) -> String,
    decoder: decode.Decoder(response),
    method: Method,
  )
}

pub type AllowedUpdate {
  MessageUpdate
  MyChatMemberUpdate
}

pub type GetUpdatePayload {
  GetUpdatePayload(
    offset: Option(Int),
    limit: Option(Int),
    allowed_updates: List(AllowedUpdate),
  )
}

pub type SendMessagePayload {
  SendMessagePayload(chat_id: Int, text: String)
}

pub fn send_message_request_encoder(payload: SendMessagePayload) -> json.Json {
  json.object([
    #("chat_id", json.int(payload.chat_id)),
    #("text", json.string(payload.text)),
  ])
}

pub fn build_send_message_request(payload: Payload) {
  ApiRequest(
    payload: payload,
    endpoint: "sendMessage",
    encoder: send_message_request_encoder,
    decoder: models,
  )
}
