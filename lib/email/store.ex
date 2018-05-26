defmodule Email.Store do
  use EspEx.Store,
    message_store: EspEx.MessageStore.Postgres,
    entity_builder: Email,
    event_transformer: Email.Events,
    projection: Email.Projection,
    stream_name: EspEx.StreamName.new("email")
end
