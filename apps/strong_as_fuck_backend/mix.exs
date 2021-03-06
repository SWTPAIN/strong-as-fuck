defmodule StrongAsFuckBackend.Mixfile do
  use Mix.Project

  def project do
    [app: :strong_as_fuck_backend,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      extra_applications: [:logger, :poolboy],
      mod: {StrongAsFuckBackend.Application, []}
    ]
  end

  defp deps do
    [
      {:gproc, "~> 0.5.0"},
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.4.0"},
      {:poison, "~> 3.1"},
      {:poolboy, "~> 1.5.1"},
      {:httpoison, "~> 0.13.0", only: :test},
      {:meck, "~> 0.8.6", only: :test}
    ]
  end
end
