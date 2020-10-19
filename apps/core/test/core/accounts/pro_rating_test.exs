defmodule Core.Accounts.ProRatingTest do
  use Core.DataCase

  alias Core.Accounts
  alias Decimal, as: D

  describe "pro_rating" do
    alias Core.Accounts.ProRating

    @valid_attrs %{
      average_communication: 1.99,
      average_professionalism: 1.99,
      average_rating: 1.99,
      average_work_quality: 1.99,
    }

    @update_attrs %{
      average_communication: 9.99,
      average_professionalism: 9.99,
      average_rating: 9.99,
      average_work_quality: 9.99,
    }

    @invalid_attrs %{
      average_communication: nil,
      average_professionalism: nil,
      average_rating: nil,
      average_work_quality: nil,
      platform_id: nil
    }

    test "requires platform_id" do
      changeset = ProRating.changeset(%ProRating{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:platform_id, :required)
    end

    test "ensures pro_rating with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{
        id: id,
        average_communication: nil,
        average_professionalism: nil,
        average_rating: nil,
        average_work_quality: nil,
        platform_id: nil
      }
      {result, changeset} =
        %ProRating{}
        |> ProRating.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:platform_id, "can't be blank")
    end

    test "list_pro_rating/0 returns all pro_ratings" do
      user = insert(:user)
      platform = insert(:platform, user: user)
      struct = insert(:pro_rating, platforms: platform)
      [data] = Accounts.list_pro_rating()

      assert data.id                      == struct.id
      assert data.average_communication   == struct.average_communication
      assert data.average_professionalism == struct.average_professionalism
      assert data.average_rating          == struct.average_rating
      assert data.average_work_quality    == struct.average_work_quality
      assert data.platform_id             == struct.platform_id
    end

    test "get_pro-rating!/1 returns the pro_rating with given id" do
      user = insert(:user)
      platform = insert(:platform, user: user)
      struct = insert(:pro_rating, platforms: platform)
      data = Accounts.get_pro_rating!(struct.id)

      assert data.id                      == struct.id
      assert data.average_communication   == struct.average_communication
      assert data.average_professionalism == struct.average_professionalism
      assert data.average_rating          == struct.average_rating
      assert data.average_work_quality    == struct.average_work_quality
      assert data.platform_id             == struct.platform_id
    end

    test "create_deleted_user/1 with valid data creates the deleted_user" do
      user = insert(:user)
      platform = insert(:platform, user: user)

      params = Map.merge(@valid_attrs, %{ platform_id: platform.id })

      assert {:ok, %ProRating{} = created} =
        Accounts.create_pro_rating(params)

      assert %Ecto.Association.NotLoaded{} = created.platforms

      assert created.average_communication   == D.new("1.99")
      assert created.average_professionalism == D.new("1.99")
      assert created.average_rating          == D.new("1.99")
      assert created.average_work_quality    == D.new("1.99")
      assert created.platform_id             == platform.id
    end

    test "create_pro_rating/1 with not correct some fields pro_rating" do
      user = insert(:user)
      platform = insert(:platform, user: user)

      params = Map.merge(@invalid_attrs, %{ paltform_id: platform.id })

      assert {:error, %Ecto.Changeset{}} = Accounts.create_pro_rating(params)
    end

    test "create_pro_rating/1 with invalid data returns error changeset" do
      params = %{
        average_communication: nil,
        average_professionalism: nil,
        average_rating: nil,
        average_work_quality: nil,
        platform_id: nil
      }
      assert {:error, %Ecto.Changeset{}} = Accounts.create_pro_rating(params)
    end

    test "update_pro_rating/2 with valid data updates the pro_rating" do
      user = insert(:user)
      platform = insert(:platform, user: user)
      struct = insert(:pro_rating, platforms: platform)

      params = Map.merge(@update_attrs, %{ platform_id: platform.id })

      assert {:ok, %ProRating{} = updated} =
        Accounts.update_pro_rating(struct, params)

      assert updated.id                      == struct.id
      assert updated.average_communication   == D.new("9.99")
      assert updated.average_professionalism == D.new("9.99")
      assert updated.average_rating          == D.new("9.99")
      assert updated.average_work_quality    == D.new("9.99")
      assert updated.platform_id             == platform.id
    end

    test "update_pro_rating/2 with invalid data returns error changeset" do
      user = insert(:user)
      platform = insert(:platform, user: user)
      struct = insert(:pro_rating, platforms: platform)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_pro_rating(struct, @invalid_attrs)
    end

    test "delete_pro_rating/1 deletes the pro_rating" do
      user = insert(:user)
      platform = insert(:platform, user: user)
      struct = insert(:pro_rating, platforms: platform)
      assert {:ok, %ProRating{}} =
        Accounts.delete_pro_rating(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_pro_rating!(struct.id)
      end
    end

    test "change_pro_rating/1 returns the pro_rating changeset" do
      user = insert(:user)
      platform = insert(:platform, user: user)
      struct = insert(:pro_rating, platforms: platform)
      assert %Ecto.Changeset{} =
        Accounts.change_pro_rating(struct)
    end
  end
end
