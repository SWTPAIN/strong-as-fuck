defmodule StrongAsFuckBackend.TrainingLogBook do

  @movements ~w(snatch clean_and_jerk squat bench deadlift)a
  @enforce_keys [:username]
  defstruct username: "", logs: []

  def add_log(
    book,
    log_params
  ) do
    case StrongAsFuckBackend.TrainingLog.new(log_params) do
      {:ok, log} ->
        {:ok, Map.put(book, :logs, [log | book.logs])}
      {:error, err_msg} ->
        {:error, err_msg}
    end
  end

  def get_stat(%{pullup: pullup, pushup: pushup}) do
    %{
      pullup: pullup,
      pushup: pushup
    }
  end
end
