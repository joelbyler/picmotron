defmodule UserInterfaceWeb.DownloadController do
  use UserInterfaceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", images: downloads()
  end
# :zip.create(to_charlist("abc.zip"),[to_charlist("apps/user_interface/config/config.exs"), to_charlist("apps/user_interface/config/config.exs")])
  def downloads() do
    # TODO: create list of download files
  end

  def create_zip(file_name, file_list) do
    file_name
      |> to_charlist
      |> :zip.create(Enum.map(file_list, &(to_charlist(&1))))
  end
end
