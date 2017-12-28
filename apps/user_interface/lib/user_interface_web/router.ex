defmodule UserInterfaceWeb.Router do
  use UserInterfaceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserInterfaceWeb do
    pipe_through :browser # Use the default browser stack

    resources "/", VideoController, only: [:index, :new]

    forward "/video.mjpg", CameraStream
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserInterfaceWeb do
  #   pipe_through :api
  # end
end
