defmodule Email do
  @behaviour EspEx.Entity

  defstruct [:reserved_time, :user_id]

  @impl EspEx.Entity
  def new() do
    %__MODULE__{}
  end

  def reserved?(%__MODULE__{reserved_time: nil}), do: false
  def reserved?(%__MODULE__{}), do: true
  def reserved?(nil), do: false

  def reserve(%__MODULE__{} = email, time) do
    Map.put(email, :reserved_time, time)
  end

  def release(%__MODULE__{} = email) do
    Map.put(email, :reserved_time, nil)
  end
end
