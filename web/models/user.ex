defmodule WebQaVote.User do
  @moduledoc false

  use WebQaVote.Web, :model

  alias WebQaVote.Repo
  alias WebQaVote.User
  alias Ecto.Changeset, as: Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :permission, :integer, default: 0
    field :is_deleted, :boolean, default: false

    timestamps
  end

  @allowed ~w(name email password)

  @login_allowd ~w(email password)

  def from_email(nil), do: { :error, :not_found }
  def from_email(email) do
    User
    |> Repo.first(email: email)
  end

  def create_changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required([:name, :email, :password])
    |> maybe_update_password
    |> unique_constraint(:email, [message: "Already anyone use same email."])
  end

  def update_changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> maybe_update_password
    |> unique_constraint(:email, [message: "Already anyone use same email."])
  end

  def login_changeset(model), do: model |> cast(%{}, @login_allowd)

  def login_changeset(model, params) do
    model
    |> cast(params, @login_allowd)
    |> validate_required([:email, :password])
    |> validate_password
  end

  def valid_password?(nil, _), do: false
  def valid_password?(_, nil), do: false
  def valid_password?(password, crypted), do: Bcrypt.checkpw(password, crypted)

  defp maybe_update_password(changeset) do
    case Changeset.fetch_change(changeset, :password) do
      { :ok, password } ->
        changeset
        |> Changeset.put_change(:encrypted_password, Bcrypt.hashpwsalt(password))
      :error -> changeset
    end
  end

  defp validate_password(changeset) do
    case Changeset.get_field(changeset, :encrypted_password) do
      nil -> password_incorrect_error(changeset)
      crypted -> validate_password(changeset, crypted)
    end
  end

  defp validate_password(changeset, crypted) do
    password = Changeset.get_change(changeset, :password)
    if valid_password?(password, crypted), do: changeset, else: password_incorrect_error(changeset)
  end

  defp password_incorrect_error(changeset), do: Changeset.add_error(changeset, :password, "is incorrect")

  def admin? do
    case User |> Repo.first do
      nil -> false
      _ -> true
    end
  end
end
