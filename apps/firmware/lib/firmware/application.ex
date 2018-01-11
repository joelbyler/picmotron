defmodule Firmware.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(CameraControls.Camera.camera(), []),
      worker(CameraControls.Timelapse, []),
    ]

    Firmware.Network.setup_network()

    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
