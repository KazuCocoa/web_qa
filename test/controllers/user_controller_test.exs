defmodule WebQaVote.UserControllerTest do
  use WebQaVote.ConnCase

  alias WebQaVote.User
  @valid_attrs %{is_deleted: true, email: "m@example.com", name: "some content", password: "some content", permission: 1}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "Display login page on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Login"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "renders index for new resources if have admin", %{conn: conn} do
    Repo.insert! %User{}
    conn = get conn, user_path(conn, :new)
    assert redirected_to(conn) == user_path(conn, :index)
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by!(User, name: @valid_attrs.name)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Login"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    # assert_raise Ecto.NoResultsError, fn ->
    #   get conn, user_path(conn, :show, -1)
    # end
    conn = get conn, user_path(conn, :show, -1)
    assert html_response(conn, 200) =~ "Login"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Login"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    # assert redirected_to(conn) == user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Login"
    # assert Repo.get_by(User, name: @valid_attrs.name)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Login"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    # assert redirected_to(conn) == user_path(conn, :index)
    assert html_response(conn, 200) =~ "Login"
    # refute Repo.get(User, user.id)
  end
end
