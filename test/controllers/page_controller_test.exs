defmodule WebQa.PageControllerTest do
  use WebQa.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Web QA Voting"
  end
end
