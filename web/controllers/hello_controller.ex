defmodule WebQaVote.HelloController do
  @moduledoc false

  use WebQaVote.Web, :controller
  alias RevisionPlateEx.Hello

  def revision(conn, _opt), do: Hello.revision conn
end
