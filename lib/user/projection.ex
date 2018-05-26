defmodule User.Projection do
  use EspEx.Projection

  alias User.Events, as: Event

  def apply(%User{} = user, %Event.SignedUp{} = signed_up) do
    User.sign_up(user, signed_up.email, signed_up.time)
  end

  def apply(%User{} = user, %Event.Closed{} = closed) do
    User.close(user, closed.time)
  end
end
