defmodule CameraControls.Camera do
  @adapter Application.get_env(:camera, :adapter)

  def adapter() do
    @adapter || Picam
  end

  def camera() do
    @adapter.Camera || Picam.Camera
  end
end
