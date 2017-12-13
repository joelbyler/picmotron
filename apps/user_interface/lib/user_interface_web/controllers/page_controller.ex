defmodule UserInterfaceWeb.PageController do
  use UserInterfaceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
