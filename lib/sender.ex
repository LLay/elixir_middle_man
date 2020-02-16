defmodule Sender do
  use Task
  require Logger

  @loop_interval 300

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link() do
    Logger.info("Starting #{__MODULE__}")
    Task.start_link(__MODULE__, :start_loop, [])
  end

  def start_loop(), do: loop()

  def loop() do
    # `data` is a RefC binary, as it is greater than the 64 byte threshold
    # below which binaries are copied to the process heap
    # https://erlang.org/doc/efficiency_guide/binaryhandling.html#heap-binaries
    data = "
    datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata
    datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata
    datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata
    datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata
    "

    Middleware.call_sender(data)
    # Middleware.execute_function(&Sender.recieve/1, data)

    Process.sleep(@loop_interval)

    loop()
  end

  def recieve(data) do
    Logger.info("recieved data (#{byte_size(data)} bytes): '#{inspect data}'")
  end
end
