defmodule WebQaVote.PageControllerTest do
  use WebQaVote.ConnCase

  setup do
    Gettext.put_locale(WebQaVote.Gettext, "en")
    :ok
  end

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Web QA Voting"
  end
end
