defmodule StrongAsFuckBackend.Server do
  use GenServer

  alias StrongAsFuckBackend.TrainingLogBook, as: TrainingLogBook

  def start_link(username) do
    IO.puts "Starting #{__MODULE__} from #{username}"
    GenServer.start_link(
      StrongAsFuckBackend.Server,
      username,
      name: via_tuple(username)
    )
  end

  def whereis(name) do
    name
    |> to_grpc_key
    |> :gproc.whereis_name
  end

  def add_training_log(server_pid, new_log) do
    GenServer.call(
      server_pid, {:add_training_log, new_log}
    )
  end

  def get_notebook(server_pid) do
    GenServer.call(
      server_pid,
      {:get_notebook}
    )
  end

  def init(username) do
    {:ok, {username, get_initial_state(username)}}
  end

  def handle_call(
    {:add_training_log, new_training_log},
    _,
    {username, trainig_log_book}
  ) do
    case StrongAsFuckBackend.TrainingLogBook.add_log(trainig_log_book, new_training_log) do
      {:ok, new_training_log_book} ->
        StrongAsFuckBackend.Database.insert(username, new_training_log_book)
        {:reply, :ok, {username, new_training_log_book}}
      {:error, err_msg} ->
        {:reply, {:error, err_msg}, {username, trainig_log_book}}
    end
  end

  def handle_call(
    {:get_notebook},
    _,
    {username, trainig_log_book}
  ) do
    case StrongAsFuckBackend.Database.get(username) do
      nil ->
        {:reply, {:error, "no training log book with username: #{username}"}, {username, trainig_log_book}}
      new_training_log_book ->
        {:reply, {:ok, new_training_log_book}, {username, new_training_log_book}}
    end
  end

  defp get_initial_state(username) do
    %TrainingLogBook{username: username}
  end

  # n means a unique registration, l means local (single node) registration
  defp to_grpc_key(name), do: {:n, :l, {:strong_as_fuck_backend_server, name}}

  defp via_tuple(name) do
    {:via, :gproc, to_grpc_key(name)}
  end

end
