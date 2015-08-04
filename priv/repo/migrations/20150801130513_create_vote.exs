defmodule WebQaVote.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :question_num, :integer
      add :user, :string
      add :count, :integer, [default: 0, null: false]
      add :is_locked, :boolean, default: true

      timestamps
    end

  end
end
