defmodule WebQa.PageController do
  use WebQa.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
