defmodule Email.Events do
  use EspEx.EventTransformer

  defmodule Reserved do
    defstruct [:user_id, :time, :reservation_number]
  end

  defmodule Released do
    defstruct [:user_id, :time]
  end
end
