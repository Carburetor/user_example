defmodule User do
  @behaviour EspEx.Entity

  defstruct [:id, :email, :close_time, :signed_up_time]

  @impl EspEx.Entity
  def new() do
    %__MODULE__{}
  end

  def closed?(%__MODULE__{close_time: nil}), do: false
  def closed?(%__MODULE__{}), do: true

  def close(%__MODULE__{} = user, close_time) do
    Map.put(user, :close_time, close_time)
  end

  def sign_up(%__MODULE__{} = user, email, signed_up_time) do
    user
    |> Map.put(:email, email)
    |> Map.put(:signed_up_time, signed_up_time)
  end

  def signed_up?(%__MODULE__{signed_up_time: nil}), do: false
  def signed_up?(%__MODULE__{}), do: true
  def signed_up?(nil), do: false
end
