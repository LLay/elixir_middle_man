defmodule ElixirMiddlewareMemoryIssue do
  @moduledoc """
  Documentation for ElixirMiddlewareMemoryIssue.

  iex -S mix

  ElixirMiddlewareMemoryIssue.start()
  """
  use Application
  require Logger

  def start(_start_type, _start_args) do
    Logger.info("starting")
    children = [
      Middleware,
      Sender
    ]

    {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)
    Logger.info("started")
    {:ok, pid}
  end
end
