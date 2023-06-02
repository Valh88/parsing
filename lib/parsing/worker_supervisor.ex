defmodule Parsing.WorkerSupervisor do
  @moduledoc """
      Worker Supervisor to support dynamic workers
  """

  use DynamicSupervisor
  require Logger
  alias Parsing.Worker

  def start_link(_options) do
    Logger.debug("Starting the Worker Supervisor")
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  @impl true
  @spec init(any) ::
          {:ok,
           %{
             extra_arguments: list,
             intensity: non_neg_integer,
             max_children: :infinity | non_neg_integer,
             period: pos_integer,
             strategy: :one_for_one
           }}
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end

  @spec start_child(any) :: :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start_child(name) do
    spec = {Worker, name}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
