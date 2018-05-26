defmodule CurrentTime do
  def now do
    DateTime.utc_now()
    |> DateTime.to_naive()
  end
end
