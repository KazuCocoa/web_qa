defmodule WebQa.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :password, :string
      add :permission, :integer, default: 0
      add :is_deleted, :boolean, default: false

      timestamps
    end

  end
end
