defmodule Core.Analyzes do
  @moduledoc """
  Analyze's Services.
  """

  @type word() :: String.t()

  @spec total_all(word) :: [%{atom => word, atom => integer | float}]
  def total_all(id) do
    id
  end

  @spec total_match(word) :: [%{atom => word, atom => integer}]
  def total_match(id) do
    id
  end

  @spec total_price(word) :: [%{atom => word, atom => integer}]
  def total_price(id) do
    id
  end

  @spec total_value(word) :: [%{atom => word, atom => float}]
  def total_value(id) do
    id
  end
end
