defmodule WebQaVote.Router do
  @moduledoc false

  use WebQaVote.Web, :router

  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", WebQaVote do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout
    get "/logout", SessionController, :delete, as: :logout

    resources "/users", UserController

    resources "/votes", VoteController
    post "/votes/:id/vote", VoteController, :countup_vote
    get "/votes/:id/vote/finish", VoteController, :finish_voting
    post "/votes/:id/lock", VoteController, :lock_vote

    post "/search", UserController, :search_email
  end

  scope "/", WebQaVote do
    get "/hello/revision", HelloController, :revision
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebQaVote do
  #   pipe_through :api
  # end
end
