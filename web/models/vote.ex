defmodule WebQaVote.Vote do
  use WebQaVote.Web, :model

  alias WebQaVote.Repo

  schema "votes" do
    field :question_num, :integer
    field :user, :string
    field :count, :integer

    timestamps
  end

  @required_fields ~w(question_num user count)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_number(:count, [greater_than: -1, message: "must be greater than %{count}"])
  end

  def countup(model) do
    Repo.update! %{model | count: model.count + 1}
  end
end
