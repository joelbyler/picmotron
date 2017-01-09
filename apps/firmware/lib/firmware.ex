defmodule Firmware do
  use Application

  alias Nerves.Leds
  require Logger

  @blink_count    12
  @blink_duration 100
  @sleep_duration 1000 * 60 * 10

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Task, [fn -> Nerves.Networking.setup :eth0, [mode: "dhcp"] end], restart: :transient)
    ]

    spawn fn -> pic_loop(1) end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # TODO: move pic_loop to a separate app
  defp pic_loop(number) do
    blink(:green, true, @blink_count)
    snap_pic(number)
    pic_loop(number + 1)
  end

  defp snap_pic(number) do
    System.cmd("raspistill", ["-o", "/root/#{number}.jpg"])
    :timer.sleep @sleep_duration
  end

  defp blink(_, _, 0) do
  end

  defp blink(led_key, high, times) do
    Leds.set [{led_key, high}]
    :timer.sleep @blink_duration

    blink(led_key, !high, times - 1)
  end
end
