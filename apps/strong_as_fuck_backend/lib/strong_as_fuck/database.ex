defmodule StrongAsFuckBackend.Database do

  @worker_timeout 50000

  alias StrongAsFuckBackend.DatabaseSupervisor

  @pool_size Application.get_env(:strong_as_fuck_backend, :database_pool_size) || 10

  def start_link() do
    :mnesia.stop
    :mnesia.create_schema([node()])
    :mnesia.start
    :mnesia.create_table(
      :training_log_books,
      [
        attributes: [:username, :logs],
        disc_only_copies: [node()]
      ]
    )
    :ok = :mnesia.wait_for_tables([:training_log_books], 10000)

    DatabaseSupervisor.start_link(@pool_size)
  end

  def insert(key, data) do
    :poolboy.transaction(
      DatabaseSupervisor.pool_name(),
      fn(pid) ->
        GenServer.call(pid, {:insert, key, data})
      end,
      @worker_timeout
    )
  end

  def get(key) do
    :poolboy.transaction(
      DatabaseSupervisor.pool_name(),
      fn(pid) ->
        GenServer.call(pid, {:get, key})
      end,
      @worker_timeout
    )
  end

end
