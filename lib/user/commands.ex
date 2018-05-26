defmodule User.Commands do
  use EspEx.EventTransformer

  defmodule SignUp do
    defstruct [:id, :email, :time]
  end

  defmodule Close do
    defstruct [:user_id, :time]
  end
end
