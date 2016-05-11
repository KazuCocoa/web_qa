defmodule WebQaVote.UserController do
  @moduledoc false

  use WebQaVote.Web, :controller

  alias WebQaVote.{User, SessionController}
  alias Guardian.Plug.EnsureAuthenticated
  alias Guardian.Plug.EnsurePermissions
  alias Guardian.Plug, as: GuardianPlug

  alias Guardian.Permissions

  plug EnsureAuthenticated,
    %{ handler: SessionController } when not action in [:new, :create]
  plug EnsurePermissions,
    %{ handler: UserController, default: [:write_profile] } when action in [:edit, :update]

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end


  def new(conn, _params), do: render_new(conn, GuardianPlug.current_resource(conn))

  defp render_new(conn, session) when session != nil do
    changeset = User.create_changeset(%User{}, :invalid)
    render(conn, "new.html", changeset: changeset)
  end

  defp render_new(conn, session) when is_nil(session) do
    if User.admin? do
      redirect(conn, to: user_path(conn, :index))
    else
      changeset = User.create_changeset(%User{}, :invalid)
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> GuardianPlug.sign_in(user, :token, perms: %{ default: Permissions.max })
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        conflict_creation conn, changeset, Keyword.has_key?(changeset.errors, :email)
    end
  end

  # [email: "Already anyone use same email."]
  defp conflict_creation(conn, changeset, true) do
    case Keyword.get(changeset.errors, :email) do
      {"Already anyone use same email.", []} ->
        conn
        |> put_status(409)
        |> render("new.html", changeset: changeset)
      _ ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
  defp conflict_creation(conn, changeset, _), do: render(conn, "new.html", changeset: changeset)

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.update_changeset(user, :invalid)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "failed to update")
        |> render("edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def forbidden(conn, _) do
    conn
    |> put_flash(:error, "Forbidden")
    |> redirect(to: user_path(conn, :index))
  end

  def search_email(conn, %{"search" => %{"query" => query}}) do
    result = User.search_user_with_email_ilike query <> "%"

    users = Repo.all(User)

    render(conn, "search_index.html", users: users, assigns: result)
  end
end
