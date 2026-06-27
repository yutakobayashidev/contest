import gleam/http.{Get}
import gleam/json
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["health"] -> health(req)
    _ -> wisp.not_found()
  }
}

fn health(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  json.object([#("status", json.string("ok"))])
  |> json.to_string
  |> wisp.json_response(200)
}
