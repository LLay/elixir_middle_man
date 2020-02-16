defmodule ElixirMiddlewareMemoryIssue do
  @moduledoc """
  Documentation for ElixirMiddlewareMemoryIssue.

  mix run --no-halt
  """
  use Application
  require Logger

  def start(_start_type, _start_args) do
    Logger.info("Starting #{__MODULE__}")

    children = [
      {DynamicSup, strategy: :one_for_all, name: DynamicSup}
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
  end
end
