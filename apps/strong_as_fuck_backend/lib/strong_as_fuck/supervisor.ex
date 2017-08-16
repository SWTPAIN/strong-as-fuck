defmodule StrongAsFuckBackend.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_args) do
    children = [
      supervisor(StrongAsFuckBackend.Database, []),
      supervisor(StrongAsFuckBackend.ServerSupervisor, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
