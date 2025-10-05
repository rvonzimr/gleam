import app/web.{type Context}
import gleam/json
import wisp.{type Request, type Response}

pub fn handle_request(request: Request, ctx: Context) -> Response {
  use <- wisp.log_request(request)
  wisp.log_debug("Request ID: " <> ctx.id)

  json.object([#("status", json.string("chill B)"))])
  |> json.to_string()
  |> wisp.json_response(200)
}
