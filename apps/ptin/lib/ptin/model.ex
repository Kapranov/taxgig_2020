defmodule Ptin.Model do
  @moduledoc """
  Extention Ecto.* for schemas
  """

   alias Ptin.Repo

   defmacro __using__(_) do
     quote do
       use Ecto.Schema
       import Ecto.Changeset
       import Ecto.Query

       @name __MODULE__

       @primary_key {:id, :binary_id, autogenerate: true}
       @foreign_key_type :binary_id
       @timestamps_opts [type: :utc_datetime, usec: true]

       @spec create(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
       def create(attrs) do
         attrs
         |> changeset()
         |> Repo.insert()
       end

       @spec changeset(map()) :: Ecto.Changeset.t()
       def changeset(attrs) do
         @name.__struct__()
         |> changeset(attrs)
       end
     end
   end
end
