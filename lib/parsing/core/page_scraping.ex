defmodule Parsing.Core.PageScraping do
  @doc """
  Core module
  """
  require Logger
  alias Parsing.Core.CsvWriter

  @proxy_list [
    {:proxy, "64.225.106.230:8080"},

    {:proxy, "182.253.92.17:8080"},
    {:proxy, "162.212.157.35:8080"},
    {:proxy, "64.226.121.167:8080"},
    {:proxy, "64.225.106.230:8080"},
    {:proxy, "103.156.249.119:8080"},
    {:proxy, "64.225.106.230:8080"},
    {:proxy, "64.225.106.230:8080"},
    {:proxy, "157.245.83.197:8080"},
    {:proxy, "14.232.243.13:8080"},
  ]

  @spec get_page(String.t(), Integer.t(), Integer.t()) :: nil
  def get_page(alphabet_letter, display_start \\ 0, total_records \\ 100_000) do
    proxy = Enum.random(@proxy_list)
    Logger.info("start parsing on letter: #{alphabet_letter}, start on: #{display_start}, proxy: #{inspect(proxy)}")
    options = [proxy]
    url =  "https://www.metal-archives.com/browse/ajax-letter/l/#{alphabet_letter}/json/1?sEcho=1&iColumns=4&sColumns=&iDisplayStart=#{display_start}&iDisplayLength=500&mDataProp_0=0&mDataProp_1=1&mDataProp_2=2&mDataProp_3=3&iSortCol_0=0&sSortDir_0=asc&iSortingCols=1&bSortable_0=true&bSortable_1=true&bSortable_2=true&bSortable_3=false&_=1685634314918"
    case HTTPoison.get(url, [], options) do
      {:ok, response} ->
        get_data(response.body) |> bands(alphabet_letter, display_start)
      {:error, error} ->
        Logger.info("wrong request #{inspect(error)}")
    end
  end

  @spec bands(map(), String.t(), Integer.t()) :: nil
  def bands(data, alphabet_letter, display_start) do
    Enum.each(Map.get(data, "aaData"),  fn data -> parsing_data(data, alphabet_letter) end)

    total_records = Map.get(data, "iTotalRecords")
    if display_start <= total_records do
      #рекурсивно вызываем до тех пор пока количество групп не сравняется
      get_page(alphabet_letter, display_start + 500, total_records)
    end
  end

  @spec parsing_data(map(), String.t()) :: :ok
  defp parsing_data([url, contry, style, split_up], alphabet_letter) do
    try do
      {:ok, html} = Floki.parse_fragment(url)
      {:ok, html_sp} = Floki.parse_fragment(split_up)
      [
        Floki.find(html, "a") |> Floki.text(),
        Floki.attribute(html, "href"),
        contry,
        style,
        Floki.find(html_sp, "span") |> Floki.text()
      ]
      |> CsvWriter.write_to_file(alphabet_letter)
    rescue
      e -> Logger.error(inspect(e))
    end
  end

  defp get_data(response_body) do
    {:ok, data} = Jason.decode(response_body)
    data
  end
end
