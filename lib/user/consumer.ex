defmodule User.Consumer do
  use EspEx.Consumer.Postgres,
    event_transformer: User.Events,
    stream_name: EspEx.StreamName.new("user")

  use EspEx.Handler

  alias User.Events
  alias BrokenStore, as: MessageStore

  def handle(%Events.SignedUp{}, %{stream_name: %{identifier: id}}, _) do
    {user, _} = User.Store.fetch(id)
    IO.puts("New user signed up!")
    IO.inspect(user)
  end

  def handle(
        %Events.Closed{time: time},
        %{stream_name: %{identifier: id}} = old_raw,
        _
      ) do
    {user, _} = User.Store.fetch(id)
    %{email: email} = user
    {email_reservation, _} = Email.Store.fetch(email)

    unless Email.released?(email_reservation) do
      stream_name = EspEx.StreamName.new("email", email)

      %Email.Events.Released{user_id: id, time: time}
      |> EspEx.Event.to_raw_event(stream_name)
      |> EspEx.RawEvent.caused_by(old_raw)
      |> MessageStore.write!()
    end
  end
end
