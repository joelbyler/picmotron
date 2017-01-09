defmodule UserInterface.ImageController do
  use UserInterface.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", images: images ++ placeholders
  end

  defp images do
    {:ok, images} =
      Application.get_env(:user_interface, :image_location)
      |> File.ls
    images |> Enum.map(fn(image) -> path_for_image(image) end)
  end

  defp path_for_image(image) do
    image_path = Application.get_env(:user_interface, :image_path)
    "#{image_path}/#{image}"
  end

  defp placeholders do
    add_placeholder_images(12 - Enum.count(images))
  end

  defp add_placeholder_images(number) when number > 0 do
    ["images/bacon.jpg"] ++ add_placeholder_images(number - 1)
  end

  defp add_placeholder_images(0) do
    []
  end
end
