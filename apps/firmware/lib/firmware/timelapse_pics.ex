defmodule Firmware.TimelapsePics do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, Application.get_env(:firmware, :timelapse_period)) # In 2 hours
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    File.mkdir(image_location())
    File.write!(Path.join(image_location(), "#{next_image_number()}.jpg"), Picam.next_frame)

    IO.puts("Saving snapshot")

    # Start the timer again
    Process.send_after(self(), :work, Application.get_env(:firmware, :timelapse_period)) # In 2 hours

    {:noreply, state}
  end

  defp images do
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
    Application.get_env(:camera, :image_path) || "pic_images/"
  end

  defp image_location do
    Application.get_env(:camera, :image_location) || "/root/images"
  end

end
