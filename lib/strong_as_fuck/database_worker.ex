defmodule StrongAsFuck.DatabaseWorker do
  use GenServer

  def start_link(worker_id) do
    IO.puts "Starting #{__MODULE__} #{worker_id}"
    GenServer.start_link(
      __MODULE__,
      nil,
      []
    )
  end

  def init(_) do
    {
      :ok,
      %{
        processing_job_pid: nil,
        pending_jobs: %{}
      }
    }
  end

  def handle_call({:get, key}, _from, state) do
    IO.puts "get key #{key}"
    db_result = :mnesia.transaction(
      fn -> :mnesia.read({:training_log_books, key}) end
    )
    IO.inspect db_result
    result = case db_result do
      {:atomic, [{:training_log_books, ^key, list}]} -> list
      _ -> nil
    end
    IO.inspect result
    {:reply, result, state}
  end

  def handle_call({:insert, key, data}, from, state) do
    IO.puts "insert key #{key}"
    new_state =
      state
      |> add_pending_job(from, key, data)
      |> process_pending_jobs
    {:reply, :ok, new_state}
  end

  def handle_info(
    {:DOWN, _, :process, pid, :normal},
    %{processing_job_pid: processing_job_pid} = state
  ) when pid === processing_job_pid do
    {:noreply, process_pending_jobs(%{state | processing_job_pid: nil})}
  end

  defp add_pending_job(state, from, key, data) do
     %{
       state
       | pending_jobs: Map.put(state.pending_jobs, key, {from, data})
     }
  end

  # no pending jobs
  defp process_pending_jobs(
    %{pending_jobs: pending_jobs} = state
  ) when map_size(pending_jobs) == 0, do: state

  # there is pending jobs and no processing job
  defp process_pending_jobs(%{processing_job_pid: nil} = state) do
    processing_job_pid = spawn_link(fn -> insert_to_db(state.pending_jobs) end)
    # So we can receive :DOWN message when processing job is done
    Process.monitor(processing_job_pid)

    %{
      state |
      processing_job_pid: processing_job_pid,
      pending_jobs: %{}
    }
  end

  defp process_pending_jobs(state) do
    IO.inspect state
  end
  # defp process_pending_jobs(state), do: state

  defp insert_to_db(jobs) do
    IO.puts "insert_to_db"
    {:atomic, :ok} = :mnesia.transaction(fn ->
      for {key, {_, data}} <- jobs do
        :ok = :mnesia.write({:training_log_books, key, data})
      end
      :ok
    end)

    for {_, {from, _}} <- jobs do
      GenServer.reply(from, :ok)
    end
  end
end
