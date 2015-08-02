defmodule WebQaVote.PageControllerTest do
  use WebQaVote.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Web QA Voting"
  end
end
