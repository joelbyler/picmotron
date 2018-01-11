defmodule Firmware.Network do
  def setup_network do
    allow_system_init()
    init_network()
    init_dnsmasq()
    init_hostapd()
  end

  defp allow_system_init do
    :timer.sleep(5000)
  end

  defp init_network do
    System.cmd("sysctl", ["-w", "net.ipv4.ip_forward=1"]) |> print_cmd_result

    System.cmd("ip", ["link", "set", "wlan0", "up"]) |> print_cmd_result
    System.cmd("ip", ["addr", "add", "192.168.24.1/24", "dev", "wlan0"]) |> print_cmd_result
  end

  defp init_dnsmasq do
    System.cmd("dnsmasq", ["--dhcp-lease", "/root/dnsmasq.lease"]) |> print_cmd_result
  end

  defp init_hostapd do
    System.cmd("hostapd", ["-B", "-d", "/etc/hostapd/hostapd.conf"]) |> print_cmd_result
  end

  defp print_cmd_result({message, 0}) do
    IO.puts(message)
  end

  defp print_cmd_result({message, err_no}) do
    IO.puts("ERROR (#{err_no}): #{message}")
  end
end
