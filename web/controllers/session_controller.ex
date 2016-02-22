defmodule WebQaVote.SessionController do
  @moduledoc false

  use WebQaVote.Web, :controller

  alias WebQaVote.{User, UserQuery, SessionView}
  alias Guardian.Permissions
  alias Guardian.Plug, as: GuardianPlug
  alias Ecto.Changeset

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    changeset = User.login_changeset(%User{})
    render(conn, SessionView, "new.html", changeset: changeset)
  end

  def create(conn, params = %{}) do
    user = UserQuery.by_email(params["user"]["email"] || "")
           |> Repo.first
    if user do
      changeset = User.login_changeset(user, params["user"])
      |> IO.inspect

      if changeset.valid? do
        conn
        |> put_flash(:info, "Logged in.")
        |> GuardianPlug.sign_in(user, :token, perms: %{ default: Permissions.max })
        |> redirect(to: user_path(conn, :index))
      else
        render(conn, "new.html", changeset: changeset)
      end
    else
      changeset = %User{}
                  |> User.login_changeset
                  |> Changeset.add_error(:login, "not found")
      render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> GuardianPlug.sign_out
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end

  def unauthenticated_api(conn, _params) do
    the_conn = put_status(conn, 401)
    case GuardianPlug.claims(conn) do
      { :error, :no_session } -> json(the_conn, %{ error: "Login required" })
      { :error, reason } -> json(the_conn, %{ error: reason })
      _ -> json(the_conn, %{ error: "Login required" })
    end
  end

  def unauthenticated(conn, params) do
    new(conn, params)
  end

  def forbidden_api(conn, _) do
    conn
    |> put_status(403)
    |> json(%{ error: :forbidden })
  end
end
