defmodule WebQaVote.Vote do
  @moduledoc false

  use WebQaVote.Web, :model

  alias WebQaVote.Repo
  alias WebQaVote.Vote

  schema "votes" do
    field :question_num, :integer
    field :user, :string
    field :count, :integer
    field :is_locked, :boolean

    timestamps
  end

  @alloed ~w(question_num user count is_locked)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @alloed)
    |> validate_required([:question_num, :user, :count])
    |> validate_number(:count, [greater_than: -1, message: "must be greater than %{count}"])
  end

  def countup(model) do
    model
    |> change
    |> put_change(:count, model.count + 1)
    |> Repo.insert_or_update!
  end

  def lock do
    changeset = from(p in Vote, where: [is_locked: false])
    vote = changeset
           |> Repo.all
    case vote do
      [] ->
        Repo.update_all(Vote, set: [is_locked: false])
      _ ->
        Repo.update_all(Vote, set: [is_locked: true])
    end
  end
end
