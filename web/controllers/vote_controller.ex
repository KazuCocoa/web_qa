defmodule WebQaVote.VoteController do
  use WebQaVote.Web, :controller

  alias WebQaVote.Vote
  alias WebQaVote.SessionController

  plug Guardian.Plug.EnsureSession, %{ on_failure: { SessionController, :new } } when not action in [:index, :countup_vote]
  plug Guardian.Plug.EnsurePermissions, %{ on_failure: { __MODULE__, :forbidden }, default: [:write_profile] } when action in [:new, :create, :edit, :update]

  plug :scrub_params, "vote" when action in [:create, :update]

  def index(conn, _params) do
    votes = Repo.all(Vote)
    render(conn, "index.html", votes: votes)
  end

  def countup_vote(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id)
           |> Vote.countup
    conn
    |> put_flash(:info, "Voting to #{vote.user} successfuly")
    |> redirect(to: vote_path(conn, :index))
  end

  def new(conn, _params) do
    changeset = Vote.changeset(%Vote{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"vote" => vote_params}) do
    changeset = Vote.changeset(%Vote{}, vote_params)

    case Repo.insert(changeset) do
      {:ok, _vote} ->
        conn
        |> put_flash(:info, "Vote created successfully.")
        |> redirect(to: vote_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id)
    render(conn, "show.html", vote: vote)
  end

  def edit(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id)
    changeset = Vote.changeset(vote)
    render(conn, "edit.html", vote: vote, changeset: changeset)
  end

  def update(conn, %{"id" => id, "vote" => vote_params}) do
    vote = Repo.get!(Vote, id)
    changeset = Vote.changeset(vote, vote_params)

    case Repo.update(changeset) do
      {:ok, vote} ->
        conn
        |> put_flash(:info, "Vote updated successfully.")
        |> redirect(to: vote_path(conn, :show, vote))
      {:error, changeset} ->
        render(conn, "edit.html", vote: vote, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(vote)

    conn
    |> put_flash(:info, "Vote deleted successfully.")
    |> redirect(to: vote_path(conn, :index))
  end

end
