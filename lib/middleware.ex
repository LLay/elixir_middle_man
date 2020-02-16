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

  def call_sender(args) do
    GenServer.call(__MODULE__, {:call_sender, args})
  end

  @impl true
  def handle_call({:call_sender, args}, _from, state) do
    {:reply, Sender.recieve(args), state}
  end
end
