defmodule Profiler do
  use Task
  require Logger

  @loop_interval 100

  def child_spec(pid) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [pid]}
    }
  end

  def start_link([pid]) do
    Logger.info("Starting #{__MODULE__}")
    Task.start_link(__MODULE__, :start_loop, [pid])
  end

  def start_loop(pid) do
    loop(pid)
  end

  def loop(pid) do
    profile(pid)
    Process.sleep(@loop_interval)

    loop(pid)
  end

  def profile(pid) do
    # We have to make this call specifically to :binary because it is not returned
    # by :recon.info(), even though is is in the process_info struct
    # http://erlang.org/doc/man/erlang.html#process_info-1 @ "{binary, BinInfo}"
    #
    # This is likely a performance optimization made by recon
    #
    # Binary is of the form [{BinaryId, BinarySize, BinaryRefcCount}, ...]
    binary = :recon.info(pid, :binary) |> elem(1)
    binary_len = binary |> length()
    binary_sample = binary |> Enum.slice(0..20)

    info = :recon.info(pid)
    garbage_collection = info[:memory_used][:garbage_collection]
    num_minor_gcs = garbage_collection[:minor_gcs]

    Logger.info("
      binary_len: #{binary_len},
      binary_sample: #{inspect binary_sample},
      num_minor_gcs: #{inspect num_minor_gcs}")
  end
end
