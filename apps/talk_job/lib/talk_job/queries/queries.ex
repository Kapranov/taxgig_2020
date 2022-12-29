defmodule TalkJob.Queries do
  @moduledoc """
  Ecto queries.
  """

  import Ecto.Query

  alias TalkJob.Repo

  @type word() :: String.t()

  @doc """
  Retrurn list of the integer by all records when is_read is false

  ## Example

      iex> struct_a = TalkJob.Talk.Room
      iex> struct_b = TalkJob.Talk.Message
      iex> room_id = FlakeId.get
      iex> current_user = Core.Repo.get_by(Core.Accounts.User, email: "client@gmail.com")
      iex> aggregate_for_room(struct_a, struct_b, room_id, current_user)
      []
  """
  @spec aggregate_for_room(map, map, String.t(), String.t()) :: [integer] | []
  def aggregate_for_room(struct_a, struct_b, room_id, current_user) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: cu.room_id == ^room_id,
        where: cu.recipient_id == ^current_user.id,
        where: c.id == cu.room_id,
        where: cu.is_read == false,
        select: count(cu.id),
        group_by: cu.id
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Retrurn list of the integer by all records when is_read is true

  ## Example

      iex> struct_a = TalkJob.Talk.Room
      iex> struct_b = TalkJob.Talk.Message
      iex> room_id = FlakeId.get
      iex> aggregate_for_message_is_read(struct_a, struct_b, room_id)
      []
  """
  @spec aggregate_for_message_is_read(map, map, String.t()) :: [integer] | []
  def aggregate_for_message_is_read(struct_a, struct_b, room_id) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: cu.room_id == ^room_id,
        where: c.id == cu.room_id,
        where: cu.is_read == false,
        select: count(cu.id),
        group_by: cu.id
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Retrurn all records with 3 items

  ## Example

      iex> struct = TalkJob.Talk.Room
      iex> row = :user_id
      iex> id  = current_user.id
      iex> by_list(struct, row, id)
      []
  """
  @spec by_list(map, atom, String.t()) :: Ecto.Query.t()
  def by_list(struct, row, id) do
    try do
      Repo.all(
        from c in struct,
        where: field(c, ^row) == ^id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end
end
