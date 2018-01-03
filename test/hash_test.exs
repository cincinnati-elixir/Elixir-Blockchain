defmodule HashTest do
  use ExUnit.Case

  describe "magic number" do
    test "good" do
        {:ok, block} = File.read "blocks/blk00000.dat"
        assert {:ok, _} = Block.parse(block)
    end

    test "bad" do
        assert {:error, _} = Block.parse(<<0,0,0,0,0>>)
    end  
  end

  describe "parsing" do
    setup do
      {:ok, block} = File.read "blocks/blk00000.dat"
      {:ok, list_size = [block1, block2 | _rest]} = Block.parse(block)
      {:ok, %{list_size: length(list_size), structure: block1, next_structure: block2}}
    end

    test "number of blocks", %{list_size: list_size} do
      assert list_size == 119961
    end

    test "block size", %{structure: %{block_size: block_size}} do
      assert block_size == 285
    end
    
    test "version", %{structure: %{version: version}} do
      assert version == 1
    end

    test "previous", %{structure: %{previous: previous}} do
      assert previous == <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>
    end

    test "next hash same as previous", %{structure: %{block_hash: block_hash}, next_structure: %{previous: previous}} do
      assert block_hash == previous
    end
  end
end

defmodule Block do
  defstruct [:block_size, :block_hash, :version, :previous]

  def parse(blocks), do: _parse(blocks, [])

  @magic_number <<0xF9, 0xBE, 0xB4, 0xD9>>
  defp _parse(<<>>, blocks), do: {:ok, Enum.reverse(blocks)}
  defp _parse(@magic_number <> blocks, parsed_blocks) do
    <<block_size :: little-size(32), 
      block::binary-size(block_size),
      remainder::little-binary>> = blocks
    new_block = parse_block(block)

    _parse(remainder, [new_block | parsed_blocks]) 
  end
  defp _parse(_, _), do: {:error, "Bad magic number"}

  defp parse_block(block) do
      <<version :: little-size(32),
      previous :: binary-size(32),
      _remainder :: binary>> = block

      <<header :: binary-size(80), _remaining :: binary>> = block

      block_hash = :crypto.hash(:sha256,:crypto.hash(:sha256, header))
    #    merkle_root :: binary-size(32),
    #    time :: little-size(32),
    #    nBits :: little-size(32),
    #    nonce :: little-size(32)>> = header
    %__MODULE__{block_size: byte_size(block), block_hash: block_hash, version: version, previous: previous}
  end
end