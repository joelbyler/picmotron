defmodule CameraControls.Adapters.Fake.Picam do

  def set_rotation(_), do: nil
  def set_size(_, _), do: nil

  def next_frame() do
    {:ok, bits} = File.read("#{Application.app_dir(:user_interface, "priv")}/static/images/placeholder.jpg")
    bits
  end

  defmodule Camera do
    @moduledoc """
    GenServer which starts and manages the `raspijpgs` application as a port.
    """

    use GenServer
    require Logger

    def start_link do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_) do
      {:ok, %{}}
    end

    # GenServer callbacks

    def handle_call(:next_frame, from, state) do
      {:noreply, %{}}
    end

    def handle_cast({:set, message}, state) do
      {:noreply, %{}}
    end

    def handle_info({_, {:data, jpg}}, state) do
      {:noreply, %{}}
    end

    def handle_info({_, {:exit_status, _}}, state) do
      {:stop, :unexpected_exit, state}
    end

    def terminate(reason, _state) do
      Logger.warn "Camera GenServer exiting: #{inspect reason}"
    end
  end
end
