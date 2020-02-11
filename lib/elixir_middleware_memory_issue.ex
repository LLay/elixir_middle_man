defmodule ElixirMiddlewareMemoryIssue do
  @moduledoc """
  Documentation for ElixirMiddlewareMemoryIssue.

  iex -S mix

  ElixirMiddlewareMemoryIssue.start()
  """
  use Application
  require Logger

  def start(_start_type, _start_args) do
    Logger.info("Starting #{__MODULE__}")
    # children = [
    #   Middleware,
    #   Sender
    # ]
    # {:ok, pid} = Supervisor.start_link(__MODULE__, [nil], name: __MODULE__)
    # {:ok, _pid} = Supervisor.start_link(Profiler, middleware_pid)
    # {:ok, _pid} = Supervisor.start_link(Sender, nil)

    # {:ok, pid} = Supervisor.start_link(DynamicSup, nil)
    children = [
      {DynamicSup, strategy: :one_for_all, name: DynamicSup}
    ]
    {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_all)

    Logger.info("started")
    {:ok, pid}
  end
end
