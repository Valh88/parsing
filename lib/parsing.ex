defmodule Parsing do
  @moduledoc false

  alias Parsing.WorkerSupervisor
  alias Parsing.Worker

  @proccess_alphabet "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,T,U,V,W,X,Y,Z"


  @spec start_parsing :: none
  def start_parsing do
    Enum.each(String.split(@proccess_alphabet, ","), fn letter -> start_proccess(letter) end)
  end

  @spec start_proccess(String.t()) :: none
  def start_proccess(letter) do
    {:ok, pid_proccess} = Parsing.WorkerSupervisor.start_child(letter)
    Worker.start_scraping(pid_proccess, letter, 0)
    :timer.sleep(100)
  end
end
