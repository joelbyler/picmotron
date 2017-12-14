defmodule UserInterfaceWeb.VideoController do
  use UserInterfaceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    File.write!(Path.join(System.tmp_dir!, "frame.jpg"), Picam.next_frame)
  end
end
