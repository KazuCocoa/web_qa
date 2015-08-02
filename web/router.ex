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
    plug Guardian.Plug.VerifyAuthorization, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", WebQa do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout
    get "/logout", SessionController, :delete, as: :logout

    resources "/users", UserController

    resources "/votes", VoteController
    post "/votes/:id/vote", VoteController, :countup_vote

  end

  # Other scopes may use custom stacks.
  # scope "/api", WebQa do
  #   pipe_through :api
  # end
end
