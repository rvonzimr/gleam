import pog

pub type Context {
  Context(id: String, db: pog.Connection)
}
