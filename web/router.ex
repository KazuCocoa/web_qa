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


    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout
    get "/logout", SessionController, :delete, as: :logout

    resources "/users", UserController

    # TODO: Deny access who have no session.
    # get "/votes/:id/edit", VoteController, :edit
    # get "/votes/new", VoteController, :new
    # post"/votes", VoteController, :create
    # delete "/votes/:id", VoteController, :delete

  end

  scope "/", WebQa do
    pipe_through [:browser]

    get "/", PageController, :index

    resources "/votes", VoteController
    # TODO: Allow access all users
    # get "/votes", VoteController, :index
    # get "/votes/:id", VoteController, :show
    # patch "/votes/:id", VoteController, :update
    # put "/votes/:id", VoteController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebQa do
  #   pipe_through :api
  # end
end
