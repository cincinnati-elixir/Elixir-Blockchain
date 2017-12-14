defmodule Parser.CLI do
  # To run from Windows cmd line using escript executable:
  #   escript parser -h
  
  @moduledoc """
  Parse command-line arguments and call
  appropriate functions.
  """

  import Parser 

  def main(argv) do
    argv
    |> parse_args
    |> parse
  end    

  @doc """
  Values for 'argv':
    --help: returns :help (to call help)
    -h or --header: returns :header (to parse blockchain headers)
    -b or --block: returns :block (to parse full blockchain blocks)
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean, header: :boolean, block: :boolean], 
                                     aliases: [h: :header, b: :block])
    case parse do
      { [ help: true ],_,_} -> :help
      { [ header: true ],_,_} -> :header
      { [ block: true ],_,_} -> :block
      _ -> :help
    end    
  end

  def parse(:help) do
    IO.puts """
    usage: Parser <switch>
    --help to get this message
    -h or -header to parse only blockchain headers
    -b or --block to parse full blockchain blocks
    """
    System.halt(0)
  end

  def parse(:header) do
    Parser.runh
  end

end