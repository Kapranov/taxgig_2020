defmodule Core.Services.BookKeepingTransactionVolumeTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeepingTransactionVolume
  }

  describe "book_keeping_transaction_volume by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingTransactionVolume.changeset(%BookKeepingTransactionVolume{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingTransactionVolume{}
        |> BookKeepingTransactionVolume.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_transaction_volumes/0 returns all book_keeping_transaction_volumes" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_transaction_volume, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_transaction_volume()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_transaction_volume!/1 returns the book_keeping_transaction_volume with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_transaction_volume, book_keepings: book_keeping)
      data = Services.get_book_keeping_transaction_volume!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_transaction_volume/1 with valid data creates a book_keeping_transaction_volume" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "some name",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_transaction_volume} = Services.create_book_keeping_transaction_volume(params)
      assert book_keeping_transaction_volume.name            == "some name"
      assert book_keeping_transaction_volume.price           == nil
      assert book_keeping_transaction_volume.book_keeping_id == book_keeping.id
    end

    test "create_book_keeping_transaction_volume/1 with invalid attrs for creates a book_keeping_transaction_volume" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "some name",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_transaction_volume(params)
    end

    test "create_book_keeping_transaction_volume/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_transaction_volume(params)
    end

    test "update_book_keeping_transaction_volume/2 with valid data updates the book_keeping_transaction_volume" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_transaction_volume, book_keepings: book_keeping)

      params = %{
        name: "updated name",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingTransactionVolume{} = updated} =
        Services.update_book_keeping_transaction_volume(struct, params)

      assert updated.name            == "updated name"
      assert updated.price           == nil
      assert updated.book_keeping_id == book_keeping.id
    end

    test "update_book_keeping_transaction_volume/2 with valid data updates and ignore price, book_keeping_id by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_transaction_volume, book_keepings: book_keeping)

      params = %{
        name: "updated name",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingTransactionVolume{} = updated} =
        Services.update_book_keeping_transaction_volume(struct, params)

      assert updated.name            == "updated name"
      assert updated.price           == nil
      assert updated.book_keeping_id == book_keeping.id
    end

    test "update_book_keeping_transaction_volume/2 with invalid data returns not error changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_transaction_volume, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping_transaction_volume!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_transaction_volume(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping_transaction_volume/1 deletes the book_keeping_transaction_volume" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_transaction_volume, book_keepings: book_keeping)
      assert {:ok, %BookKeepingTransactionVolume{}} = Services.delete_book_keeping_transaction_volume(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_transaction_volume!(struct.id) end
    end

    test "change_book_keeping_transaction_volume/1 returns a book_keeping_transaction_volume changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_transaction_volume, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_transaction_volume(struct)
    end
  end

  describe "book_keeping_transaction_volume by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = BookKeepingTransactionVolume.changeset(%BookKeepingTransactionVolume{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingTransactionVolume{}
        |> BookKeepingTransactionVolume.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_transaction_volumes/0 returns all book_keeping_transaction_volumes" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_transaction_volume, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_transaction_volume()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_transaction_volume!/1 returns the book_keeping_transaction_volume with given id" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_transaction_volume, book_keepings: book_keeping)
      data = Services.get_book_keeping_transaction_volume!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_transaction_volume/1 with valid data creates a book_keeping_transaction_volume" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)

      params = %{
        name: "some name",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_transaction_volume} = Services.create_book_keeping_transaction_volume(params)
      assert book_keeping_transaction_volume.name            == "some name"
      assert book_keeping_transaction_volume.price           == 22
      assert book_keeping_transaction_volume.book_keeping_id == book_keeping.id
    end

    test "create_book_keeping_transaction_volume/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_transaction_volume(params)
    end

    test "update_book_keeping_transaction_volume/2 with valid data updates the book_keeping_transaction_volume" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_transaction_volume, book_keepings: book_keeping)

      params = %{
        name: "updated name",
        price: 33,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingTransactionVolume{} = updated} =
        Services.update_book_keeping_transaction_volume(struct, params)

      assert updated.name            == "updated name"
      assert updated.price           == 33
      assert updated.book_keeping_id == book_keeping.id
    end

    test "update_book_keeping_transaction_volume/2 with invalid data returns not error changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_transaction_volume, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping_transaction_volume!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_transaction_volume(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping_transaction_volume/1 deletes the book_keeping_transaction_volume" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_transaction_volume, book_keepings: book_keeping)
      assert {:ok, %BookKeepingTransactionVolume{}} = Services.delete_book_keeping_transaction_volume(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_transaction_volume!(struct.id) end
    end

    test "change_book_keeping_transaction_volume/1 returns a book_keeping_transaction_volume changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_transaction_volume, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_transaction_volume(struct)
    end
  end
end
