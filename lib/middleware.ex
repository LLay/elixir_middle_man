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

  @impl true
  def handle_call({:profile_self}, _from, state) do
    {:reply, profile_self(), state}
  end

  def wrap_function(func) do
    fn args ->
        res = func.(args)
        # profile_self()
        res
    end
  end

  def profile_self() do
    # We have to make this call specifically to :binary because it is not returned
    # by :recon.info(), even though is is in the process_info struct
    # http://erlang.org/doc/man/erlang.html#process_info-1 @ "{binary, BinInfo}"
    #
    # This is likely a performance optimization made by recon
    #
    # Binary is of the form [{BinaryId, BinarySize, BinaryRefcCount}, ...]
    binary = :recon.info(self(), :binary) |> elem(1)
    binary_len = binary |> length()
    binary_sample = binary |> Enum.slice(0..20)

    info = :recon.info(self())
    garbage_collection = info[:memory_used][:garbage_collection]
    num_minor_gcs = garbage_collection[:minor_gcs]

    Logger.info("
      binary_len: #{binary_len},
      binary_sample: #{inspect binary_sample},
      num_minor_gcs: #{inspect num_minor_gcs}
    ")
  end
end
