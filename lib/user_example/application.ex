defmodule UserExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      %{
        id: Email.Consumer,
        start: {GenServer, :start_link, [Email.Consumer, nil]}
      },
      %{
        id: User.Consumer,
        start: {GenServer, :start_link, [User.Consumer, nil]}
      },
      %{
        id: User.Commands.Consumer,
        start: {GenServer, :start_link, [User.Commands.Consumer, nil]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: User.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
