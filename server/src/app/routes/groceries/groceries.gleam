import app/context.{type Context}
import app/error
import gleam/int
import gleam/json
import gleam/list
import gleam/result
import groceries
import pog
import sql
import wisp.{type Request, type Response}

pub type GroceryRequest {
  GroceryRequest(id: Int)
}

fn get_groceries(
  db: pog.Connection,
  id: Int,
) -> Result(List(groceries.GroceryItem), error.Error) {
  let try_contents =
    result.map_error(sql.get_grocery_list(db, id), error.query_error)
    |> result.map(fn(returned) { returned.rows })

  use grocery_rows <- result.try(try_contents)

  Ok(
    grocery_rows
    |> list.map(fn(row) { groceries.GroceryItem(row.name, row.quantity) }),
  )
}

fn parse_query(
  query: List(#(String, String)),
) -> Result(GroceryRequest, error.Error) {
  let field = "id"

  let parsed_request =
    query
    |> list.key_find(field)
    |> result.replace_error(error.MissingParameters([field]))

  parsed_request
  |> result.try(fn(id) {
    id
    |> int.parse()
    |> result.replace_error(error.InvalidParameters(fields: [field]))
  })
  |> result.map(GroceryRequest)
}

pub fn handler(request: Request, ctx: Context) -> Result(Response, error.Error) {
  use grocery_request <- result.try(parse_query(wisp.get_query(request)))
  use grocery_list <- result.try(get_groceries(ctx.db, grocery_request.id))

  Ok(wisp.json_response(
    grocery_list |> groceries.grocery_list_to_json |> json.to_string(),
    200,
  ))
}
