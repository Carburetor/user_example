defmodule User.Commands.Consumer do
  use EspEx.Consumer.Postgres,
    event_transformer: User.Commands,
    stream_name: EspEx.StreamName.new("user", nil, ["command"])

  use EspEx.Handler

  alias User.Commands
  alias BrokenStore, as: MessageStore

  def handle(
        %Commands.SignUp{id: id, email: email, time: time},
        %{global_position: pos} = old_raw,
        _
      ) do
    {reservation, version} = Email.Store.fetch(email)
    reservation = reservation || Email.new()
    unprocessable = Email.reservation_used?(reservation, pos)
    unprocessable = unprocessable || Email.reserved?(reservation)

    unless unprocessable do
      stream_name = EspEx.StreamName.new("email", email)
      expected_version = EspEx.MessageStore.to_expected_version(version)

      %Email.Events.Reserved{user_id: id, time: time, reservation_number: pos}
      |> EspEx.Event.to_raw_event(stream_name)
      |> EspEx.RawEvent.caused_by(old_raw)
      |> MessageStore.write!(expected_version)
    end
  end

  def handle(%Commands.Close{user_id: id, time: time}, old_raw, _) do
    {user, version} = User.Store.fetch(id)

    unless user == nil || User.closed?(user) do
      stream_name = EspEx.StreamName.new("user", id)
      expected_version = EspEx.MessageStore.to_expected_version(version)

      %User.Events.Closed{time: time}
      |> EspEx.Event.to_raw_event(stream_name)
      |> EspEx.RawEvent.caused_by(old_raw)
      |> MessageStore.write!(expected_version)
    end
  end
end
