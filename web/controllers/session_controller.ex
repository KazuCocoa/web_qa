defmodule WebQa.SessionController do
  use WebQa.Web, :controller

  alias WebQa.User

  plug :scrub_params, "user" when action in [:create]
  plug :action

  def create(conn, %{"user" => user_params}) do

    user = Repo.get_by!(User, name: user_params)

    if user do
      conn
      |> put_flash(:info, "Logged in.")
      |> Guardian.Plug.sign_in(user.name, :token)
    else
      redirect(conn, to: "/")
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end

  def show(conn, _params) do
    token = Guardian.Plug.current_token(conn)

    put_flash(conn, :info, "Token is #{token}")
    |> redirect(to: "/")
  end

end
