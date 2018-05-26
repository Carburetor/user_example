defmodule Email.Consumer do
  use EspEx.Consumer.Postgres,
    event_transformer: Email.Events,
    stream_name: EspEx.StreamName.new("email")

  use EspEx.Handler

  alias Email.Events, as: Event
  alias BrokenStore, as: MessageStore

  def handle(
        %Event.Reserved{user_id: id} = reserved,
        %{stream_name: %{identifier: email}},
        _
      ) do
    stream_name = EspEx.StreamName.new("user", id)
    {user, version} = User.Store.fetch(id)

    unless User.signed_up?(user) do
      expected_version = EspEx.MessageStore.to_expected_version(version)

      %User.Events.SignedUp{email: email, time: reserved.time}
      |> EspEx.Event.to_raw_event(stream_name)
      |> MessageStore.write!(expected_version)
    end
  end
end
