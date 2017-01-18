defmodule UserInterface.WelcomeController do
  use UserInterface.Web, :controller

  def index(conn, _params) do
    redirect conn, to: "/images"
  end
end
