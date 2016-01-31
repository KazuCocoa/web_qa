defmodule WebQaVote.VoteTest do
  use WebQaVote.ModelCase

  alias WebQaVote.Vote
  alias WebQaVote.Repo

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

  test "should vote count is greter than zero" do
    refute {:count, {"must be greater than %{count}", [count: 0]}}  in errors_on(%Vote{}, @valid_attrs)

    attrs = %{count: 0, question_num: 42, user: "some content"}
    refute {:count, {"must be greater than %{count}", [count: 0]}} in errors_on(%Vote{}, attrs)

    attrs = %{count: -1, question_num: 42, user: "some content"}
    assert {:count, {"must be greater than %{count}", [count: -1]}} in errors_on(%Vote{}, attrs)

    attrs = %{count: nil, question_num: 42, user: "some content"}
    assert {:count, "can't be blank"} in errors_on(%Vote{}, attrs)
  end

  test "countup vote count" do
    vote = %Vote{}
           |> Vote.changeset(@valid_attrs)
           |> Repo.insert!
           |> Vote.countup
    assert vote.count == 43
  end
end
