defmodule Core.Queries do
  @moduledoc """
  Ecto queries.
  """

  import Ecto.Query

  alias Core.{
    Accounts.Platform,
    Accounts.ProRating,
    Accounts.User,
    Analyzes,
    Repo,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @doc """
  Countable records by roles

  ## Example.

      iex> count_by_roles(Core.Accounts.User, false)
      [2]
      iex> count_by_roles(Core.Accounts.User, true)
      []

  """
  @spec count_by_roles(struct(), boolean) :: [integer()] | []
  def count_by_roles(struct, role) do
    try do
      Repo.all(
        from c in struct,
        where: fragment("?::boolean", c.role) == ^role,
        select: count(c.id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Countable records by roles and time steps

  ## Example.

      iex> {:ok, start_date} = Date.new(2023, 12, 17)
      iex> end_date = Date.add(start_date, 7)
      iex> count_by_roles_timestamp(Core.Accounts.User, false, start_date, end_date)
      [2]
      iex> count_by_roles_timestamp(Core.Accounts.User, true, start_date, end_date)
      []

  """
  @spec count_by_roles_timestamp(struct(), boolean, struct(), struct()) :: [integer()] | []
  def count_by_roles_timestamp(struct, role, start_date, end_date) do
    try do
      Repo.all(
        from c in struct,
        where:
          fragment("?::date", c.inserted_at) >= ^start_date and
          fragment("?::date", c.inserted_at) <= ^end_date and
          fragment("?::boolean", c.role) == ^role,
        select: count(c.id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Countable records by model

  ## Example.

      iex> count_by_model(Core.Accounts.User)
      [2]

  """
  @spec count_by_model(struct()) :: [integer()] | []
  def count_by_model(struct) do
    try do
      Repo.all(
        from c in struct,
        select: count(c.id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Countable records by model with time steps

  ## Example.

      iex> {:ok, start_date} = Date.new(2023, 12, 17)
      iex> end_date = Date.add(start_date, 7)
      iex> count_by_model_timestamp(Core.Accounts.User, start_date, end_date)
      [2]

  """
  @spec count_by_model_timestamp(struct(), struct(), struct()) :: [integer()] | []
  def count_by_model_timestamp(struct, start_date, end_date) do
    try do
      Repo.all(
        from c in struct,
        where: fragment("?::date", c.inserted_at) >= ^start_date and fragment("?::date", c.inserted_at) <= ^end_date,
        select: count(c.id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Retrurn list of the integer by all records when is_read is false

  ## Example

      iex> struct_a = Core.Talk.Room
      iex> struct_b = Core.Talk.Message
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
  Retrurn counts by all records when is_read is false

  ## Example

      iex> struct_a = Core.Talk.Room
      iex> struct_b = Core.Talk.Message
      iex> room_id = FlakeId.get
      iex> aggregate_unread_msg(struct_a, struct_b, room_id)
      []
  """
  @spec aggregate_unread_msg(map, map, String.t()) :: integer
  def aggregate_unread_msg(struct_a, struct_b, room_id) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: c.id == cu.room_id,
        where: cu.room_id == ^room_id,
        where: cu.is_read == false,
        select: count(cu.id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Return counts by total number of unread `messages` via `userId`.

  Take `room.userId` and `room.message` then find all `messages` where `room.userId`
  is `message.recipient` then count all matching `messages` where `message.isRead`
  is `false` and return total number of unread `messages`.

  ## Examples.

      iex> struct_a = Core.Talk.Room
      iex> struct_b = Core.Talk.Message
      iex> user_id = struct_a.user_id
      iex> aggregate_unread_msg_by_user(struct_a, struct_b, user_id)
      1

  """
  @spec aggregate_unread_msg_by_user(map, map, String.t()) :: integer
  def aggregate_unread_msg_by_user(struct_a, struct_b, user_id) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: not is_nil(cu.participant_id),
        where: c.user_id == ^user_id and c.user_id == cu.recipient_id,
        where: cu.is_read == false,
        select: count(cu.id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Return counts by total number of unread `messages`via `participantId`.


  Take `room.participantId` and `room.message` then find all`messages` where
  `room.participantId` is `message.recipient` then count all matching `messages`
  where `message.isRead` is `false` and return total number of unread `messages`.

  ## Examples.

      iex> struct_a = Core.Talk.Room
      iex> struct_b = Core.Talk.Message
      iex> participantId = struct_a.user_id
      iex> aggregate_unread_msg_by_user(struct_a, struct_b, participantId)
      1

  """
  @spec aggregate_unread_msg_by_participant(map, map, String.t()) :: integer
  def aggregate_unread_msg_by_participant(struct_a, struct_b, participant_id) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: not is_nil(c.participant_id),
        where: not is_nil(cu.participant_id),
        where: c.participant_id == ^participant_id and c.participant_id == cu.recipient_id,
        where: cu.is_read == false,
        select: count(cu.id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  Retrurn all records with 2 items

  ## Example

      iex> struct = Core.Accounts.User
      iex> row = :role
      iex> value = true
      iex> by_role_list(struct, row, value)
      []

  """
  @spec by_role_list(map, atom, boolean) :: Ecto.Query.t()
  def by_role_list(struct, row, value) do
    try do
      Repo.all(
        from c in struct,
        where: field(c, ^row) == ^value
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 3 items

  ## Example

      iex> struct = Core.Accounts.User
      iex> row1 = :role
      iex> row2 = :profession
      iex> val1 = true
      iex> val2 = "CPA"
      iex> by_role_list(struct, row1, val1, row2, val2)
      []

  """
  @spec by_role_list(map, atom, boolean, atom, String.t()) :: Ecto.Query.t()
  def by_role_list(struct, row1, val1, row2, val2) do
    try do
      Repo.all(
        from c in struct,
        where: field(c, ^row1) == ^val1,
        where: field(c, ^row2) == ^val2
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 6 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row1 = :role
      iex> row2 = :hero_status
      iex> val1 = true
      iex> val2 = true
      iex> by_role_list(struct_a, struct_b, row1, val1, row2, val2)
      []

  """
  @spec by_role_list(map, map, atom, boolean, atom, boolean) :: Ecto.Query.t()
  def by_role_list(struct_a, struct_b, row1, val1, row2, val2) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(c, ^row1) == ^val1,
        where: field(ct, ^row2) == ^val2
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 8 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row1 = :role
      iex> row2 = :profession
      iex> row3 = :hero_status
      iex> val1 = true
      iex> val2 = "CPA"
      iex> val3 = true
      iex> by_role_list(struct_a, struct_b, row1, val1, row2, val2, row3, val3)
      []

  """
  @spec by_role_list(map, map, atom, boolean, atom, String.t(), atom, boolean) :: Ecto.Query.t()
  def by_role_list(struct_a, struct_b, row1, val1, row2, val2, row3, val3) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(c, ^row1) == ^val1,
        where: field(c, ^row2) == ^val2,
        where: field(ct, ^row3) == ^val3
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 4 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row = :is_stuck
      iex> value = true
      iex> by_stuck_list(struct_a, struct_b, row, value)
      []

  """
  @spec by_stuck_list(map, map, atom, boolean) :: Ecto.Query.t()
  def by_stuck_list(struct_a, struct_b, row, value) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(ct, ^row) == ^value
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 6 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row1 = :is_stuck
      iex> val1 = true
      iex> row2 = :role
      iex> val2 = true
      iex> by_stuck_list(struct_a, struct_b, row1, val1, row2, val2)
      []

  """
  @spec by_stuck_list(map, map, atom, boolean, atom, boolean) :: Ecto.Query.t()
  def by_stuck_list(struct_a, struct_b, row1, val1, row2, val2) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(c, ^row2) == ^val2,
        where: field(ct, ^row1) == ^val1
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 8 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row1 = :is_stuck
      iex> val1 = true
      iex> row2 = :stuck_stage
      iex> val2 = "Blockscore"
      iex> row3 = :role
      iex> val3 = true
      iex> by_stuck_list(struct_a, struct_b, row1, val1, row2, val2, row3, val3)
      []

  """
  @spec by_stuck_list(map, map, atom, boolean, atom, String.t(), atom, boolean) :: Ecto.Query.t()
  def by_stuck_list(struct_a, struct_b, row1, val1, row2, val2, row3, val3) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(c, ^row3) == ^val3,
        where: field(ct, ^row1) == ^val1,
        where: field(ct, ^row2) == ^val2
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 6 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row1 = :is_stuck
      iex> val1 = true
      iex> row2 = :stuck_stage
      iex> val2 = "Blockscore"
      iex> by_stuck_stage_list(struct_a, struct_b, row1, val1, row2, val2)
      []

  """
  @spec by_stuck_stage_list(map, map, atom, boolean, atom, String.t()) :: Ecto.Query.t()
  def by_stuck_stage_list(struct_a, struct_b, row1, val1, row2, val2) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(ct, ^row1) == ^val1,
        where: field(ct, ^row2) == ^val2
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 4 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row = :is_banned
      iex> value = true
      iex> by_banned_list(struct_a, struct_b, row, value)
      []

  """
  @spec by_banned_list(map, map, atom, boolean) :: Ecto.Query.t()
  def by_banned_list(struct_a, struct_b, row, value) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(ct, ^row) == ^value
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 6 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> row1 = :is_banned
      iex> val1 = true
      iex> row2 = :role
      iex> val2 = true
      iex> by_banned_list(struct_a, struct_b, row1, val1, row2, val2)
      []

  """
  @spec by_banned_list(map, map, atom, boolean, atom, boolean) :: Ecto.Query.t()
  def by_banned_list(struct_a, struct_b, row1, val1, row2, val2) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: c.id == ct.user_id,
        where: field(c, ^row2) == ^val2,
        where: field(ct, ^row1) == ^val1
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 9 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> struct_c = Core.Accounts.BanReason
      iex> row1 = :is_banned
      iex> val1 = true
      iex> row2 = :reason
      iex> val2 = "Fraud"
      iex> row3 = :role
      iex> val3 = true
      iex> by_banned_list(struct_a, struct_b, struct_c, row1, val1, row2, val2, row3, val3)
      []

  """
  @spec by_banned_list(map, map, map, atom, boolean, atom, String.t(), atom, boolean) :: Ecto.Query.t()
  def by_banned_list(struct_a, struct_b, struct_c, row1, val1, row2, val2, row3, val3) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        join: cx in ^struct_c,
        where: c.id == ct.user_id,
        where: c.id == cx.user_id,
        where: field(c, ^row3) == ^val3,
        where: field(ct, ^row1) == ^val1,
        where: field(cx, ^row2) == ^val2
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 7 items

  ## Example

      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> struct_c = Core.Accounts.BanReason
      iex> row1 = :is_banned
      iex> val1 = true
      iex> row2 = :reasons
      iex> val2 = "Fraud"
      iex> by_banned_reason_list(struct_a, struct_b, struct_c, row1, val1, row2, val2)
      []

  """
  @spec by_banned_reason_list(map, map, map, atom, boolean, atom, String.t()) :: Ecto.Query.t()
  def by_banned_reason_list(struct_a, struct_b, struct_c, row1, val1, row2, val2) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        join: cx in ^struct_c,
        where: c.id == ct.user_id,
        where: c.id == cx.user_id,
        where: field(ct, ^row1) == ^val1,
        where: field(cx, ^row2) == ^val2
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 3 items

  ## Example

      iex> struct = Core.Contracts.Offer
      iex> row = :user_id
      iex> id  = current_user.id
      iex> by_list(struct, row, id)

  """
  @spec by_list(map, atom, word) :: Ecto.Query.t()
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

  @spec by_list(map, atom, word, atom, word) :: Ecto.Query.t()
  def by_list(struct, row_a, id, row_b, name) do
    try do
      Repo.all(
        from c in struct,
        where: field(c, ^row_a) == ^id,
        where: field(c, ^row_b) == ^name
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

#  @spec by_list(map, atom, atom, word, word) :: [word] | []
#  def by_list(struct, row_a, row_b, id_a, id_b) do
#    try do
#      Repo.all(
#        from c in struct,
#        where: not is_nil(field(c, ^row_a)),
#        where: not is_nil(field(c, ^row_b)),
#        where: field(c, ^row_a) == ^id_a,
#        where: field(c, ^row_b) == ^id_b
#      )
#    rescue
#      Ecto.Query.CastError -> nil
#    end
#  end

  @spec by_list(map, atom, word, atom, word, boolean) :: Ecto.Query.t()
  def by_list(struct, row_a, id, row_b, name, role) do
    try do
      Repo.all(
        from c in struct,
        where: field(c, ^row_a) == ^id,
        where: field(c, ^row_b) == ^name
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_list(map, map, atom, word, atom, word, boolean) :: Ecto.Query.t()
  def by_list(struct_a, struct_b, row_a, id, row_b, name, role) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: c.role == ^role,
        where: field(cu, ^row_a) == ^id,
        where: field(cu, ^row_b) == ^name
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 8 items

  Queries.by_list(PlaidAccount, PlaidAccountsProject, Project, :id, :project_id, :plaid_account_id, :user_id, current_user.id)

  ## Example

      iex> struct_a = Core.Plaid.PlaidAccount
      iex> struct_b = Core.Plaid.PlaidAccountsProject
      iex> struct_c = Core.Contracts.Project
      iex> row_a = :id
      iex> row_b = :project_id
      iex> row_c = :plaid_account_id
      iex> row_d = :user_id
      iex> id  = current_user.id
      iex> by_list(struct, row, id)

  """
  @spec by_list(map, map, map, atom, atom, atom, atom, String.t()) :: Ecto.Query.t()
  def by_list(struct_a, struct_b, struct_c, row_a, row_b, row_c, row_d, id) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        join: cu in ^struct_c,
        where: field(cu, ^row_d) == ^id,
        where: field(cu, ^row_a) == field(ct, ^row_b),
        where: field(c, ^row_a) == field(ct, ^row_c)
      )
      |> Repo.preload([:plaid_transactions])
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Retrurn all records with 9 items

  ## Example

      iex> struct_a = Core.Plaid.PlaidTransaction
      iex> struct_b = Core.Plaid.PlaidAccount
      iex> struct_c = Core.Plaid.PlaidAccountsProject
      iex> struct_d = Core.Contracts.Project
      iex> row_a = :user_id
      iex> row_b = :project_id
      iex> row_c = :plaid_account_id
      iex> row_d = :id
      iex> id  = current_user.id
      iex> by_list(struct, row, id)

  """
  @spec by_list(map, map, map, map, atom, atom, atom, atom, String.t()) :: Ecto.Query.t()
  def by_list(struct_a, struct_b, struct_c, struct_d, row_a, row_b, row_c, row_d, id) do
    try do
      Repo.all(
        from c in struct_a,
        join: cp in ^struct_b,
        join: ct in ^struct_c,
        join: cu in ^struct_d,
        where: field(cu, ^row_a) == ^id,
        where: field(c, ^row_c) == field(cp, ^row_d),
        where: field(cu, ^row_d) == field(ct, ^row_b)
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_list_admin(map, map, atom, word, boolean) :: Ecto.Query.t()
  def by_list_admin(struct_a, struct_b, row, id, role) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: c.role == ^role,
        where: field(cu, ^row) == ^id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec find_match(atom) :: integer | float | nil
  def find_match(row) do
    q = from r in MatchValueRelate, select: {field(r, ^row)}
    [{data}] = Repo.all(q)
    data
  end

  @doc """
  ## Example

      iex> struct = Core.Accounts.ProRating
      iex> row_a = :user_id
      iex> roe_b = :average_rating
      iex> id  = FlakeId.get()
      iex> by_pro_rating(struct, row_a, row_b, id)
      iex> [FlakeId.get()]

  """
  @spec by_pro_rating(map, atom, atom, String.t()) :: [String.t()] | nil
  def by_pro_rating(struct, row_a, row_b, id) do
    try do
      Repo.one(
        from c in struct,
        where: field(c, ^row_a) == ^id,
        where: not is_nil(field(c, ^row_b)),
        select: {field(c, ^row_a), field(c, ^row_b)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Return all User's role true via Platform of field's hero status

  ## Example
      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> struct_c = Core.Service.IndividualTaxReturn
      iex> role = true
      iex> row_a = :role
      iex> row_b = :id
      iex> row_c = :user_id
      iex> row_d = :hero_status
      iex> row_h = :email
      iex> by_hero_status(struct_a, struct_b, struct_c, role, row_a, row_b, row_c, row_d, row_h)
      [{"some text"}, {"some text"}]
  """
  @spec by_hero_status(map, map, map, boolean, atom, atom, atom, atom, atom) :: [{word, word}] | nil
  def by_hero_status(struct_a, struct_b, struct_c, role, row_a, row_b, row_c, row_d, row_h) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        join: cu in ^struct_c,
        where: field(c, ^row_a) == ^role,
        where: field(c, ^row_b) == field(ct, ^row_c),
        where: field(c, ^row_b) == field(cu, ^row_c),
        where: not is_nil(field(ct, ^row_d)),
        where: not is_nil(field(cu, ^row_c)),
        where: field(ct, ^row_d) == ^role,
        select: {field(ct, ^row_c), field(c, ^row_h)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_hero_statuses(map, map, boolean, atom, atom, atom, atom, atom) :: [{word, word}] | nil
  def by_hero_statuses(struct_a, struct_b, role, row_a, row_b, row_c, row_d, row_h) do
    from c in struct_a,
    join: cu in ^struct_b,
    where: field(c, ^row_a) == ^role,
    where: field(c, ^row_b) == field(cu, ^row_c),
    where: not is_nil(field(cu, ^row_d)),
    where: field(cu, ^row_d) == ^role,
    select: field(c, ^row_h)
  end

  @spec by_value(map, atom, String.t()) :: Ecto.Query.t()
  def by_value(struct, row, id) do
    from c in struct,
    where: field(c, ^row) == ^id
  end

  @spec by_values(map, boolean, boolean, atom) :: [{word, integer}] | nil
  def by_values(struct, role, value, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row) == ^value,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_prices(map, boolean, boolean, atom, atom) :: [{word, integer}] | nil
  def by_prices(struct, role, value, row_a, row_b) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row_a) == ^value,
        where: not is_nil(field(cu, ^row_a)),
        where: not is_nil(field(cu, ^row_b)),
        where: field(cu, ^row_b) != 0,
        select: {cu.id, field(cu, ^row_b)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_search(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_search(struct_a, struct_b, role, row_a, row_b, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: fragment("? @> ?", field(c, ^row_b), ^name),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """

  ## Example

      struct_a = Core.Contracts.PotentialClient
      role = true
      row_a = :user_id
      row_b = :project
      user_id = "ADxnQphyaXDCnOWHK4"
      id = "AG2LLCDsiAIodUMn1k"

      iex> by_search_list(struct_a, role, row_a, row_b, user_id, [id])

  """
  @spec by_search_list(map, boolean, atom, atom, word, word) :: [{word}] | nil
  def by_search_list(struct_a, role, row_a, row_b, user_id, id) do
    try do
      Repo.one(
        from c in struct_a,
        join: ct in User,
        where: field(c, ^row_a) == ct.id and ct.role == ^role and c.user_id == ^user_id,
        where: not is_nil(field(c, ^row_b)),
        where: fragment("? @> ?", field(c, ^row_b), ^id),
        select: {c.user_id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_hero_active(map, map, atom, atom, String.t()) :: {String.t(), boolean} | nil
  def by_hero_active(struct_a, struct_b, row_a, row_b, id) do
    try do
      Repo.one(
        from c in struct_a,
        join: ct in ^struct_b,
        where: field(c, ^row_a) == ^id,
        where: field(ct, ^row_b) == field(c, ^row_b),
        where: ct.hero_active == true,
        select: c.user_id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_match(map, map, atom, atom, String.t()) :: {String.t(), boolean} | nil
  def by_match(struct_a, struct_b, row_a, row_b, id) do
    try do
      Repo.one(
        from c in struct_a,
        join: ct in ^struct_b,
        where: field(c, ^row_a) == ^id,
        where: field(ct, ^row_b) == field(c, ^row_b),
        select: {c.user_id, ct.hero_active}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_match(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_match(struct_a, struct_b, role, row_a, row_b, str) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: fragment("? @> ?", field(c, ^row_b), ^[str]),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Find project_id in field's project by PotentialClient

  ## Example

      iex> struct = Core.Contracts.PotentialClient
      iex> row = :project
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> by_project(struct, row, id)
  """
  @spec by_project(map, atom, word) :: [{word}] | nil
  def by_project(struct, row, id) do
    try do
      Repo.all(
        from c in struct,
        where: not is_nil(field(c, ^row)),
        where: fragment("? @> ?", field(c, ^row), ^[id]),
        select: c.id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Find id via status is New for created PotentialClient

  ## Example

      iex> struct = Core.Contracts.Project
      iex> row_a = :status
      iex> row_b = :New
      iex> row_c = :id
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> by_project(struct, row_a, row_b, row_c, id)

  """
  @spec by_project(map, atom, atom, atom, word) :: [{word}] | nil
  def by_project(struct, row_a, row_b, row_c, id) do
    try do
      Repo.one(
        from c in struct,
        where: not is_nil(field(c, ^row_a)),
        where: field(c, ^row_a) == ^row_b,
        where: field(c, ^row_c) == ^id,
        select: c.id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Check out status via project_id for Offer

  ## Example

      iex> struct = Core.Contracts.Offer
      iex> row_a = :user_id
      iex> row_b = :project_id
      iex> row_c = :status
      iex> name = "Declined"
      iex> ida  = current_user.id
      iex> idb  = current_user.project_id
      iex> by_offer(struct, row_a, row_b, row_c, name, ida, idb)

  """
  @spec by_offer(map, atom, atom, atom, word, word, word) :: [] | nil
  def by_offer(struct, row_a, row_b, row_c, name, id_a, id_b) do
    from c in struct,
    where: field(c, ^row_a) == ^id_a,
    where: field(c, ^row_b) == ^id_b,
    where: field(c, ^row_c) == ^name
  end

  @spec by_name!(map, map, atom, String.t(), String.t()) :: [{String.t()}] | []
  def by_name!(struct_a, struct_b, row, id, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: field(c, ^row) == ct.id,
        where: field(c, ^row) == ^id,
        where: c.name == ^name,
        select: {field(c, ^row)}
      )
    rescue
      Ecto.Query.CastError -> :error
    end
  end

  @spec by_name(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_name(struct_a, struct_b, role, row_a, row_b, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_b) == ^name,
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_name_for_tp(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_name_for_tp(struct_a, struct_b, role, row_a, row_b, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_b) == ^name,
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_name_for_pro(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_name_for_pro(struct_a, struct_b, role, row_a, row_b, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_b) == ^name,
        select: {cu.id, c.price}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_names(map, atom, atom, word, word) :: [word] | []
  def by_names(struct, row_a, row_b, name, id) do
    try do
      Repo.all(
        from c in struct,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_a) == ^id,
        where: field(c, ^row_b) == ^name,
        select: c.name
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_names(map, map, boolean, atom, atom, atom, word) :: [{word}] | nil
  def by_names(struct_a, struct_b, role, row_a, row_b, row_c, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: not is_nil(field(c, ^row_c)),
        where: field(c, ^row_c) >= 1,
        where: field(c, ^row_b) == ^name,
        select: {cu.id, c.price}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_count(map, atom, String.t()) :: Ecto.Query.t()
  def by_count(struct, row, id) do
    from c in struct,
    where: field(c, ^row) == ^id
  end

  @spec by_count(map, map, atom, String.t()) :: Ecto.Query.t()
  def by_count(struct_a, struct_b, row, id) do
    from c in struct_a,
    join: ct in ^struct_b,
    where: field(c, ^row) == ^id,
    where: field(c, ^row) == ct.id
  end

  @spec by_counts(map, boolean, atom) :: [{word, integer}] | [{word, float}] | nil
  def by_counts(struct, role, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row) > 0,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id, field(cu, ^row)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_prices(map, boolean, atom) :: [{word, integer}] | nil
  def by_prices(struct, role, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id, field(cu, ^row)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_payrolls(map, boolean, boolean, atom) :: [{word, integer}] | nil
  def by_payrolls(struct, role, value, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row) == ^value,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_years(map, boolean, atom) :: [{word, integer}] | nil
  def by_years(struct, role, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id, field(cu, ^row)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Find Name in field's Service for role Pro

  ## Example

      iex> struct = Core.Services.IndividualEmploymentStatus
      iex> row_a = :individual_tax_return_id
      iex> row_b = :name
      iex> row_c = :price
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> by_service_with_name_for_pro(struct, row_a, row_b, row_c, id)
      [:employed, :"self-employed", :unemployed]
  """
  @spec by_service_with_name_for_pro(map, atom, atom, atom, word) :: [{word}] | nil
  def by_service_with_name_for_pro(struct, row_a, row_b, row_c, id) do
    try do
      Repo.all(
        from c in struct,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(c, ^row_b)),
        where: not is_nil(field(c, ^row_c)),
        where: field(c, ^row_c) != 0,
        where: field(c, ^row_a) == ^id,
        select: c.name
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Find Name and price in field's Service for role Pro

  ## Example

      iex> struct = Core.Services.IndividualEmploymentStatus
      iex> row_a = :individual_tax_return_id
      iex> row_b = :name
      iex> row_c = :price
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> by_service_with_price_for_pro(struct, row_a, row_b, row_c, id)
      [:employed, :"self-employed", :unemployed]
  """
  @spec by_service_with_price_for_pro(map, atom, atom, atom, word) :: [{word}] | nil
  def by_service_with_price_for_pro(struct, row_a, row_b, row_c, id) do
    try do
      Repo.all(
        from c in struct,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(c, ^row_b)),
        where: not is_nil(field(c, ^row_c)),
        where: field(c, ^row_c) != 0,
        where: field(c, ^row_a) == ^id,
        select: {c.name, c.price}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Find Name in field's Service for role Tp

  ## Example

      iex> struct = Core.Services.IndividualEmploymentStatus
      iex> row_a = :individual_tax_return_id
      iex> row_b = :name
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> by_service_with_name_for_tp(struct, row_a, row_b, row_c, id)
      [:employed, :"self-employed", :unemployed]
  """
  @spec by_service_with_name_for_tp(map, atom, atom, word) :: [{word}] | nil
  def by_service_with_name_for_tp(struct, row_a, row_b, id) do
    try do
      Repo.all(
        from c in struct,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_a) == ^id,
        select: c.name
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec decimal_mult(float, integer) :: word
  def decimal_mult(val1, val2) when is_integer(val1) do
    val1
    |> D.new()
    |> D.mult(val2)
  end

  @spec decimal_mult(any, any) :: nil
  def decimal_mult(_, _), do: nil

  @doc """
  Recursion with first a maximum integer and check it out
  hero_status by Platform via total_match or returns all
  an user are emails with role's pro

  ## Example

      iex> service = Core.Services.BookKeeping
      iex> book_keeping_id = FlakeId.get()
      iex> data = transform_match(book_keeping_id)
      iex> max_match(service, data)
      %{user_id: FlakeId.get()}
  """
  @spec max_match(atom, list) :: %{user_id: String.t()} | [tuple]
  def max_match(service, data), do: status(service, data)
  defp status(service, [h|t]) do
    try do
      data = by_match(service, Platform, :id, :user_id, elem(h, 0))
      if elem(data, 1) == true, do: %{user_id: elem(data, 0)}, else: status(service, t)
    rescue
      ArgumentError -> status(service, t)
    end
  end
  defp status(service, []), do: by_hero_status(User, Platform, service, true, :role, :id, :user_id, :hero_status, :email)

  @doc """
  Recursion with field's an average_rating by ProRating
  and return all recoders with userId and Decimal value

  ## Example

      iex> data = [FlakeId.get()]
      iex> max_pro_rating(data)
      [{FlakeId.get(), decimal}]
  """
  @spec max_pro_rating(list) :: [tuple] | []
  def max_pro_rating(data), do: pro_status(data, &(by_pro_rating(ProRating, :user_id, :average_rating, &1)))
  def pro_status([h|t], fun), do: [fun.(h)|pro_status(t, fun)] |> List.delete(nil)
  def pro_status([], _fun), do: []

  @doc """
  Recursion with first a maximum integer and check it out
  hero_status by Platform via total_match if get more are
  items then check fields's average_rating by ProRating
  and select maximume a row and result save, if we get nil
  or false then need the returns all an user are emails
  with role's pro

  ## Example

      iex> service = Core.Services.BookKeeping
      iex> book_keeping_id = FlakeId.get()
      iex> data = transform_match(book_keeping_id)
      iex> get_hero_active(service, data)
      [{FlakeId.get()}]
  """
  @spec get_hero_active(atom, list) :: [String.t()] | []
  def get_hero_active(service, data), do: get_map(data, &(by_hero_active(service, Platform, :id, :user_id, elem(&1, 0))))
  def get_map([h|t], fun), do: [fun.(h)|get_map(t, fun)] |> List.delete(nil)
  def get_map([], _fun), do: []

  @doc """
  Transformation total match by Id's Service

  ## Example

    iex> book_keeping_id = FlakeId.get()
    iex> transform_match(book_keeping_id)
    [{FlakeId.get(), 30}]
  """
  @spec transform_match(String.t() | nil) :: [{String.t(), integer}] | []
  def transform_match(id) do
    if is_nil(id) do
      []
    else
      data =
        Analyzes.total_match(id)
        |> Enum.to_list()
        |> Enum.sort(fn({_, value1}, {_, value2}) ->
          value2 < value1
        end)

      data |> case do
        [message: "UserId Not Found in SaleTax", field: :user_id] -> []
        _ -> data
      end

    end
  end

  @doc """
  Proper way to determine if a Map has certain keys

  ## Example

      iex> keys = ["artist", "track", "year"]
      iex> data1 = %{"track" => "bogus", "artist" => "someone"}
      iex> data2 = %{"track" => "bogus", "artist" => "someone", "year" => 2016}
      iex> data1 |> Map.keys() |> contains_fields?(["year"])
      iex> false
      iex> data2 |> Map.keys() |> contains_fields?(["year"])
      iex> true

  """
  @spec contains_fields?([String.t()], [String.t()]) :: boolean
  def contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))

  @doc """
  ## Example

      iex> struct_a = Core.Contracts.Project
      iex> struct_b = Core.Accounts.User
      iex> role = false
      iex> status = "Done"
      iex> current_user = Core.Repo.get_by(Core.Accounts.User, %{email: "kapranov.lugatex@gmail.com"})
      iex> Core.Queries.by_count_with_status_projects(struct_a, struct_b, role, status, current_user)
      [1]

  """
  @spec by_count_with_status_projects(atom, atom, boolean, String.t(), User.t()) :: [integer]  | []
  def by_count_with_status_projects(struct_a, struct_b, role, status, current_user) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: c.user_id == cu.id,
        where: cu.role == ^role,
        where: not is_nil(c.status),
        where: c.status == ^status,
        where: not is_nil(c.assigned_id),
        where: c.assigned_id == ^current_user.id,
        select: count(c.user_id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  ## Example

      iex> struct_a = Core.Contracts.Project
      iex> struct_b = Core.Accounts.User
      iex> role = false
      iex> status_a = "In Progress"
      iex> status_b = "In Transition"
      iex> current_user = Core.Repo.get_by(Core.Accounts.User, %{email: "kapranov.lugatex@gmail.com"})
      iex> Core.Queries.by_count_with_status_projects(struct_a, struct_b, role, status_a, status_b, current_user)
      [1]

  """
  @spec by_count_with_status_projects(atom, atom, boolean, String.t(), String.t(), User.t()) :: [integer] | []
  def by_count_with_status_projects(struct_a, struct_b, role, status_a, status_b, current_user) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: c.user_id == cu.id,
        where: cu.role == ^role,
        where: not is_nil(c.status),
        where: c.status == ^status_a or c.status == ^status_b,
        where: not is_nil(c.assigned_id),
        where: c.assigned_id == ^current_user.id,
        select: count(c.user_id)
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  ## Example

      iex> struct_a = Core.Contracts.Project
      iex> struct_b = Core.Accounts.User
      iex> role = false
      iex> status = "Done"
      iex> current_user = Core.Repo.get_by(Core.Accounts.User, %{email: "kapranov.lugatex@gmail.com"})
      [{1, 1}]
  """
  @spec by_count_with_offer_addon_projects(atom, atom, boolean, String.t(), User.t()) :: [{integer, integer | nil}]  | []
  def by_count_with_offer_addon_projects(struct_a, struct_b, role, status, current_user) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: c.user_id == cu.id,
        where: cu.role == ^role,
        where: not is_nil(c.status),
        where: c.status == ^status,
        where: not is_nil(c.assigned_id),
        where: c.assigned_id == ^current_user.id,
        select: {c.offer_price, c.addon_price}
      )
    rescue
      Ecto.Query.CastError -> []
    end
  end

  @doc """
  ## Example

      iex> struct_a = Core.Servives.SaleTax
      iex> struct_b = Core.Accounts.User
      iex> struct_c = Core.Contracts.Project
      iex> struct_d = Core.Services.SaleTaxFrequency
      iex> struct_f = Core.Servives.SaleTaxIndustry
      iex> row_a = :user_id
      iex> row_b = :sale_tax_id
      iex> id = FlakeId.get()
      iex> name = "SaleTax"
      iex> by_sale_taxes_for_tp(Core.Services.SaleTax, Core.Accounts.User, Core.Contracts.Project, Core.Services.SaleTaxFrequency, Core.Services.SaleTaxIndustry, :user_id, :sale_tax_id, "ADxsR9DkXb6Z5ELoOG", name)
      Map.new()
  """
  @spec by_sale_taxes_for_tp(map, map, map, map, map, atom, atom, atom, word) :: [{word}] | nil
  def by_sale_taxes_for_tp(struct_a, struct_b, struct_c, struct_d, struct_f, row_a, row_b, id, name) do
    try do
      Repo.one(
        from c in struct_a,
        join: cp in ^struct_c,
        join: cd in ^struct_d,
        join: cf in ^struct_f,
        join: cu in ^struct_b,
        where: c.id == ^id,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(cp, ^row_a)),
        where: not is_nil(field(cp, ^row_b)),
        where: c.user_id == cu.id,
        where: c.user_id == cp.user_id,
        where: c.id == field(cp, ^row_b),
        where: c.id == field(cd, ^row_b),
        where: c.id == field(cf, ^row_b),
        select: %{
          name: ^name,
          project: %{
            id: cp.id,
            instant_matched: cp.instant_matched,
            status: cp.status
          },
          sale_tax: %{
            id: c.id,
            deadline: c.deadline,
            sale_tax_count: c.sale_tax_count,
            state: c.state,
            sale_tax_frequency: %{name: cd.name},
            sale_tax_industry: %{name: cf.name},
          },
          user: %{
            id: cu.id,
            avatar: cu.avatar,
            first_name: cu.first_name,
            languages: nil
          }
        }
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  ## Example

      iex> struct_a = Core.Servives.BookKeeping
      iex> struct_b = Core.Accounts.User
      iex> struct_c = Core.Contracts.Project
      iex> struct_d = Core.Services.BookKeepingAnnualRevenue
      iex> struct_f = Core.Services.BookKeepingNumberEmployee
      iex> struct_h = Core.Services.BookKeepingTypeClient
      iex> row_a = :user_id
      iex> row_b = :book_keeping_id
      iex> id = FlakeId.get()
      iex> name = "BookKeeping"
      iex> by_book_keepings_for_tp(Core.Services.BookKeeping, Core.Accounts.User, Core.Contracts.Project, Core.Services.BookKeepingAnnualRevenue, Core.Services.BookKeepingNumberEmployee, Core.Services.BookKeepingTypeClient, :user_id, :book_keeping_id, "AEGZXAy9T6sfnd0xAO", name)
      Map.new()
  """
  @spec by_book_keepings_for_tp(map, map, map, map, map, map, atom, atom, atom, word) :: [{word}] | nil
  def by_book_keepings_for_tp(struct_a, struct_b, struct_c, struct_d, struct_f, struct_h, row_a, row_b, id, name) do
    try do
      Repo.one(
        from c in struct_a,
        join: cc in ^struct_c,
        join: cd in ^struct_d,
        join: cf in ^struct_f,
        join: ch in ^struct_h,
        join: cu in ^struct_b,
        where: c.id == ^id,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(cc, ^row_a)),
        where: not is_nil(field(cc, ^row_b)),
        where: not is_nil(field(cd, ^row_b)),
        where: not is_nil(field(cf, ^row_b)),
        where: not is_nil(field(ch, ^row_b)),
        where: c.user_id == cu.id,
        where: c.user_id == cc.user_id,
        where: c.id == field(cc, ^row_b),
        where: c.id == field(cd, ^row_b),
        where: c.id == field(cf, ^row_b),
        where: c.id == field(ch, ^row_b),
        select: %{
          name: ^name,
          project: %{
            id: cc.id,
            instant_matched: cc.instant_matched,
            status: cc.status
          },
          book_keeping: %{
            id: c.id,
            deadline: c.deadline,
            tax_year: c.tax_year,
            book_keeping_annual_revenue: %{name: cd.name},
            book_keeping_number_employee: %{name: ch.name},
            book_keeping_type_client: %{name: cf.name}
          },
          user: %{
            id: cu.id,
            avatar: cu.avatar,
            first_name: cu.first_name,
            languages: nil
          }
        }
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  ## Example

      iex> struct_a = Core.Servives.BusinessTaxReturn
      iex> struct_b = Core.Accounts.User
      iex> struct_c = Core.Contracts.Project
      iex> struct_d = Core.Services.BusinessEntityType
      iex> struct_f = Core.Services.BusinessNumberEmployee
      iex> struct_h = Core.Services.BusinessTotalRevenue
      iex> row_a = :user_id
      iex> row_b = :business_tax_return_id
      iex> id = FlakeId.get()
      iex> name = "BusinessTaxReturn"
      iex> by_business_tax_returns_for_tp(Core.Services.BusinessTaxReturn, Core.Accounts.User, Core.Contracts.Project, Core.Services.BusinessEntityType, Core.Services.BusinessNumberEmployee, Core.Services.BusinessTotalRevenue, :user_id, :business_tax_return_id, "xxx", name)
      Map.new()
  """
  @spec by_business_tax_returns_for_tp(map, map, map, map, map, map, atom, atom, atom, word) :: [{word}] | nil
  def by_business_tax_returns_for_tp(struct_a, struct_b, struct_c, struct_d, struct_f, struct_h, row_a, row_b, id, name) do
    try do
      Repo.one(
        from c in struct_a,
        join: cc in ^struct_c,
        join: cd in ^struct_d,
        join: cf in ^struct_f,
        join: ch in ^struct_h,
        join: cu in ^struct_b,
        where: c.id == ^id,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(cc, ^row_a)),
        where: not is_nil(field(cd, ^row_b)),
        where: not is_nil(field(cf, ^row_b)),
        where: not is_nil(field(ch, ^row_b)),
        where: c.user_id == cu.id,
        where: c.user_id == cc.user_id,
        where: c.id == field(cc, ^row_b),
        where: c.id == field(cd, ^row_b),
        where: c.id == field(cf, ^row_b),
        where: c.id == field(ch, ^row_b),
        select: %{
          name: ^name,
          project: %{
            id: cc.id,
            instant_matched: cc.instant_matched,
            status: cc.status
          },
          business_tax_return: %{
            id: c.id,
            deadline: c.deadline,
            state: c.state,
            tax_year: c.tax_year,
            business_entity_type: %{name: cd.name},
            business_number_employee: %{name: cf.name},
            business_total_revenue: %{name: ch.name}
          },
          user: %{
            id: cu.id,
            avatar: cu.avatar,
            first_name: cu.first_name,
            languages: nil
          }
        }
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  ## Example

      iex> struct_a = Core.Servives.IndividualTaxReturn
      iex> struct_b = Core.Accounts.User
      iex> struct_c = Core.Contracts.Project
      iex> struct_d = Core.Services.IndividualEmploymentStatus
      iex> struct_f = Core.Services.IndividualFilingStatus
      iex> struct_h = Core.Services.IndividualItemizedDeduction
      iex> row_a = :user_id
      iex> row_b = :individual_tax_return_id
      iex> id = FlakeId.get()
      iex> name = "IndividualTaxReturn"
      iex> by_individual_tax_returns_for_tp(Core.Services.IndividualTaxReturn, Core.Accounts.User, Core.Contracts.Project, Core.Services.IndividualEmploymentStatus, Core.Services.IndividualFilingStatus, Core.Services.IndividualItemizedDeduction, :user_id, :individual_tax_return_id, "xxx", name)
      Map.new()
  """
  @spec by_individual_tax_returns_for_tp(map, map, map, map, map, map, atom, atom, atom, word) :: [{word}] | nil
  def by_individual_tax_returns_for_tp(struct_a, struct_b, struct_c, struct_d, struct_f, struct_h, row_a, row_b, id, name) do
    try do
      Repo.one(
        from c in struct_a,
        join: cc in ^struct_c,
        join: cd in ^struct_d,
        join: cf in ^struct_f,
        join: ch in ^struct_h,
        join: cu in ^struct_b,
        where: c.id == ^id,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(cc, ^row_a)),
        where: not is_nil(field(cc, ^row_b)),
        where: not is_nil(field(cd, ^row_b)),
        where: not is_nil(field(cf, ^row_b)),
        where: not is_nil(field(ch, ^row_b)),
        where: c.user_id == cu.id,
        where: c.user_id == cc.user_id,
        where: c.id == field(cc, ^row_b),
        where: c.id == field(cd, ^row_b),
        where: c.id == field(cf, ^row_b),
        where: c.id == field(ch, ^row_b),
        select: %{
          name: ^name,
          project: %{
            id: cc.id,
            instant_matched: cc.instant_matched,
            status: cc.status
          },
          individual_tax_return: %{
            id: c.id,
            deadline: c.deadline,
            state: c.state,
            tax_year: c.tax_year,
            individual_employment_status: %{name: cd.name},
            individual_filing_status: %{name: cf.name},
            individual_itemized_deduction: %{name: ch.name}
          },
          user: %{
            id: cu.id,
            avatar: cu.avatar,
            first_name: cu.first_name,
            languages: nil
          }
        }
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

#  @spec filtered_service(map) :: map
#  def filtered_service(attrs) do
#    case is_nil(attrs.book_keeping_id) do
#      true ->
#        case is_nil(attrs.business_tax_return_id) do
#          true ->
#            case is_nil(attrs.individual_tax_return_id) do
#              true ->
#                case is_nil(attrs.sale_tax_id) do
#                  true ->
#                    attrs
#                    |> Map.delete(:book_keeping_id)
#                    |> Map.delete(:business_tax_return_id)
#                    |> Map.delete(:individual_tax_return_id)
#                    |> Map.delete(:sale_tax_id)
#                  false ->
#                    attrs
#                    |> Map.delete(:book_keeping_id)
#                    |> Map.delete(:business_tax_return_id)
#                    |> Map.delete(:individual_tax_return_id)
#                    |> Map.merge(%{name: "Sales Tax"})
#                end
#              false ->
#                attrs
#                |> Map.delete(:book_keeping_id)
#                |> Map.delete(:business_tax_return_id)
#                |> Map.delete(:sale_tax_id)
#                |> Map.merge(%{name: "Individual Tax Return #{individual_tax_return_tax_year(attrs.individual_tax_return_id)}"})
#            end
#          false ->
#            attrs
#            |> Map.delete(:book_keeping_id)
#            |> Map.delete(:individual_tax_return_id)
#            |> Map.delete(:sale_tax_id)
#            |> Map.merge(%{name: "Business Tax Return #{business_tax_return_tax_year(attrs.business_tax_return_id)}"})
#        end
#      false ->
#        attrs
#        |> Map.delete(:business_tax_return_id)
#        |> Map.delete(:individual_tax_return_id)
#        |> Map.delete(:sale_tax_id)
#        |> Map.merge(%{name: "Bookkeeping #{book_keeping_tax_year(attrs.book_keeping_id)}"})
#    end
#  end
#
#  @spec book_keeping_tax_year(String.t()) :: String.t()
#  defp book_keeping_tax_year(id) do
#    id
#    |> Core.Services.get_book_keeping!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end
#
#  @spec business_tax_return_tax_year(String.t()) :: String.t()
#  defp business_tax_return_tax_year(id) do
#    id
#    |> Core.Services.get_business_tax_return!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end
#
#  @spec individual_tax_return_tax_year(String.t()) :: String.t()
#  defp individual_tax_return_tax_year(id) do
#    id
#    |> Core.Services.get_individual_tax_return!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end
#
#  @spec sale_tax_return_tax_year(String.t()) :: String.t()
#  defp sale_tax_return_tax_year(id) do
#    id
#    |> Core.Services.get_sale_tax!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end

#  @spec proba(map) :: map
#  def proba(attrs) do
#    # attrs = %{sale_tax_id: "sss", individual_tax_return_id: "iii", business_tax_return_id: "bbb", book_keeping_id: "kkk", avatar: "Witten", email: "lugatex"}
#
#    case Map.has_key?(attrs, :book_keeping_id) do
#      true ->
#        case is_nil(attrs.book_keeping_id) do
#          true ->
#            case Map.has_key?(attrs, :business_tax_return_id) do
#              true ->
#                case is_nil(attrs.business_tax_return_id) do
#                  true ->
#                    case Map.has_key?(attrs, :individual_tax_return_id) do
#                      true ->
#                         case is_nil(attrs.individual_tax_return_id) do
#                           true ->
#                             case Map.has_key?(attrs, :sale_tax_id) do
#                               true ->
#                                 case is_nil(attrs.sale_tax_id) do
#                                   true ->
#                                     attrs
#                                     |> Map.delete(:book_keeping_id)
#                                     |> Map.delete(:business_tax_return_id)
#                                     |> Map.delete(:individual_tax_return_id)
#                                     |> Map.delete(:sale_tax_id)
#                                   false ->
#                                     attrs
#                                     |> Map.delete(:book_keeping_id)
#                                     |> Map.delete(:business_tax_return_id)
#                                     |> Map.delete(:individual_tax_return_id)
#                                 end
#                               false ->
#                                 attrs
#                                 |> Map.delete(:individual_tax_return_id)
#                                 |> Map.delete(:business_tax_return_id)
#                                 |> Map.delete(:book_keeping_id)
#                             end
#                           false ->
#                             attrs
#                             |> Map.delete(:book_keeping_id)
#                             |> Map.delete(:business_tax_return_id)
#                             |> Map.delete(:sale_tax_id)
#                         end
#                      false ->
#                        case Map.has_key?(attrs, :sale_tax_id) do
#                          true ->
#                            case is_nil(attrs.sale_tax_id) do
#                              true ->
#                                attrs
#                                |> Map.delete(:book_keeping_id)
#                                |> Map.delete(:business_tax_return_id)
#                                |> Map.delete(:sale_tax_id)
#                              false ->
#                                attrs
#                                |> Map.delete(:book_keeping_id)
#                                |> Map.delete(:business_tax_return_id)
#                            end
#                          false ->
#                            attrs
#                            |> Map.delete(:book_keeping_id)
#                            |> Map.delete(:business_tax_return_id)
#                        end
#                    end
#                  false ->
#                    attrs
#                    |> Map.delete(:book_keeping_id)
#                    |> Map.delete(:individual_tax_return_id)
#                    |> Map.delete(:sale_tax_id)
#                end
#              false ->
#                case Map.has_key?(attrs, :individual_tax_return_id) do
#                  true ->
#                    case is_nil(attrs.individual_tax_return_id) do
#                      true ->
#                        case Map.has_key?(attrs, :sale_tax_id) do
#                          true ->
#                             case is_nil(attrs.sale_tax_id) do
#                               true ->
#                                 attrs
#                                 |> Map.delete(:individual_tax_return_id)
#                                 |> Map.delete(:sale_tax_id)
#                               false ->
#                                 attrs
#                                 |> Map.delete(:individual_tax_return_id)
#                             end
#                          false ->
#                            attrs
#                            |> Map.delete(:individual_tax_return_id)
#                        end
#                      false ->
#                        attrs
#                        |> Map.delete(:sale_tax_id)
#                    end
#                  false ->
#                    case Map.has_key?(attrs, :sale_tax_id) do
#                      true ->
#                        case is_nil(attrs.sale_tax_id) do
#                          true ->
#                            attrs
#                            |> Map.delete(:sale_tax_id)
#                          false -> attrs
#                        end
#                      false -> attrs
#                    end
#                end
#            end
#          false ->
#            attrs
#            |> Map.delete(:business_tax_return_id)
#            |> Map.delete(:individual_tax_return_id)
#            |> Map.delete(:sale_tax_id)
#        end
#      false ->
#        case Map.has_key?(attrs, :business_tax_return_id) do
#          true ->
#            case is_nil(attrs.business_tax_return_id) do
#              true ->
#                case Map.has_key?(attrs, :individual_tax_return_id) do
#                  true ->
#                    case is_nil(attrs.individual_tax_return_id) do
#                      true ->
#                        case Map.has_key?(attrs, :sale_tax_id) do
#                          true ->
#                            case is_nil(attrs.sale_tax_id) do
#                              true ->
#                                attrs
#                                |> Map.delete(:business_tax_return_id)
#                                |> Map.delete(:individual_tax_return_id)
#                                |> Map.delete(:sale_tax_id)
#                              false ->
#                                attrs
#                                |> Map.delete(:business_tax_return_id)
#                                |> Map.delete(:individual_tax_return_id)
#                            end
#                          false ->
#                            attrs
#                            |> Map.delete(:business_tax_return_id)
#                            |> Map.delete(:individual_tax_return_id)
#                        end
#                      false ->
#                        attrs
#                        |> Map.delete(:business_tax_return_id)
#                        |> Map.delete(:sale_tax_id)
#                    end
#                  false ->
#                    case Map.has_key?(attrs, :sale_tax_id) do
#                      true ->
#                        case is_nil(attrs.sale_tax_id) do
#                          true ->
#                            attrs
#                            |> Map.delete(:business_tax_return_id)
#                            |> Map.delete(:sale_tax_id)
#                          false ->
#                            attrs
#                            |> Map.delete(:business_tax_return_id)
#                        end
#                      false ->
#                        attrs
#                        |> Map.delete(:business_tax_return_id)
#                    end
#                end
#              false ->
#                attrs
#                |> Map.delete(:individual_tax_return_id)
#                |> Map.delete(:sale_tax_id)
#            end
#          false ->
#            case Map.has_key?(attrs, :individual_tax_return_id) do
#              true ->
#                case is_nil(attrs.individual_tax_return_id) do
#                  true ->
#                    case is_nil(attrs.sale_tax_id) do
#                      true ->
#                        attrs
#                        |> Map.delete(:individual_tax_return_id)
#                        |> Map.delete(:sale_tax_id)
#                      false ->
#                        attrs
#                        |> Map.delete(:individual_tax_return_id)
#                    end
#                  false ->
#                    attrs
#                    |> Map.delete(:sale_tax_id)
#                end
#              false ->
#                case Map.has_key?(attrs, :sale_tax_id) do
#                  true ->
#                    case is_nil(attrs.sale_tax_id) do
#                      true ->
#                        attrs
#                        |> Map.delete(:sale_tax_id)
#                      false -> attrs
#                    end
#                  false -> attrs
#                end
#            end
#        end
#    end
#  end
end
