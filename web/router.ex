defmodule WebQa.Router do
  use WebQa.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyAuthorization
    plug Guardian.Plug.LoadResource
  end

  scope "/", WebQa do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebQa do
  #   pipe_through :api
  # end
end
