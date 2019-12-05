defmodule Teltx.Server.TCP do
  @moduledoc """
  GenServer to handle TCP server
  """

  require Logger

  use GenServer

  def start_link(_opts) do
    Logger.info("Starting TCP server...")
    {:ok, _} = :ranch.start_listener(__MODULE__, 100, :ranch_tcp, [port: port()], Teltx.Server.Handler, [])
  end

  @impl true
  def init(_) do
    #
  end

  @spec port() :: integer()
  defp port, do: String.to_integer(Application.get_env(:teltx, :tcp_port))
end
