import app/web
import gleam/io
import radiate

pub fn main() {
  io.println("Runnning with code reloading...")
  let _ =
    radiate.new()
    |> radiate.add_dir(".")
    |> radiate.start()

  web.start()
}
