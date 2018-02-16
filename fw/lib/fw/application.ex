defmodule Fw.Application do
  use Application
  require Logger
  alias InfinityAPS.Configuration.Server
  alias Pummpcomm.Radio.ChipSupervisor
  alias Phoenix.PubSub.PG2

  def start(_type, _args) do
    unless host_mode() do
      init_network()
    end

    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  defp children do
    children = [
      Supervisor.child_spec(PG2, start: {PG2, :start_link, [Nerves.PubSub, [poolsize: 1]]}),
    ]

    case host_mode() do
      true ->
        children
      false ->
        children ++ [ChipSupervisor.child_spec([])]
    end
  end

  defp host_mode do
    Application.get_env(:infinity_aps, :host_mode)
  end

  @key_mgmt :"WPA-PSK"
  defp init_network() do
    Logger.info fn() -> "Initializing Network" end
    ssid = Server.get_config(:wifi_ssid)
    psk = Server.get_config(:wifi_psk)
    case psk || "" do
      "" -> Nerves.Network.setup "wlan0", ssid: ssid, key_mgmt: :"NONE"
      _ -> Nerves.Network.setup "wlan0", ssid: ssid, psk: psk, key_mgmt: @key_mgmt
    end
  end
end
