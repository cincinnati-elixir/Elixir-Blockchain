defmodule Parser do
  @moduledoc """
  Documentation for Parser.
  """
  @doc """
  ## Examples
  """
 
  # parse blockchain
  def run do
   #Parser.read_blocks_dir
   # |> Parser.process_block_files
   IO.puts("not implemented")
  end

  # parse blockchain headers only
  def runh do
   read_blocks_dir
    |> process_block_files
  end

  def read_blocks_dir do
    #Path.wildcard("C:/Users/ken.baum/Documents/BitCoin/blocks/*.dat")
    Path.wildcard("blocks/*.dat")
  end

  def process_block_files(files) do
    for f <- files do
      read_block_file(f)
      |> strip_sentinel
      |> process_block_file(0)
    end
  end


  def read_block_file(name) do
    case File.read name do
      {:ok, contents} -> contents
      {:error, reason} -> IO.puts("There was an error: #{reason}")
    end
  end

  def convert_to_charlist(binaryString) do
    String.to_charlist(binaryString)
  end

  def process_block_file("", next_block_number) do
    IO.puts("**************************************")
    IO.puts("End of File")
    IO.puts("**************************************")
    IO.puts(" ")
    IO.puts(" ")  
  end
  
  def process_block_file(contents, next_block_number) do
    <<block_size :: little-size(32), 
      block :: binary-size(block_size), 
      remaining :: little-binary>> = contents
    IO.puts("**********************************************************************************************************************")
    IO.puts("Block Number: #{next_block_number}")
    IO.puts("Block Size: #{block_size}")
    <<header :: binary-size(80), 
      transactions :: little-binary>> = block
    IO.puts("Hash of Header is: #{:crypto.hash(:sha256,:crypto.hash(:sha256, header)) |> String.reverse |> Base.encode16}")
      <<version :: little-size(32), 
        prev_hash :: binary-size(32), 
        merkle_root :: binary-size(32),
        time :: little-size(32),
        nBits :: little-size(32),
        nonce :: little-size(32)>> = header
      modified_prev_hash = prev_hash |> Base.encode16
      IO.puts("Version: #{version}")
      IO.puts("Previous Block Header Hash: #{modified_prev_hash}")
      IO.puts("Merkle Root: #{inspect merkle_root}")
      IO.puts("Time: #{time}")
      IO.puts("Difficulty: #{nBits}")
      IO.puts("Nonce: #{nonce}")
    #  #IO.puts("Transactions: #{transactions}")
    IO.puts("**********************************************************************************************************************")
    IO.puts(" ")
    #remaining
    #IO.puts("Remaining: #{remaining}")
    strip_sentinel(remaining)
    |> process_block_file(next_block_number + 1)   

  end

  def strip_sentinel("") do
    ""
  end

  def strip_sentinel(contents) do
    << 0xF9, 0xBE, 0xB4, 0xD9,  remaining :: binary>> = contents
    remaining
  end

  def get_block_size(block_size) do
    Integer.parse(Integer.to_string(block_size, 16), 16)
  end

end
