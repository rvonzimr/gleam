//// This module contains the code to run the sql queries defined in
//// `./src/sql`.
//// > 🐿️ This module was generated automatically using v4.4.2 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_grocery_list` query
/// defined in `./src/sql/get_grocery_list.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.4.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetGroceryListRow {
  GetGroceryListRow(id: Int, name: String, quantity: Int, purchased: Bool)
}

/// Runs the `get_grocery_list` query
/// defined in `./src/sql/get_grocery_list.sql`.
///
/// > 🐿️ This function was generated automatically using v4.4.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_grocery_list(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(GetGroceryListRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    use quantity <- decode.field(2, decode.int)
    use purchased <- decode.field(3, decode.bool)
    decode.success(GetGroceryListRow(id:, name:, quantity:, purchased:))
  }

  "SELECT id, name, quantity, purchased
FROM groceries
WHERE list_id = $1;
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `upsert_grocery_item` query
/// defined in `./src/sql/upsert_grocery_item.sql`.
///
/// > 🐿️ This function was generated automatically using v4.4.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn upsert_grocery_item(
  db: pog.Connection,
  arg_1: String,
  arg_2: Int,
  arg_3: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO groceries (name, quantity, list_id)
VALUES ($1, $2, $3)
ON CONFLICT (name, list_id)
DO UPDATE SET
    quantity = groceries.quantity + excluded.quantity;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.parameter(pog.int(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
