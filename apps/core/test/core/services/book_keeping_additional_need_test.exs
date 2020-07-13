defmodule Core.Services.BookKeepingAdditionalNeedTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeepingAdditionalNeed
  }

  describe "book_keeping_additional_need by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingAdditionalNeed.changeset(%BookKeepingAdditionalNeed{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil, name: nil}
      {result, changeset} =
        %BookKeepingAdditionalNeed{}
        |> BookKeepingAdditionalNeed.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_additional_needs/0 returns all book_keeping_additional_needs" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_additional_need, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_additional_need()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_additional_need!/1 returns the book_keeping_additional_need with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_additional_need, book_keepings: book_keeping)
      data = Services.get_book_keeping_additional_need!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_additional_need/1 with valid data creates a book_keeping_additional_need" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "accounts payable",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_additional_need} = Services.create_book_keeping_additional_need(params)
      assert book_keeping_additional_need.name                         == :"accounts payable"
      assert book_keeping_additional_need.price                        == nil
      assert book_keeping_additional_need.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_additional_need == 20
    end

    test "create_book_keeping_additional_need/1 with invalid attrs for creates a book_keeping_additional_need" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "some name",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_additional_need(params)
    end

    test "create_book_keeping_additional_need/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_additional_need(params)
    end

    test "update_book_keeping_additional_need/2 with valid data updates the book_keeping_additional_need" do
      match_value_relate = insert(:match_value_relat)
      struct = insert(:tp_book_keeping_additional_need)
      params = %{book_keeping_id: struct.book_keeping_id, name: "accounts receivable"}
      assert {:ok, %BookKeepingAdditionalNeed{} = uploaded} =
        Services.update_book_keeping_additional_need(struct, params)

      assert uploaded.name                                             == :"accounts receivable"
      assert uploaded.price                                            == nil
      assert uploaded.book_keeping_id                                  == struct.book_keeping_id
      assert match_value_relate.match_for_book_keeping_additional_need == 20
    end

    test "update_book_keeping_additional_need/2 with valid data updates and ignore price, book_keeping_id by role's Tp" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_additional_need, book_keepings: book_keeping)

      params = %{book_keeping_id: book_keeping.id, name: "accounts receivable"}

      assert {:ok, %BookKeepingAdditionalNeed{} = uploaded} =
        Services.update_book_keeping_additional_need(struct, params)

      assert uploaded.name                         == :"accounts receivable"
      assert uploaded.price                        == nil
      assert uploaded.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_additional_need == 20
    end

    test "update_book_keeping_additional_need/2 with invalid data returns not error changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_additional_need, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      data = Services.get_book_keeping_additional_need!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_additional_need(struct, params)
      assert data.book_keeping_id == struct.book_keeping_id
      assert data.name            == struct.name
      assert data.price           == nil
    end

    test "delete_book_keeping_additional_need/1 deletes the book_keeping_additional_need" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_additional_need, book_keepings: book_keeping)
      assert {:ok, %BookKeepingAdditionalNeed{}} = Services.delete_book_keeping_additional_need(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_additional_need!(struct.id) end
    end

    test "change_book_keeping_additional_need/1 returns a book_keeping_additional_need changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_additional_need, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_additional_need(struct)
    end
  end

  describe "book_keeping_additional_need by role's Pro" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingAdditionalNeed.changeset(%BookKeepingAdditionalNeed{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingAdditionalNeed{}
        |> BookKeepingAdditionalNeed.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_additional_needs/0 returns all book_keeping_additional_needs" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_additional_need, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_additional_need()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_additional_need!/1 returns the book_keeping_additional_need with given id" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_additional_need, book_keepings: book_keeping)
      data = Services.get_book_keeping_additional_need!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_additional_need/1 with valid data creates a book_keeping_additional_need" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)

      params = %{
        name: "accounts payable",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_additional_need} =
        Services.create_book_keeping_additional_need(params)

      assert book_keeping_additional_need.name                         == :"accounts payable"
      assert book_keeping_additional_need.price                        == 22
      assert book_keeping_additional_need.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_additional_need == 20
    end

    test "create_book_keeping_additional_need/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_additional_need(params)
    end

    test "update_book_keeping_additional_need/2 with valid data updates the book_keeping_additional_need" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_additional_need, book_keepings: book_keeping)

      params = %{
        name: "accounts receivable",
        price: 33,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingAdditionalNeed{} = updated} =
        Services.update_book_keeping_additional_need(struct, params)

      assert updated.name                                              == :"accounts receivable"
      assert updated.price                                             == 33
      assert updated.book_keeping_id                                   == book_keeping.id
      assert match_value_relate.match_for_book_keeping_additional_need == 20
    end

    test "update_book_keeping_additional_need/2 with invalid data returns not error changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_additional_need, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping_additional_need!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_additional_need(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping_additional_need/1 deletes the book_keeping_additional_need" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_additional_need, book_keepings: book_keeping)
      assert {:ok, %BookKeepingAdditionalNeed{}} = Services.delete_book_keeping_additional_need(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_additional_need!(struct.id) end
    end

    test "change_book_keeping_additional_need/1 returns a book_keeping_additional_need changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_additional_need, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_additional_need(struct)
    end
  end
end
