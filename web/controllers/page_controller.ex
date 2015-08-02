defmodule WebQaVote.PageController do
  use WebQaVote.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
