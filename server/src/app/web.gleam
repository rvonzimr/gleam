import app/context
import app/db
import app/env
import app/router
import gleam/erlang/process
import mist
import pog
import wisp
import wisp/wisp_mist

pub fn start() {
  let assert Ok(env) = env.load()
  let db_pool = process.new_name("pog_pool")

  let assert Ok(_) = db.start_application_supervisor(env, db_pool)

  let db = pog.named_connection(db_pool)
  let ctx = context.Context(id: "1", db: db)

  let router = router.handle_request(_, ctx)

  wisp.configure_logger()

  let assert Ok(_) =
    router
    |> wisp_mist.handler(env.secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start()

  process.sleep_forever()
}
