defmodule StrongAsFuck.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_args) do
    children = [
      supervisor(StrongAsFuck.Database, []),
      supervisor(StrongAsFuck.ServerSupervisor, []),
      worker(StrongAsFuck.Cache, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
