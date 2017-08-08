defmodule StrongAsFuck.RecordBook do

  @movements ~w(pullup pushup)a
  defstruct pullup: 0, pushup: 0

  def add_record(
    book,
    movement
  ) when movement in @movements do
    book
    |> Map.put(movement, Map.get(book, movement) + 1)
    |> validate
  end

  def remove_record(
    book,
    movement
  ) when movement in @movements do
    book
    |> Map.put(movement, Map.get(book, movement) - 1)
    |> validate
  end

  def get_stat(%{pullup: pullup, pushup: pushup}) do
    %{
      pullup: pullup,
      pushup: pushup
    }
  end

  defp validate(
    %StrongAsFuck.RecordBook{
      pullup: pullup,
      pushup: pushup
    } = book
  ) do
    cond do
      pullup < 0 || pushup < 0 ->
        {:error, "Movement count cannot be lower than 0"}
      true ->
        {:ok, book}
    end
  end

end
