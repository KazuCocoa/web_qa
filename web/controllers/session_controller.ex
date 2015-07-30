defmodule WebQa.SessionController do
  use WebQa.Web, :controller

  plug :scrub_params, "user" when action in [:create]
  plug :action

  alias WebQa.User

  def create(conn, params = %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    if changeset.valid? do
      user = Repo.insert(changeset)

      conn
      |> put_flash(:info, "Logged in.")
      |> Guardian.Plug.sign_in(user, :password)
      |> redirect(to: user_path(conn, :index))
    else
      redirect(conn, to: "/")
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end

end
