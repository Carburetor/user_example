defmodule Email.Events do
  use EspEx.EventTransformer

  defmodule Reserved do
    defstruct [:user_id, :time]
  end

  defmodule Released do
    defstruct [:user_id, :time]
  end
end
