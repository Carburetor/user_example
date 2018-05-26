defmodule Helpers do
  alias EspEx.MessageStore.Postgres, as: MessageStore
  alias User.Commands

  def create_user(email) do
    stream_name = EspEx.StreamName.new("user", nil, ["command"])

    id = UUID.uuid4()

    %Commands.SignUp{id: id, email: email, time: CurrentTime.now()}
    |> EspEx.Event.to_raw_event(stream_name)
    |> MessageStore.write!()
  end

  def close_user(id) do
    stream_name = EspEx.StreamName.new("user", nil, ["command"])

    %Commands.Close{user_id: id, time: CurrentTime.now()}
    |> EspEx.Event.to_raw_event(stream_name)
    |> MessageStore.write!()
  end
end
