import gleam/http.{Https, Post}
import gleam/http/request
import gleam/httpc
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import services/telegram/decoders
import services/telegram/errors
import services/telegram/models

const api_host = "api.telegram.org"

pub type Service {
  Service(token: String, url: String)
}

pub fn new(token: String) {
  Service(token: token, url: api_host)
}

fn build_base_request(service: Service, endpoint: String) {
  let path =
    ["bot" <> service.token, endpoint]
    |> string.join("/")

  request.new()
  |> request.set_scheme(Https)
  |> request.set_host(api_host)
  |> request.set_path(path)
}

fn build_get_request(
  service: Service,
  endpoint: String,
) -> request.Request(String) {
  build_base_request(service, endpoint)
  |> request.set_method(http.Get)
}

fn build_post_request(service: Service, endpoint: String, body: String) {
  build_base_request(service, endpoint)
  |> request.set_method(Post)
  |> request.set_header("content-type", "application/json")
  |> request.set_body(body)
}

pub fn send(request: request.Request(String)) -> Result(String, errors.ApiError) {
  request
  |> httpc.send()
  |> result.map(fn(resp) { resp.body })
  |> result.map_error(handle_httpc_error)
}

fn decode_response(
  raw_body: String,
  decoder: fn(String) -> Result(a, errors.TelegramError),
) -> Result(a, errors.ApiError) {
  let decoded =
    raw_body
    |> decoder
    |> result.map_error(handle_decode_error)

  case decoded {
    Ok(decoded) -> Ok(decoded)
    Error(error) -> {
      errors.print_api_error(error)
      Error(error)
    }
  }
}

fn handle_decode_error(telegram_error: errors.TelegramError) -> errors.ApiError {
  errors.ServiceError(telegram_error)
}

fn handle_httpc_error(error: httpc.HttpError) -> errors.ApiError {
  case error {
    httpc.InvalidUtf8Response -> errors.MalformedResponse
    httpc.FailedToConnect(_, _) -> errors.FailedConnection
    httpc.ResponseTimeout -> errors.Timeout
  }
}
//  Telegram API methods

// pub fn get_me(service: Service) -> Result(models.User, errors.ApiError) {
//   build_get_request(service, "getMe")
//   |> send()
//   |> result.try(decode_response(_, decoders.decode_user))
// }
//
// pub fn log_out(service: Service) -> Result(Nil, errors.ApiError) {
//   build_get_request(service, "/logout")
//   |> send()
//   |> result.replace(Nil)
// }

// pub fn send_message(
//   service: Service,
//   payload: apiRequest.SendMessageRequest,
// ) -> Result(models.Message, errors.ApiError) {
//   let body =
//     option.Some(
//       json.object([
//         #("chat_id", json.int(payload.chat_id)),
//         #("text", json.string(payload.text)),
//       ])
//       |> json.to_string,
//     )
//   send_request(service, SendMessage, body)
//   |> result.try(decode_response(_, decoders.decode_message))
// }
//
// pub fn get_updates(
//   service: Service,
//   payload: GetUpdateRequest,
// ) -> Result(List(models.Update), errors.ApiError) {
//
//   send_request(service, GetUpdates, body)
//   |> result.try(decode_response(_, decoders.decode_update))
// }
