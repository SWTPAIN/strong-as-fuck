defmodule StrongAsFuck.Server do

  alias StrongAsFuck.RecordBook, as: RecordBook

  def start() do
    spawn(&init/0)
  end

  def add_training_record(server_pid, movement) do
    send(server_pid, {:add_training_record, movement, self() })
    receive do
      response ->
        response
    end
  end

  def remove_training_record(server_pid, movement) do
    send(server_pid, {:remove_training_record, movement, self() })
    receive do
      response ->
        response
    end
  end

  def get_stat(server_pid) do
    send(server_pid, {:get_stat, self() })
    receive do
      response ->
        response
    end
  end

  def init() do
    loop get_initial_state()
  end

  defp loop(state) do
    new_state = receive do
      message ->
        handle_message(state, message)
    end
    loop(new_state)
  end

  defp handle_message(state, message) do
    case message do
      {:add_training_record, movement, caller} ->
        case RecordBook.add_record(state, movement) do
          {:ok, new_state} ->
            send caller, :ok
            new_state
          {:error, message} ->
            send caller, {:error, message}
            state
        end
      {:remove_training_record, movement, caller} ->
        case RecordBook.remove_record(state, movement) do
          {:ok, new_state} ->
            send caller, :ok
            new_state
          {:error, message} ->
            send caller, {:error, message}
            state
        end
      {:get_stat, caller} ->
        send caller, {:ok, RecordBook.get_stat(state)}
        state
      _ ->
        state
    end
  end

  defp get_initial_state() do
    %RecordBook{}
  end
end
