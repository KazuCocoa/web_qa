defmodule WebQaVote.HelloController do
  @moduledoc false

  use WebQaVote.Web, :controller
  use RevisionPlateEx.Hello

  def revision(conn, _opt), do: Hello.revision conn
end
