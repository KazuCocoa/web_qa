defmodule WebQaVote.UserQuery do
  @moduledoc false

  import Ecto.Query
  alias WebQaVote.User

  def by_email(email) do
    from u in User, where: u.email == ^email
  end
end
