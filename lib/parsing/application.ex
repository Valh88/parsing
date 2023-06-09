defmodule Parsing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Parsing.Worker.start_link(arg)
      # {Parsing.Worker, arg}
      {DynamicSupervisor, strategy: :one_for_one, name: Parsing.WorkerSupervisor},
      {Registry, keys: :unique, name: Registry.Worker}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Parsing.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
