defmodule User.Store do
  use EspEx.Store,
    message_store: EspEx.MessageStore.Postgres,
    entity_builder: User,
    event_transformer: User.Events,
    projection: User.Projection,
    stream_name: EspEx.StreamName.new("user")
end
