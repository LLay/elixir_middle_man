defmodule DynamicSup do
  use DynamicSupervisor
  require Logger

  def start_link(_) do
    Logger.info("Starting #{__MODULE__}")
    {:ok, pid} = DynamicSupervisor.start_link(__MODULE__, [nil], name: __MODULE__)
    {:ok, middleware_pid} = DynamicSupervisor.start_child(__MODULE__, Middleware) |> IO.inspect
    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, Profiler.child_spec([middleware_pid]))
    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, Sender.child_spec([]))

    {:ok, pid}
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
