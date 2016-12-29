defmodule ElixirCleNerves do
  use Application

  alias Nerves.Leds
  require Logger

  @on_duration  500 # ms
  @off_duration 500 # ms

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # worker(ElixirCleNerves.Worker, [arg1, arg2, arg3]),
    ]


    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    # opts = [strategy: :one_for_one, name: ElixirCleNerves.Supervisor]
    # Supervisor.start_link(children, opts)

    led_list = [ :green ] #Application.get_env(:blinky, :led_list)
    Logger.debug "list of leds to blink is #{inspect led_list}"
    spawn fn -> blink_list_forever(led_list) end
    {:ok, self}

  end

  # call blink_led on each led in the list sequence, repeating forever
  defp blink_list_forever(led_list) do
    Enum.each(led_list, &blink(&1))
    blink_list_forever(led_list)
  end

  # given an led key, turn it on for 100ms then back off
  defp blink(led_key) do
    #Logger.debug "blinking led #{inspect led_key}"
    # Logger.debug "turning on"
    Leds.set [{led_key, true}]
    :timer.sleep @on_duration

    # Logger.debug "turning off"
    Leds.set [{led_key, false}]
    :timer.sleep @off_duration

    System.cmd("raspistill", ["-o", "/root/#{:rand.uniform(3000)}.jpg"])
    :timer.sleep 20000
  end


end
