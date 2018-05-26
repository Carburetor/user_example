defmodule User.Consumer do
  use EspEx.Consumer.Postgres,
    event_transformer: User.Events,
    stream_name: EspEx.StreamName.new("user")

  use EspEx.Handler

  alias User.Events, as: Event
  alias BrokenStore, as: MessageStore

  def handle(%Event.SignedUp{}, %{stream_name: %{identifier: id}}, _) do
    {user, _} = User.Store.fetch(id)
    IO.puts("New user signed up!")
    IO.inspect(user)
  end
end
