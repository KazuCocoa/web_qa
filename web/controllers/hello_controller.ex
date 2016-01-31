defmodule WebQaVote.HelloController do
  @moduledoc false

  use WebQaVote.Web, :controller

  def revision(conn, _opt), do: RevisionPlateEx.Hello.revision conn
end
