defmodule StrongAsFuck.TrainingLog do

  @allowed_movements ~w(snatch clean_and_jerk squat bench deadlift)
  @enforce_keys [:movement_name, :weight, :rep]
  defstruct [:movement_name, :weight, :rep]

  def new(%{
    movement_name: movement_name
  }) when not (movement_name in @allowed_movements) do
    {:error, "not a valid movement name"}
  end

  def new(%{
    rep: rep
  }) when rep < 0 do
    {:error, "rep must not be negative"}
  end

  def new(%{
    weight: weight
  }) when weight < 0 do
    {:error, "weight must not be negative"}
  end

  def new(%{
    movement_name: movement_name,
    weight: weight,
    rep: rep
  }
  ) do
    {
      :ok,
      %__MODULE__{
        movement_name: movement_name,
        weight: weight,
        rep: rep
      }
    }
  end

end
