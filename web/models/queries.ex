defmodule WebQa.UserQuery do
  import Ecto.Query
  alias WebQa.User

  def by_email(email) do
    from u in User, where: u.email == ^email
  end
end
