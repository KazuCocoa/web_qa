defmodule WebQa.PageController do
  use WebQa.Web, :controller

  # plug Guardian.Plug.EnsureSession, %{ on_failure: { WebQa.SessionController, :create } } when not action in [:new, :create]

  def index(conn, _params) do
    render conn, "index.html"
  end
end
