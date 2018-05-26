defmodule Email do
  @behaviour EspEx.Entity

  defstruct [:reserved_time, :user_id, :reservation_number]

  @impl EspEx.Entity
  def new() do
    %__MODULE__{}
  end

  def reservation_used?(%__MODULE__{reservation_number: nil}, _), do: false

  def reservation_used?(%__MODULE__{} = email, reservation_number) do
    email.reservation_number >= reservation_number
  end

  def reserved?(%__MODULE__{reserved_time: nil}), do: false
  def reserved?(%__MODULE__{}), do: true
  def reserved?(nil), do: false

  def released?(%__MODULE__{reserved_time: nil}), do: true
  def released?(%__MODULE__{}), do: false

  def reserve(%__MODULE__{} = email, time, reservation_number) do
    email
    |> Map.put(:reserved_time, time)
    |> Map.put(:reservation_number, reservation_number)
  end

  def release(%__MODULE__{} = email) do
    Map.put(email, :reserved_time, nil)
  end
end
