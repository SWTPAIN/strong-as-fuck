defmodule StrongAsFuckBackend.ServerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: :strong_as_fuck_backend_server_supervisor)
  end

  def start_child(username) do
    Supervisor.start_child(:strong_as_fuck_backend_server_supervisor, [username])
  end

  def init(_args) do
    children = [
      worker(StrongAsFuckBackend.Server, [])
    ]
    # simple_one_for_one becuase all child process are dynamically added instance
    supervise(children, strategy: :simple_one_for_one)
  end
end
