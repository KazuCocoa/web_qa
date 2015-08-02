defmodule WebQaVote.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :encrypted_password, :string
      add :permission, :integer, default: 0
      add :is_deleted, :boolean, default: false

      timestamps
    end
    create index(:users, [:email])

  end
end
