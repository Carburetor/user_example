defmodule Commands do
  alias EspEx.MessageStore.Postgres, as: MessageStore
  alias User.Commands

  def create_user(email) do
    stream_name = EspEx.StreamName.new("user", nil, ["command"])

    sign_up = %Commands.SignUp{email: email, time: CurrentTime.now()}

    raw_event = EspEx.Event.to_raw_event(sign_up, stream_name)
    MessageStore.write!(raw_event)
  end
end
