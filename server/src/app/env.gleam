import envoy
import gleam/result

pub type Environment {
  Environment(database_url: String, secret_key_base: String)
}

pub fn load() {
  use database_url <- result.try(envoy.get("DATABASE_URL"))
  use secret_key_base <- result.try(envoy.get("SECRET_KEY_BASE"))
  Ok(Environment(database_url: database_url, secret_key_base: secret_key_base))
}
