defmodule StrongAsFuckBackend.DatabaseSupervisor do

  def start_link(pool_size) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config(pool_size), [])
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp poolboy_config(pool_size) do
    [
      {:name, {:local, pool_name()}},
      {:worker_module, StrongAsFuckBackend.DatabaseWorker},
      {:size, pool_size},
      {:max_overflow, 2}
    ]
  end

  def pool_name(), do: :strong_as_fuck_backend_database_worker_pool

end
