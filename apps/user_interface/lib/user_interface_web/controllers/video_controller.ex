defmodule UserInterfaceWeb.VideoController do
  use UserInterfaceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", images: images() ++ placeholders()
  end

  def new(conn, _params) do
    File.write!(Path.join(image_location(), "#{next_image_number()}.jpg"), UserInterface.Camera.adapter.next_frame)
    redirect conn, to: "/"
  end

  defp images do
    File.ls(image_location)
     |> parse_ls
     |> Enum.sort(&(image_number(&1) >= image_number(&2)))
     |> Enum.map(&path_for_image(&1))
  end

  defp next_image_number do
    Enum.count(images()) + 1
  end

  defp image_number(image_name) do
    image_name
      |> String.split(".")
      |> hd
      |> String.to_integer
  end

  defp parse_ls({:ok, image_list}) do
    image_list
  end

  defp parse_ls({:error, _}) do
    []
  end

  defp path_for_image(image) do
    "#{image_url_path}#{image}"
  end

  defp placeholders do
    add_placeholder_images(12 - Enum.count(images))
  end

  defp add_placeholder_images(number) when number > 0 do
    ["images/placeholder.jpg"] ++ add_placeholder_images(number - 1)
  end

  defp add_placeholder_images(_) do
    []
  end

  defp image_url_path do
    Application.get_env(:camera, :image_path)
  end

  defp image_location do
    Application.get_env(:camera, :image_location)
  end

end
