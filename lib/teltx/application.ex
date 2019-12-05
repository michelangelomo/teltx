defmodule Teltx.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Teltx.Server.TCP
    ]

    opts = [strategy: :one_for_one, name: Teltx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
