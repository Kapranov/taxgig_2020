defmodule Core.Model do
  @moduledoc """
  """

   alias Core.Repo

   defmacro __using__(_) do
     quote do
       use Ecto.Schema
       import Ecto.Changeset
       import Ecto.Query

       @name __MODULE__

       @primary_key {:id, :binary_id, autogenerate: true}
       @foreign_key_type :binary_id
       @timestamps_opts [type: :utc_datetime, usec: true]


       def create(attrs) do
         attrs
         |> changeset()
         |> Repo.insert()
       end

       def changeset(attrs) do
         @name.__struct__()
         |> changeset(attrs)
       end
     end
   end
end
