import app/context.{type Context}
import app/error.{type Error}
import app/routes/groceries/groceries
import gleam/string
import wisp.{type Request, type Response}

fn route(request: Request, ctx: Context) -> Result(Response, Error) {
  case wisp.path_segments(request) {
    [] -> {
      Ok(wisp.html_response("Hi.", 200))
    }
    ["groceries"] -> {
      groceries.handler(request, ctx)
    }
    _ -> {
      Ok(wisp.not_found())
    }
  }
}

pub fn handle_request(request: Request, ctx: Context) -> Response {
  use <- wisp.log_request(request)
  wisp.log_debug("Request ID: " <> ctx.id)

  case route(request, ctx) {
    Ok(resp) -> {
      resp
    }
    Error(error.InvalidParameters(fields)) -> {
      wisp.bad_request("Invalid Parameters: " <> string.join(fields, ", "))
    }
    Error(error.MissingParameters(fields)) -> {
      wisp.bad_request("Missing Parameters: " <> string.join(fields, ", "))
    }
    Error(error.QueryError) -> {
      wisp.internal_server_error()
    }
  }
}
