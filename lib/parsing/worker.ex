defmodule Parsing.Worker do
  @doc """
  process worker
  """
  use GenServer
  require Logger
  alias Parsing.Core.PageScraping

  @spec start_link(binary) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(name) when is_binary(name), do:
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  @spec init(any) :: {:ok, any}
  def init(name) do
    Logger.info("start process: #{name}")
    send(self(), {:set_state, name})
    {:ok, name}
  end

  @spec via_tuple(String.t()) :: {:via, Registry, {Registry.Worker, String.t()}}
  def via_tuple(name), do: {:via, Registry, {Registry.Worker, name}}

  def handle_info({:set_state, name}, _state_data) do
    Logger.info("test")
    {:noreply, name}
  end

  @spec start_scraping({:via, atom, any}, String.t(), Integer.t()) :: :ok
  def start_scraping(name_proc, alphabet_letter, display_start) do
    GenServer.cast(name_proc, {:start_scraping, alphabet_letter, display_start})
  end

  def handle_cast({:start_scraping, alphabet_letter, display_start}, state) do
    PageScraping.get_page(alphabet_letter, display_start)
    Logger.info("end work #{state}")
    {:noreply, state}
  end
end
