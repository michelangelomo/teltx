defmodule Teltx.MixProject do
  use Mix.Project

  def project do
    [
      app: :teltx,
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases do
    [
      check: ["format --check-formatted", "dialyzer"],
      "format.all": "format *.{ex,exs} config/*.{ex,exs} lib/**/*.{ex,exs} test/**/*.{ex,exs}"
    ]
  end
end
