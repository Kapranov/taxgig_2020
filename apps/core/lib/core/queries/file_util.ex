defmodule Core.Queries.FileUtil do
  @moduledoc false

  def uri_encode(url) do
    url
    |> String.replace("+", " ")
    |> URI.encode(&valid_path_char?/1)
  end

  def valid_path_char?(?\s), do: false
  def valid_path_char?(?/), do: true
  def valid_path_char?(c) do
    URI.char_unescaped?(c) && !URI.char_reserved?(c)
  end

  def hash_sha256(data) do
    :sha256
    |> :crypto.hash(data)
    |> bytes_to_hex
  end

  def hmac_sha256(key, data) do
    :crypto.mac(:hmac, :sha256, key, data)
  end

  def bytes_to_hex(bytes) do
    bytes
    |> Base.encode16(case: :lower)
  end

  def service_name(service), do: service |> Atom.to_string

  def method_string(method) do
    method
    |> Atom.to_string
    |> String.upcase
  end
end
