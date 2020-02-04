defmodule ElixirMiddlewareMemoryIssue.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_middleware_memory_issue,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ElixirMiddlewareMemoryIssue, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:recon, "~> 2.5"}
      # {:observer_cli, "~> 1.4"} #production memory analysis
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
