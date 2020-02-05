defmodule Ptin.Context do
  @moduledoc """
  Extention Ecto.* for context
  """

  defmacro __using__(_) do
    quote do
      alias Ptin.Repo
      alias Ecto.Changeset
      alias Ecto.Multi

      import Ecto.Query

      @type t :: __MODULE__.t()
      @type reason :: any
      @type success_tuple :: {:ok, t}
      @type error_tuple :: {:error, reason}
      @type result :: success_tuple | error_tuple
    end
  end
end
