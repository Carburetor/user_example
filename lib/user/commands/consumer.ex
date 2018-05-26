defmodule User.Commands.Consumer do
  use EspEx.Consumer.Postgres,
    event_transformer: User.Commands,
    stream_name: EspEx.StreamName.new("user", nil, ["command"])

  use EspEx.Handler

  alias User.Commands
  alias BrokenStore, as: MessageStore

  def handle(%Commands.SignUp{email: email, time: time}, old_raw, _) do
    {email_reservation, version} = Email.Store.fetch(email)

    unless Email.reserved?(email_reservation) do
      stream_name = EspEx.StreamName.new("email", email)
      expected_version = EspEx.MessageStore.to_expected_version(version)

      %Email.Events.Reserved{user_id: UUID.uuid4(), time: time}
      |> EspEx.Event.to_raw_event(stream_name)
      |> EspEx.RawEvent.caused_by(old_raw)
      |> MessageStore.write!(expected_version)
    end
  end
end
