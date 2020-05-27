defmodule Chat.TokenGenerate do
  @moduledoc false

  use EntropyString

  alias Chat.TokenGenerate

  @chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  @max String.length(@chars)-1

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(chars_split()) | acc]
    end) |> Enum.join("")
  end

  def flip(flips), do: TokenGenerate.random(flips)

  def random_string(len) do
    list = for _ <- :lists.seq(1,len), do: random_char()
    List.foldl(list, "", fn(e,acc) -> acc <> e end)
  end

  def ets_token do
    token = string_of_length(100)
    :ets.new(:configuration, [:named_table, :set, :protected])
    :ets.insert(:configuration, {:token, token})
    [token: data] = :ets.lookup(:configuration, :token)
    data
  end

  defp chars_split(data \\ @chars) do
    data
    |> String.split("")
  end

  defp random_char do
    ndx = Enum.random 0..@max
    String.slice @chars, ndx..ndx
  end
end
