defmodule User.Events do
  use EspEx.EventTransformer

  defmodule SignedUp do
    defstruct [:email, :time]
  end

  defmodule Closed do
    defstruct [:time]
  end
end
