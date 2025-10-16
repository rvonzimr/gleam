import gleam/result
import gleeunit

import services/telegram/decoders
import services/telegram/models
import simplifile

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn get_updates_decoder_test() {
  let assert Ok(to_decode) =
    simplifile.read(from: "./test/support/get_updates_resp.json")
  // let decoded = decoders.decode_update(to_decode)
  // assert result.is_ok(decoded)
}
