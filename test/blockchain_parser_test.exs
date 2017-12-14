defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "block file read" do
    assert(String.length(Parser.read_block_file("blocks/blk00000.dat"))>0)
  end
end
