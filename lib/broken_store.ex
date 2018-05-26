defmodule BrokenStore do
  alias EspEx.MessageStore.Postgres

  use EspEx.MessageStore

  alias EspEx.StreamName
  alias EspEx.RawEvent
  alias EspEx.RawEvent.Metadata

  @impl EspEx.MessageStore
  def write!(raw_event, expected_version \\ nil) do
    # maybe_raise!
    Postgres.write!(raw_event, expected_version)
  end

  @impl EspEx.MessageStore
  def write_batch!(raw_events, stream_name, expected_version \\ nil) do
    # maybe_raise!
    Postgres.write_batch!(raw_events, stream_name, expected_version)
  end

  @impl EspEx.MessageStore
  defdelegate read_last(stream_name), to: Postgres

  @impl EspEx.MessageStore
  defdelegate read_batch(stream_name, position \\ 0, batch_size \\ 10), to: Postgres

  @impl EspEx.MessageStore
  defdelegate read_version(stream_name), to: Postgres

  @impl EspEx.MessageStore
  defdelegate listen(stream_name, opts \\ []), to: Postgres

  @impl EspEx.MessageStore
  defdelegate unlisten(ref, opts \\ []), to: Postgres

  defp maybe_raise! do
    if Enum.random(1..4) != 4 do
      raise BrokenStore.FakeError, message: "Unlucky crash"
    end
  end
end
