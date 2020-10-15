defmodule Core.Accounts.PlatformTest do
  use Core.DataCase

  alias Core.Accounts

  describe "platform via role's Tp" do
    alias Core.Accounts.Platform

    @valid_attrs %{
      client_limit_reach: true,
      hero_active: true,
      hero_status: true,
      is_banned: true,
      is_online: true,
      is_stuck: true,
      payment_active: true,
      stuck_stage: "Blockscore"
    }

    @update_attrs %{
      client_limit_reach: false,
      hero_active: false,
      hero_status: false,
      is_banned: false,
      is_online: false,
      is_stuck: false,
      payment_active: false,
      stuck_stage: "Stripe"
    }

    @invalid_attrs %{
      client_limit_reach: nil,
      is_banned: nil,
      is_online: nil,
      is_stuck: nil,
      payment_active: nil,
      user_id: nil
    }

    test "requires user_id via role's Tp" do
      changeset = Platform.changeset(%Platform{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures platform with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %Platform{}
        |> Platform.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_platform/0 returns all platforms" do
      ban_reason = insert(:ban_reason)
      user = insert(:tp_user)
      struct = insert(:tp_platform, ban_reason: ban_reason, user: user)
      [data] = Accounts.list_platform()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_platform!/1 returns the platform with given id" do
      struct = insert(:tp_platform)
      data = Accounts.get_platform!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_platform/1 with valid data creates the platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:tp_user)

      params = Map.merge(@valid_attrs, %{
        ban_reason_id: ban_reason.id,
        user_id:       user.id
      })

      assert {:ok, %Platform{} = created} =
        Accounts.create_platform(params)

      assert %Ecto.Association.NotLoaded{} = created.user

      [loaded] =
        Repo.preload([created], [:ban_reason, :user])
        |> sort_by_id()

      assert created.client_limit_reach == true
      assert created.hero_active        == true
      assert created.hero_status        == true
      assert created.is_banned          == true
      assert created.is_online          == true
      assert created.is_stuck           == true
      assert created.payment_active     == true
      assert created.stuck_stage        == :Blockscore
      assert created.user_id            == user.id

      assert loaded.ban_reason.id                == ban_reason.id
      assert loaded.ban_reason.other             == ban_reason.other
      assert loaded.ban_reason.other_description == ban_reason.other_description
      assert loaded.ban_reason.reasons           == ban_reason.reasons

      assert loaded.user.active      == user.active
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.bio         == user.bio
      assert loaded.user.birthday    == user.birthday
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.init_setup  == user.init_setup
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.middle_name == user.middle_name
      assert loaded.user.phone       == user.phone
      assert loaded.user.role        == user.role
      assert loaded.user.provider    == user.provider
      assert loaded.user.sex         == user.sex
      assert loaded.user.ssn         == user.ssn
      assert loaded.user.street      == user.street
      assert loaded.user.zip         == user.zip
      assert loaded.user.inserted_at == user.inserted_at
      assert loaded.user.updated_at  == user.updated_at
    end

    test "create_platform/1 with not correct some fields platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:tp_user)

      params = Map.merge(@invalid_attrs, %{
        ban_reason_id: ban_reason.id,
        user_id:       user.id
      })

      assert {:error, %Ecto.Changeset{}} = Accounts.create_platform(params)
    end

    test "create_platform/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_platform(params)
    end

    test "update_platfrom/2 with valid data updates the platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:tp_user)
      struct = insert(:tp_platform, ban_reason: ban_reason, user: user)

      params = Map.merge(@update_attrs, %{
        ban_reason_id: ban_reason.id,
        user_id:       user.id
      })

      assert {:ok, %Platform{} = updated} =
        Accounts.update_platfrom(struct, params)

      assert updated.id                 == struct.id
      assert updated.client_limit_reach == false
      assert updated.hero_active        == false
      assert updated.hero_status        == false
      assert updated.is_banned          == false
      assert updated.is_online          == false
      assert updated.is_stuck           == false
      assert updated.payment_active     == false
      assert updated.stuck_stage        == :Stripe
      assert updated.user_id            == user.id

      assert updated.ban_reason.id                == ban_reason.id
      assert updated.ban_reason.other             == ban_reason.other
      assert updated.ban_reason.other_description == ban_reason.other_description
      assert updated.ban_reason.reasons           == ban_reason.reasons

      assert updated.user.active      == user.active
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.role        == user.role
      assert updated.user.provider    == user.provider
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip
      assert updated.user.inserted_at == user.inserted_at
      assert updated.user.updated_at  == user.updated_at
    end

    test "update_platfrom/2 with invalid data returns error changeset" do
      ban_reason = insert(:ban_reason)
      user = insert(:tp_user)
      struct = insert(:tp_platform, ban_reason: ban_reason, user: user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_platfrom(struct, @invalid_attrs)
    end

    test "delete_platform/1 deletes the platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:tp_user)
      struct = insert(:tp_platform, ban_reason: ban_reason, user: user)
      assert {:ok, %Platform{}} =
        Accounts.delete_platform(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_platform!(struct.id)
      end
    end

    test "change_platform/1 returns the platform changeset" do
      ban_reason = insert(:ban_reason)
      user = insert(:tp_user)
      struct = insert(:tp_platform, ban_reason: ban_reason, user: user)
      assert %Ecto.Changeset{} =
        Accounts.change_platform(struct)
    end
  end

  describe "platform via role's Pro" do
    alias Core.Accounts.Platform

    @valid_attrs %{
      client_limit_reach: true,
      hero_active: true,
      hero_status: true,
      is_banned: true,
      is_online: true,
      is_stuck: true,
      payment_active: true,
      stuck_stage: "Blockscore"
    }

    @update_attrs %{
      client_limit_reach: false,
      hero_active: false,
      hero_status: false,
      is_banned: false,
      is_online: false,
      is_stuck: false,
      payment_active: false,
      stuck_stage: "Stripe"
    }

    @invalid_attrs %{
      client_limit_reach: nil,
      is_banned: nil,
      is_online: nil,
      is_stuck: nil,
      payment_active: nil,
      user_id: nil
    }

    test "requires user_id via role's Pro" do
      changeset = Platform.changeset(%Platform{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures platform with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %Platform{}
        |> Platform.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_platform/0 returns all platforms" do
      ban_reason = insert(:ban_reason)
      user = insert(:pro_user)
      struct = insert(:pro_platform, ban_reason: ban_reason, user: user)
      [data] = Accounts.list_platform()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_platform!/1 returns the platform with given id" do
      struct = insert(:pro_platform)
      data = Accounts.get_platform!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_platform/1 with valid data creates the platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:pro_user)

      params = Map.merge(@valid_attrs, %{
        ban_reason_id: ban_reason.id,
        user_id:       user.id
      })

      assert {:ok, %Platform{} = created} =
        Accounts.create_platform(params)

      assert %Ecto.Association.NotLoaded{} = created.user

      [loaded] =
        Repo.preload([created], [:ban_reason, :user])
        |> sort_by_id()

      assert created.client_limit_reach == true
      assert created.hero_active        == true
      assert created.hero_status        == true
      assert created.is_banned          == true
      assert created.is_online          == true
      assert created.is_stuck           == true
      assert created.payment_active     == true
      assert created.stuck_stage        == :Blockscore
      assert created.user_id            == user.id

      assert loaded.ban_reason.id                == ban_reason.id
      assert loaded.ban_reason.other             == ban_reason.other
      assert loaded.ban_reason.other_description == ban_reason.other_description
      assert loaded.ban_reason.reasons           == ban_reason.reasons

      assert loaded.user.active      == user.active
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.bio         == user.bio
      assert loaded.user.birthday    == user.birthday
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.init_setup  == user.init_setup
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.middle_name == user.middle_name
      assert loaded.user.phone       == user.phone
      assert loaded.user.role        == user.role
      assert loaded.user.provider    == user.provider
      assert loaded.user.sex         == user.sex
      assert loaded.user.ssn         == user.ssn
      assert loaded.user.street      == user.street
      assert loaded.user.zip         == user.zip
      assert loaded.user.inserted_at == user.inserted_at
      assert loaded.user.updated_at  == user.updated_at
    end

    test "create_platform/1 with not correct some fields platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:pro_user)

      params = Map.merge(@invalid_attrs, %{
        ban_reason_id: ban_reason.id,
        user_id:       user.id
      })

      assert {:error, %Ecto.Changeset{}} = Accounts.create_platform(params)
    end

    test "create_platform/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_platform(params)
    end

    test "update_platfrom/2 with valid data updates the platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:pro_user)
      struct = insert(:pro_platform, ban_reason: ban_reason, user: user)

      params = Map.merge(@update_attrs, %{
        ban_reason_id: ban_reason.id,
        user_id:       user.id
      })

      assert {:ok, %Platform{} = updated} =
        Accounts.update_platfrom(struct, params)

      assert updated.id                 == struct.id
      assert updated.client_limit_reach == false
      assert updated.hero_active        == false
      assert updated.hero_status        == false
      assert updated.is_banned          == false
      assert updated.is_online          == false
      assert updated.is_stuck           == false
      assert updated.payment_active     == false
      assert updated.stuck_stage        == :Stripe
      assert updated.user_id            == user.id

      assert updated.ban_reason.id                == ban_reason.id
      assert updated.ban_reason.other             == ban_reason.other
      assert updated.ban_reason.other_description == ban_reason.other_description
      assert updated.ban_reason.reasons           == ban_reason.reasons

      assert updated.user.active      == user.active
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.role        == user.role
      assert updated.user.provider    == user.provider
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip
      assert updated.user.inserted_at == user.inserted_at
      assert updated.user.updated_at  == user.updated_at
    end

    test "update_platfrom/2 with invalid data returns error changeset" do
      ban_reason = insert(:ban_reason)
      user = insert(:pro_user)
      struct = insert(:pro_platform, ban_reason: ban_reason, user: user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_platfrom(struct, @invalid_attrs)
    end

    test "delete_platform/1 deletes the platform" do
      ban_reason = insert(:ban_reason)
      user = insert(:pro_user)
      struct = insert(:pro_platform, ban_reason: ban_reason, user: user)
      assert {:ok, %Platform{}} =
        Accounts.delete_platform(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_platform!(struct.id)
      end
    end

    test "change_platform/1 returns the platform changeset" do
      ban_reason = insert(:ban_reason)
      user = insert(:pro_user)
      struct = insert(:pro_platform, ban_reason: ban_reason, user: user)
      assert %Ecto.Changeset{} =
        Accounts.change_platform(struct)
    end
  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
