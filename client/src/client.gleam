import gleam/http/response.{type Response}
import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/result
import groceries.{type GroceryItem}
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import rsvp

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", [])

  Nil
}

type Model {
  Model(
    items: List(GroceryItem),
    new_item: String,
    saving: Bool,
    error: Option(String),
  )
}

type Msg {
  ServerSavedList(Result(Response(String), rsvp.Error))
  UserAddedItem
  UserTypedNewItem(String)
  UserSavedList
  UserUpdatedQuantity(index: Int, quantity: Int)
}

fn init(items: List(GroceryItem)) -> #(Model, Effect(Msg)) {
  let model =
    Model(items: items, new_item: "", saving: False, error: option.None)
  #(model, effect.none())
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    ServerSavedList(Ok(_)) -> #(
      Model(..model, saving: False, error: option.None),
      effect.none(),
    )
    ServerSavedList(Error(_)) -> #(
      Model(..model, saving: False, error: option.Some("Failed to save")),
      effect.none(),
    )

    UserAddedItem -> {
      case model.new_item {
        "" -> #(model, effect.none())
        name -> {
          let item = groceries.GroceryItem(name: name, quantity: 1)
          let updated_items = list.append(model.items, [item])

          #(Model(..model, items: updated_items, new_item: ""), effect.none())
        }
      }
    }
    UserTypedNewItem(text) -> #(Model(..model, new_item: text), effect.none())
    UserSavedList -> #(Model(..model, saving: True), save_list(model.items))
    UserUpdatedQuantity(index:, quantity:) -> {
      let updated_items =
        list.index_map(model.items, fn(item, item_index) {
          case item_index == index {
            True -> groceries.GroceryItem(..item, quantity:)
            False -> item
          }
        })

      #(Model(..model, items: updated_items), effect.none())
    }
  }
}

fn save_list(items: List(GroceryItem)) -> Effect(Msg) {
  rsvp.post(
    "/api/groceries",
    groceries.grocery_list_to_json(items),
    rsvp.expect_ok_response(ServerSavedList),
  )
}

fn view(model: Model) -> Element(Msg) {
  html.div([attribute.class("bg-gray-100 p-4 h-1 bg-red-50")], [
    html.h1([], [html.text("Grocery List")]),
    view_grocery_list(model.items),
    view_new_item(model.new_item),
    html.button(
      [event.on_click(UserSavedList), attribute.disabled(model.saving)],
      [
        html.text(case model.saving {
          True -> "Saving..."
          False -> "Save List"
        }),
      ],
    ),
    case model.error {
      option.None -> element.none()
      option.Some(_) -> html.div([], [html.text("Oopise.")])
    },
  ])
}

fn view_new_item(new_item: String) -> Element(Msg) {
  html.div([], [
    html.input([
      attribute.placeholder("Enter item name"),
      attribute.value(new_item),
      event.on_input(UserTypedNewItem),
    ]),
    html.button([event.on_click(UserAddedItem)], [html.text("Add")]),
  ])
}

fn view_grocery_list(items: List(GroceryItem)) -> Element(Msg) {
  case items {
    [] -> html.p([], [html.text("No groceries")])
    _ -> {
      html.ul(
        [],
        list.index_map(items, fn(item, index) {
          html.li([], [view_grocery_item(item, index)])
        }),
      )
    }
  }
}

fn view_grocery_item(item: GroceryItem, index: Int) -> Element(Msg) {
  html.div([attribute.class("flex gap-4")], [
    html.span([attribute.class("flex")], [
      html.input([
        attribute.type_("number"),
        attribute.value(int.to_string(item.quantity)),
        attribute.min("0"),
        event.on_input(fn(value) {
          result.unwrap(int.parse(value), 0)
          |> UserUpdatedQuantity(index, quantity: _)
        }),
      ]),
      html.text(item.name),
    ]),
  ])
}
