defmodule ParsingTest do
  use ExUnit.Case
  doctest Parsing

  test "greets the world" do
    assert Parsing.hello() == :world
  end
end
