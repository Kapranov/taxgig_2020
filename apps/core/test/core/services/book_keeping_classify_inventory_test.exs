defmodule Core.Services.BookKeepingClassifyInventoryTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeepingClassifyInventory
  }

  describe "book_keeping_classify_inventory by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingClassifyInventory.changeset(%BookKeepingClassifyInventory{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingClassifyInventory{}
        |> BookKeepingClassifyInventory.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_classify_inventories/0 returns all book_keeping_classify_inventories" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_classify_inventory, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_classify_inventory()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_classify_inventory!/1 returns the book_keeping_classify_inventory with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_classify_inventory, book_keepings: book_keeping)
      data = Services.get_book_keeping_classify_inventory!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_classify_inventory/1 with valid data creates a book_keeping_classify_inventory" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: ["some name"],
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_classify_inventory} = Services.create_book_keeping_classify_inventory(params)
      assert book_keeping_classify_inventory.name            == ["some name"]
      assert book_keeping_classify_inventory.book_keeping_id == book_keeping.id
    end

    test "create_book_keeping_classify_inventory/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_classify_inventory(params)
    end

    test "update_book_keeping_classify_inventory/2 with valid data updates the book_keeping_classify_inventory" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_classify_inventory, book_keepings: book_keeping)

      params = %{
        name: ["updated name"],
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingClassifyInventory{} = updated} =
        Services.update_book_keeping_classify_inventory(struct, params)

      assert updated.name            == ["updated name"]
      assert updated.book_keeping_id == book_keeping.id
    end

    test "update_book_keeping_classify_inventory/2 with valid data updates and ignore book_keeping_id by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_classify_inventory, book_keepings: book_keeping)

      params = %{
        name: ["updated name"],
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingClassifyInventory{} = updated} =
        Services.update_book_keeping_classify_inventory(struct, params)

      assert updated.name            == ["updated name"]
      assert updated.book_keeping_id == book_keeping.id
    end

    test "update_book_keeping_classify_inventory/2 with invalid data returns not error changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_classify_inventory, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: [{}]}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping_classify_inventory!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_classify_inventory(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping_classify_inventory/1 deletes the book_keeping_classify_inventory" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_classify_inventory, book_keepings: book_keeping)
      assert {:ok, %BookKeepingClassifyInventory{}} = Services.delete_book_keeping_classify_inventory(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_classify_inventory!(struct.id) end
    end

    test "change_book_keeping_classify_inventory/1 returns a book_keeping_classify_inventory changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_classify_inventory, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_classify_inventory(struct)
    end
  end
end
