defmodule User.Projection do
  use EspEx.Projection

  alias User.Events, as: Event

  def apply(%User{} = user, %Event.SignedUp{} = signed_up) do
    user
    |> User.sign_up(signed_up.email, signed_up.time)
    |> Map.put(:id, signed_up.id)
  end

  def apply(%User{} = user, %Event.Closed{} = closed) do
    User.close(user, closed.time)
  end
end
