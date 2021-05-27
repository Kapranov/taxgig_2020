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

  def map_response(response, :item) do
    Jason.decode!(response)
  end

  def map_response(response, :sandbox) do
    Jason.decode!(response)
  end

  def map_response(response, :transactions) do
    Jason.decode!(response)
  end

  def map_response(response, :accounts) do
    Jason.decode!(response)
  end

  def map_response(%{"item" => item} = response, :item) do
    new_response = response |> Map.take(["request_id"]) |> Map.merge(item)
    Jason.decode!(new_response)
  end

  def map_response(%{"public_token" => _} = response, :sandbox) do
    response
    |> Map.take(["public_token", "expiration", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  def map_response(%{"access_token" => _} = response, :item) do
    response
    |> Map.take(["access_token", "item_id", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end
end
