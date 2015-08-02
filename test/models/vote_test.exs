defmodule WebQa.VoteTest do
  use WebQa.ModelCase

  alias WebQa.Vote
  alias WebQa.Repo

  @valid_attrs %{count: 42, question_num: 42, user: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vote.changeset(%Vote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vote.changeset(%Vote{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "countup vote count" do
    vote = Vote.changeset(%Vote{}, @valid_attrs)
           |> Repo.insert!
           |> Vote.countup
    assert vote.count == 43
  end
end
