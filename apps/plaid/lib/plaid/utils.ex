defmodule Plaid.Utils do
  @moduledoc """
  Utility functions.
  """

  @type response :: %{required(String.t()) => any}
  @type endpoint :: atom

  @doc """
  Handles Plaid response and maps to the correct data structure.
  """
  def handle_resp({:ok, %HTTPoison.Response{status_code: code} = resp}, endpoint) when code in 200..201 do
    {:ok, map_response(resp.body, endpoint)}
  end

  def handle_resp({:ok, %HTTPoison.Response{} = resp}, _endpoint) do
    {:error, Jason.decode!(resp.body)}
  end

  def handle_resp({:error, %HTTPoison.Error{} = error}, _endpoint) do
    {:error, error}
  end

  @doc """
  Maps an endpoint's response to the corresponding internal data structure.
  """
  def map_response(response, :link) do
    Jason.decode!(response)
  end
end
