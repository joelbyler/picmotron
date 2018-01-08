defmodule UserInterfaceWeb.VideoController do
  use UserInterfaceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", images: CameraControls.images() ++ placeholders()
  end

  def new(conn, _params) do
    CameraControls.capture_photo()
    redirect conn, to: "/"
  end

  defp placeholders do
    add_placeholder_images(12 - Enum.count(CameraControls.images()))
  end

  defp add_placeholder_images(number) when number > 0 do
    ["images/placeholder.jpg"] ++ add_placeholder_images(number - 1)
  end
  defp add_placeholder_images(_), do: []
end
