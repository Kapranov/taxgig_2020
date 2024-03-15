defmodule Core.MIME do
  @moduledoc """
  Returns the mime-type of a binary and optionally a normalized file-name.
  """
  @default "application/octet-stream"
  @read_bytes 35

  @spec file_mime_type(String.t()) ::
          {:ok, content_type :: String.t(), filename :: String.t()} | {:error, any()} | :error
  def file_mime_type(path, filename) do
    with {:ok, content_type} <- file_mime_type(path), filename <- fix_extension(filename, content_type) do
      {:ok, content_type, filename}
    end
  end

  @spec file_mime_type(String.t()) :: {:ok, String.t()} | {:error, any()} | :error
  def file_mime_type(filename) do
    File.open(filename, [:read], fn f ->
      check_mime_type(IO.binread(f, @read_bytes))
    end)
  end

  @spec bin_mime_type(binary(), String.t()) :: {:ok, String.t(), String.t()}
  def bin_mime_type(binary, filename) do
    with {:ok, content_type} <- bin_mime_type(binary), filename <- fix_extension(filename, content_type) do
      {:ok, content_type, filename}
    end
  end

  @spec bin_mime_type(binary()) :: {:ok, String.t()} | :error
  def bin_mime_type(<<head::binary-size(@read_bytes), _::binary>>) do
    {:ok, check_mime_type(head)}
  end

  def bin_mime_type(_), do: :error

  @spec mime_type(binary()) :: {:ok, String.t()}
  def mime_type(<<_::binary>>), do: {:ok, @default}

  @spec fix_extension(String.t(), String.t()) :: String.t()
  defp fix_extension(filename, content_type) do
    parts = String.split(filename, ".")

    new_filename =
      if length(parts) > 1 do
        parts
        |> Enum.drop(-1)
        |> Enum.join(".")
      else
        Enum.join(parts)
      end

    cond do
      content_type == "application/octet-stream" ->
        filename

      ext = List.first(MIME.extensions(content_type)) ->
        new_filename <> "." <> ext

      true ->
        extension = content_type |> String.split("/") |> List.last()

        Enum.join([new_filename, extension], ".")
    end
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>) do
    "image/png"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<0x47, 0x49, 0x46, 0x38, _, 0x61, _::binary>>) do
    "image/gif"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<0xFF, 0xD8, 0xFF, _::binary>>) do
    "image/jpg"
  end

  # 696D6167652F68656966
  # <<head::binary-size(10), rest::binary>> = "image/heif"

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<0x1A, 0x45, 0xDF, 0xA3, _::binary>>) do
    "video/webm"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<0x00, 0x00, 0x00, _, 0x66, 0x74, 0x79, 0x70, _::binary>>) do
    "video/mp4"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<0x49, 0x44, 0x33, _::binary>>) do
    "audio/mpeg"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<255, 251, _, 68, 0, 0, 0, 0, _::binary>>) do
    "audio/mpeg"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(
        <<0x4F, 0x67, 0x67, 0x53, 0x00, 0x02, 0x00, 0x00, _::size(160), 0x80, 0x74, 0x68, 0x65,
          0x6F, 0x72, 0x61, _::binary>>
       ) do
    "video/ogg"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<0x4F, 0x67, 0x67, 0x53, 0x00, 0x02, 0x00, 0x00, _::binary>>) do
    "audio/ogg"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<"RIFF", _::binary-size(4), "WAVE", _::binary>>) do
    "audio/wav"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<"RIFF", _::binary-size(4), "WEBP", _::binary>>) do
    "image/webp"
  end

  @spec check_mime_type(binary()) :: String.t()
  defp check_mime_type(<<"RIFF", _::binary-size(4), "AVI.", _::binary>>) do
    "video/avi"
  end

  @spec check_mime_type(any) :: String.t()
  defp check_mime_type(_) do
    @default
  end
end
