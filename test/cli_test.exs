defmodule CLITest do
  use ExUnit.Case
  doctest Parser

  import Parser.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with --help option" do
    assert parse_args(["--help", "anything"]) == :help
  end

  test ":header returned by option parsing with -h and --header options" do
    assert parse_args(["-h", "anything"]) == :header
    assert parse_args(["--header", "anything"]) == :header
  end

  test ":block returned by option parsing with -b and --block options" do
    assert parse_args(["-b", "anything"]) == :block
    assert parse_args(["--block", "anything"]) == :block
  end


end