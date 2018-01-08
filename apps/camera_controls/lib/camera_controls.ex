defmodule CameraControls do
  def images do
    File.ls(image_location())
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
    "#{image_url_path()}#{image}"
  end

  defp image_url_path do
    Application.get_env(:camera, :image_path) || "pic_images/"
  end

  defp image_location do
    Application.get_env(:camera, :image_location) || "/root/images"
  end

  def capture_photo() do
    File.mkdir(image_location())
    File.write!(Path.join(image_location(), "#{next_image_number()}.jpg"), CameraControls.Camera.adapter.next_frame)

  end
end
