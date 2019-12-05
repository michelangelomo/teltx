defmodule Teltx.Server.Handler do
  @moduledoc """
  Module to handle incoming connections and decode them
  """

  alias Teltx.Decoder

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, _opts) do
    :ok = :ranch.accept_ack(ref)
    loop(socket, transport)
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 5000) do
      {:ok, data} ->
        data =
          data
          |> Decoder.handle()
          |> Tuple.to_list()
          |> Enum.join()

        transport.send(socket, data)
        loop(socket, transport)
      _ ->
        :ok = transport.close(socket)
    end
  end
end
