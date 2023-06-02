defmodule Parsing.Core.CsvWriter do
  @doc """
   Write
  """
  @path "data"
  
  def write_to_file(data, alphabet_letter) do
    f = File.open!("#{@path}/#{alphabet_letter}.csv", [:append, :utf8])
    IO.write(f, CSVLixir.write_row(data))
    File.close(f)

    # with :ok <- File.mkdir_p(Path.dirname("#{@path}/#{display_start}.csv")) do
    #   f = File.open!(Path.dirname("#{@path}/#{alphabet_letter}/#{display_start}.csv"), [:append, :utf8])
    #   IO.write(f, CSVLixir.write_row(data))
    #   File.close(f)
    # end

  end
end
