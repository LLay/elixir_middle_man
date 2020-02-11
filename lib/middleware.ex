defmodule Middleware do
  use GenServer
  require Logger

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link() do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def execute_function(func, args) do
    GenServer.call(__MODULE__, {:execute_function, wrap_function(func), args})
  end

  def profile_self(func, args) do
    Logger.info("profile")
    GenServer.call(__MODULE__, {:profile_self, wrap_function(func), args})
  end

  @impl true
  def handle_call({:execute_function, func, args}, _from, state) do
    {:reply, func.(args), state}
  end

  def wrap_function(func) do
    fn args ->
      func.(args)
    end
  end
end
