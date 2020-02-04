defmodule Sender do
  use Task
  require Logger

  @loop_interval 6000

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link() do
    Task.start_link(__MODULE__, :start_loop, [])
  end

  def start_loop() do
    Task.async(Sender, :profile_loop, [])
    loop()
  end

  def profile_loop() do
    Middleware.profile_self()
    Process.sleep(500)
    profile_loop()
  end

  def loop() do
    # task = Task.async(Middleware, :send_to_reciever, :data)
    # Task.await(task, 1000)

    # `data` is a RefC binary. This is because it is 100 bytes,
    # which is above the 64 byte threshold to be a heap binary
    # https://erlang.org/doc/efficiency_guide/binaryhandling.html#heap-binaries
    data = "This string is 100 bytes 0123456789-0123456789-0123456789-0123456789-0123456789-0123456789-012345678"

    Middleware.execute_function(&Sender.recieve/1, data)
    Process.sleep(@loop_interval)

    loop()
  end

  def recieve(data) do
    Logger.info("recieved data: '#{inspect data}'")
  end
end
