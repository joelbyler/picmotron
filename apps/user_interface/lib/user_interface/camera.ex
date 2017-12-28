defmodule UserInterface.Camera do
  @adapter Application.get_env(:camera, :adapter)

  def adapter() do
    @adapter || UserInterface.Adapters.Picam
  end

  def camera() do
    @adapter.Camera || UserInterface.Adapters.Picam.Camera
  end
end
