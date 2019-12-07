defmodule Teltx.Server.Handler do
  @moduledoc """
  Module to handle incoming connections and decode them
  """
  use GenServer

  require Logger

  alias Teltx.Decoder

  def start_link(ref, socket, transport, _opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(ref, socket, transport) do
    name = get_device(socket)

    Logger.info("Device #{name} connecting")

    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])

    :gen_server.enter_loop(__MODULE__, [], %{
      socket: socket,
      transport: transport,
      name: name,
      imei: nil
    })
  end

  def handle_info(
        {:tcp, _, message},
        %{socket: socket, transport: transport, name: name, imei: imei} = state
      ) do
    Logger.info("Received new message from #{name}: #{inspect(message)}. Imei: #{inspect(imei)}")

    case Decoder.handle(message) do
      {:authenticated, imei} = data ->
        Logger.info("Authenticating imei #{inspect(imei)}. Put it in the state.")
        # Send authentication success
        transport.send(socket, '01')
        {:noreply, %{state | imei: imei}}

      _ ->
        {:noreply, state}
    end
  end

  def handle_info({:tcp_closed, _}, %{name: name} = state) do
    Logger.info("Device #{name} disconnected")

    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, _, reason}, %{name: name} = state) do
    Logger.info("Error with device #{name}: #{inspect(reason)}")

    {:stop, :normal, state}
  end

  # Helpers

  defp get_device(socket) do
    {:ok, {addr, port}} = :inet.peername(socket)

    address =
      addr
      |> :inet_parse.ntoa()
      |> to_string()

    "#{address}:#{port}"
  end
end
