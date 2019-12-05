defmodule Teltx.MixProject do
  use Mix.Project

  def project do
    [
      app: :teltx,
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ranch],
      mod: {Teltx.Application, []}
    ]
  end

  defp deps do
    [
      {:ranch, "~> 1.7"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
