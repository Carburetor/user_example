defmodule User.Commands do
  use EspEx.EventTransformer

  defmodule SignUp do
    defstruct [:email, :time]
  end
end
