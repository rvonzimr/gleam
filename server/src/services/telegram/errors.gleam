import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/json

pub type ApiError {
  Unhandled(String)
  Timeout
  MalformedResponse
  FailedConnection
  ServiceError(TelegramError)
}

pub type TelegramError {
  Malformed(original: json.DecodeError, error: json.DecodeError)
  Unauthenticated
  NotFound
  Unknown(error_code: Int, description: String)
}

pub fn error_to_string(error: TelegramError) {
  case error {
    Malformed(_, _) -> "Unable to decode response"
    Unauthenticated -> "Unauthenticated"
    NotFound -> "Not found"
    Unknown(error_code, description) ->
      int.to_string(error_code) <> " " <> description
  }
}

pub fn error_decoder() -> decode.Decoder(TelegramError) {
  use error_code <- decode.field("error_code", decode.int)
  use description <- decode.field("description", decode.string)

  let error = case error_code {
    404 -> NotFound
    401 -> Unauthenticated
    _ -> Unknown(error_code:, description:)
  }

  decode.success(error)
}

pub fn print_api_error(api_error: ApiError) {
  let message = case api_error {
    Unhandled(msg) -> "unknown: " <> msg
    Timeout -> "timeout"
    MalformedResponse -> "Malformed Response"
    FailedConnection -> "Failed connection"
    ServiceError(error) -> "Telegram API Error: " <> error_to_string(error)
  }

  io.println_error("Encounted an error\n" <> message)
}
