defmodule Chat.Token do
  @moduledoc """
  Custom token implementation using EntropyString behaviour and Phoenix Token.
  """

  use EntropyString

  alias Chat.Token

  @chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  @max String.length(@chars)-1

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(chars_split()) | acc]
    end) |> Enum.join("")
  end

  def flip(flips), do: Token.random(flips)

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

#  alias Phoenix.Token
#  alias Chat.Web.Router
#
#  @token_salt "gL33HZpG"
#
#  @impl true
#  def sign(data, opts \\ []) do
#    Token.sign(Router, @token_salt, data, opts)
#  end
#
#  @impl true
#  def verify(token, opts \\ []) do
#    Token.verify(Router, @token_salt, token, opts)
#  end
end
