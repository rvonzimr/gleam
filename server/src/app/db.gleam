import app/env.{type Environment}
import gleam/erlang/process
import gleam/otp/static_supervisor
import pog

pub fn start_application_supervisor(
  env: Environment,
  pool_name: process.Name(pog.Message),
) {
  let assert Ok(url_config) = pog.url_config(pool_name, env.database_url)

  let pool_child =
    url_config
    |> pog.pool_size(15)
    |> pog.supervised()

  static_supervisor.new(static_supervisor.RestForOne)
  |> static_supervisor.add(pool_child)
  |> static_supervisor.start()
}
