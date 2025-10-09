import gleam/int
import gleam/list
import gleam/string
import pog

pub type Error {
  InvalidParameters(fields: List(String))
  MissingParameters(fields: List(String))
  QueryError(reason: String)
}

pub fn query_error(pog_error: pog.QueryError) -> Error {
  case pog_error {
    pog.ConstraintViolated(message, _, _) -> {
      QueryError(reason: message)
    }
    pog.PostgresqlError(_, _, message) -> {
      QueryError(reason: message)
    }
    pog.UnexpectedResultType(err) -> {
      let reason =
        err
        |> list.map(fn(e) { e.expected })
        |> string.join(", ")
      QueryError(reason: reason)
    }
    pog.UnexpectedArgumentType(expected, got) -> {
      QueryError(reason: "expected: " <> expected <> " got: " <> got)
    }

    pog.UnexpectedArgumentCount(expected, got) -> {
      QueryError(
        reason: "expected: "
        <> int.to_string(expected)
        <> " got: "
        <> int.to_string(got),
      )
    }
    pog.QueryTimeout -> {
      QueryError(reason: "Query timed out")
    }
    pog.ConnectionUnavailable -> {
      QueryError(reason: "Connection unavailable")
    }
  }
}
