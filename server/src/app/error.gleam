pub type Error {
  InvalidParameters(fields: List(String))
  MissingParameters(fields: List(String))
  QueryError
}
