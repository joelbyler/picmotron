defmodule Firmware do
  use Application

  alias Nerves.Leds
  require Logger

  @blink_count    12
  @blink_duration 100
  @sleep_duration 1000 * 60 * 10 # every 10 mins

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Task, [fn -> Nerves.Networking.setup :eth0, [mode: "dhcp"] end], restart: :transient)
    ]

    setup_network

    spawn fn -> pic_loop end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pic_loop do
    blink(:green, true, @blink_count)
    snap_pic
    pic_loop
  end

  defp snap_pic do
    File.mkdir(image_location)
    System.cmd("raspistill", ["-o", "#{image_location}/#{next_image_number}.jpg"])
    :timer.sleep @sleep_duration
  end

  defp blink(_, _, 0) do
  end

  defp blink(led_key, high, times) do
    Leds.set [{led_key, high}]
    :timer.sleep @blink_duration

    blink(led_key, !high, times - 1)
  end

  defp image_location do
    Application.get_env(:user_interface, :image_location)
  end

  defp next_image_number do
    Enum.count(images) + 1
  end

  defp images do
    File.ls(image_location)
     |> parse_ls
  end

  defp parse_ls({:ok, image_list}) do
    image_list
  end

  defp parse_ls({:error, _}) do
    []
  end


  defp setup_network do
    System.cmd("sysctl", ["-w", "net.ipv4.ip_forward=1"]) |> print_cmd_result

    # System.cmd("ip", ["route", "add", "default", "via", default_gateway]) |> print_cmd_result

    System.cmd("ip", ["link", "set", "wlan0", "up"]) |> print_cmd_result
    System.cmd("ip", ["addr", "add", "192.168.24.1/24", "dev", "wlan0"]) |> print_cmd_result

    System.cmd("dnsmasq", ["--dhcp-lease", "/root/dnsmasq.lease"]) |> print_cmd_result

    System.cmd("hostapd", ["-B", "-d", "/etc/hostapd/hostapd.conf"]) |> print_cmd_result

  end

  defp print_cmd_result({message, 0}) do
    IO.puts message
  end

  defp print_cmd_result({message, err_no}) do
    IO.puts "ERROR (#{err_no}): #{message}"
  end
  #
  # defp default_gateway do
  #   Application.get_env(:firmware, :settings)[:default_gateway]
  # end
  #
  # defp static_addr do
  #   Application.get_env(:firmware, :settings)[:static_addr]
  # end
end
