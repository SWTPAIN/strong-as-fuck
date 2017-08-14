defmodule StrongAsFuck.Cache do
  use GenServer

  def start_link do
    IO.puts "Starting #{__MODULE__}"
    GenServer.start_link(__MODULE__, nil, name: :strong_as_fuck_cache)
  end

  def server_process(username) do
    case StrongAsFuck.Server.whereis(username) do
      :undefined ->
        GenServer.call(:strong_as_fuck_cache, {:server_process, username})
      pid ->
        pid
    end
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:server_process, username}, _, state) do
    server_pid = case StrongAsFuck.Server.whereis(username) do
      :undefined ->
        {:ok, pid} = StrongAsFuck.ServerSupervisor.start_child(username)
        pid
      pid ->
        pid
    end
    {:reply, server_pid, state}
  end

end
