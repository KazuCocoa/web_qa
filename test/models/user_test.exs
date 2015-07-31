defmodule WebQa.UserTest do
  use WebQa.ModelCase

  alias WebQa.User

  @valid_attrs %{is_deleted: true, email: "m@example.com", name: "some content", password: "some content", permission: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.create_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.create_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
