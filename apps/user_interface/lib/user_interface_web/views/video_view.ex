defmodule UserInterfaceWeb.VideoView do
  use UserInterfaceWeb, :view

  def video_image_source do
    case Mix.env do
      :dev -> "/images/placeholder.jpg"
      _ -> "/video.mjpg"
    end
  end
end
