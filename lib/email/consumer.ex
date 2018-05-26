defmodule Email.Consumer do
  use EspEx.Consumer.Postgres,
    event_transformer: Email.Events,
    stream_name: EspEx.StreamName.new("email")

  use EspEx.Handler

  alias Email.Events
  alias BrokenStore, as: MessageStore

  def handle(
        %Events.Reserved{user_id: id} = reserved,
        %{stream_name: %{identifier: email}} = old_raw,
        _
      ) do
    stream_name = EspEx.StreamName.new("user", id)
    {user, version} = User.Store.fetch(id)

    unless User.signed_up?(user) do
      expected_version = EspEx.MessageStore.to_expected_version(version)

      %User.Events.SignedUp{id: id, email: email, time: reserved.time}
      |> EspEx.Event.to_raw_event(stream_name)
      |> EspEx.RawEvent.caused_by(old_raw)
      |> MessageStore.write!(expected_version)
    end
  end

  def handle(
        %Events.Released{user_id: id},
        %{stream_name: %{identifier: email}},
        _
      ) do
    IO.puts("User #{id} closed his account, #{email} is now free again")
  end
end
