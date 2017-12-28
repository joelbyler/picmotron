defmodule UserInterfaceWeb.SnapController do
  use UserInterfaceWeb, :controller

  def new(conn, _params) do
    snap_pic()
    redirect conn, to: "/images"
  end

  # TODO: de-dupe below functions
  defp snap_pic() do
    System.cmd("raspistill", ["-o", "#{image_location()}/#{next_image_number()}.jpg"])
  end

  defp image_location do
    Application.get_env(:user_interface, :image_location)
  end

  defp next_image_number do
    Enum.count(images()) + 1
  end

  defp images() do
    File.ls(image_location())
     |> parse_ls
  end

  defp parse_ls({:ok, image_list}) do
    image_list
  end

  defp parse_ls({:error, _}) do
    []
  end

end
