import contest_api/router
import gleam/http
import wisp/simulate

pub fn health_check_test() {
  let response =
    simulate.browser_request(http.Get, "/health")
    |> router.handle_request

  assert response.status == 200
  assert response.headers == [#("content-type", "application/json; charset=utf-8")]
  assert simulate.read_body(response) == "{\"status\":\"ok\"}"
}

pub fn not_found_test() {
  let response =
    simulate.browser_request(http.Get, "/missing")
    |> router.handle_request

  assert response.status == 404
}
