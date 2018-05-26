defmodule Email.Projection do
  use EspEx.Projection

  alias Email.Events, as: Event

  def apply(%Email{} = email, %Event.Reserved{} = reserved) do
    Email.reserve(email, reserved.time)
  end

  def apply(%Email{} = email, %Event.Released{}) do
    Email.release(email)
  end
end
