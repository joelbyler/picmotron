defmodule CameraControls.Timelapse do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_next_pic()

    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts("Saving snapshot")
    CameraControls.capture_photo()

    schedule_next_pic()

    {:noreply, state}
  end

  defp schedule_next_pic() do
    Process.send_after(
      self(),
      :work,
      timelapse_period()
    )
  end

  defp timelapse_period() do
    Application.get_env(:camera, :timelapse_period) || 3 * 60 * 1000
  end
end
