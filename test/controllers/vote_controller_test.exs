defmodule WebQaVote.VoteControllerTest do
  use WebQaVote.ConnCase

  alias WebQaVote.Vote
  @valid_attrs %{count: 42, question_num: 42, user: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, vote_path(conn, :index)
    assert html_response(conn, 200) =~ "Login"
  end

  test "lists all entries on index after voting", %{conn: conn} do
    target = Vote.changeset(%Vote{}, @valid_attrs)
           |> Repo.insert!
    conn = post conn, vote_path(conn, :countup_vote, target.id), vote: target
    assert redirected_to(conn) == vote_path(conn, :index)
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, vote_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, vote_path(conn, :create), vote: @valid_attrs
    assert html_response(conn, 200) =~ "Login"
    refute Repo.get_by(Vote, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, vote_path(conn, :create), vote: @invalid_attrs
    assert html_response(conn, 200) =~ "Login"
  end

  test "shows chosen resource", %{conn: conn} do
    vote = Vote.changeset(%Vote{}, @valid_attrs)
           |> Repo.insert!
    conn = get conn, vote_path(conn, :show, vote)
    assert html_response(conn, 200) =~ "Login"
  end

# Behaviour anyone have session.
#  test "renders page not found when id is nonexistent", %{conn: conn} do
#    assert_raise Ecto.NoResultsError, fn ->
#      get conn, vote_path(conn, :show, -1)
#    end
#  end

  test "renders login page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, vote_path(conn, :show, -1)
    assert html_response(conn, 200) =~ "Login"
  end


  test "renders form for editing chosen resource", %{conn: conn} do
    vote = Vote.changeset(%Vote{}, @valid_attrs)
           |> Repo.insert!
    conn = get conn, vote_path(conn, :edit, vote)
    assert html_response(conn, 200) =~ "Login"
  end

  test "can't updates chosen resource and redirects when data is valid", %{conn: conn} do
    vote = Vote.changeset(%Vote{}, @valid_attrs)
           |> Repo.insert!
   conn = put conn, vote_path(conn, :update, vote), vote: @valid_attrs
    assert html_response(conn, 200) =~ "Login"
    assert Repo.get_by(Vote, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    vote = Vote.changeset(%Vote{}, @valid_attrs)
           |> Repo.insert!
    conn = put conn, vote_path(conn, :update, vote), vote: @invalid_attrs
    assert html_response(conn, 200) =~ "Login"
  end

  test "can't deletes chosen resource", %{conn: conn} do
    vote = Vote.changeset(%Vote{}, @valid_attrs)
           |> Repo.insert!
    conn = delete conn, vote_path(conn, :delete, vote)
    assert html_response(conn, 200) =~ "Login"
    assert Repo.get(Vote, vote.id)
  end
end
