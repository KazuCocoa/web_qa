defmodule WebQa.UserTest do
  use WebQa.ModelCase

  alias WebQa.User

  @valid_attrs %{is_deleted: false, encrypted_password: "encrypted_pass", email: "m@example.com", name: "some content", password: "some content", permission: 1}
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
    changeset = User.create_changeset(%User{}, @valid_attrs)
    # assert {:message, "Already anyone use same email."} in errors_on(%Device{}, attrs)
  end
end