defmodule WebQaVote.UserTest do
  use WebQaVote.ModelCase, async: true

  alias WebQaVote.User

  @valid_attrs %{is_deleted: false, encrypted_password: "encrypted_pass",
                 email: "m@example.com", name: "some content", password: "some content", permission: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.create_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.create_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "should email is unique" do
    %User{}
    |> User.create_changeset(@valid_attrs)
    |> Repo.insert!
    {:error, changeset} = Repo.insert User.create_changeset(%User{}, @valid_attrs)
    assert changeset.errors == [email: {"Already anyone use same email.", []}]
  end

  test "should true if User have a user" do
    %User{}
    |> User.create_changeset(@valid_attrs)
    |> Repo.insert!
    assert User.admin?
  end

  test "should false if User have no user" do
    refute User.admin?
  end


end
