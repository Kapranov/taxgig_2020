defmodule Core.Services.BookKeepingAnnualRevenueTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeepingAnnualRevenue
  }

  describe "book_keeping_annual_revenue by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingAnnualRevenue.changeset(%BookKeepingAnnualRevenue{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingAnnualRevenue{}
        |> BookKeepingAnnualRevenue.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_annual_revenues/0 returns all book_keeping_annual_revenues" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_annual_revenue, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_annual_revenue()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_annual_revenue!/1 returns the book_keeping_annual_revenue with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_annual_revenue, book_keepings: book_keeping)
      data = Services.get_book_keeping_annual_revenue!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_annual_revenue/1 with valid data creates a book_keeping_annual_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "$100K - $500K",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_annual_revenue} = Services.create_book_keeping_annual_revenue(params)
      assert book_keeping_annual_revenue.name                        == :"$100K - $500K"
      assert book_keeping_annual_revenue.price                       == nil
      assert book_keeping_annual_revenue.book_keeping_id             == book_keeping.id
      assert match_value_relate.match_for_book_keeping_annual_revenue == 25
    end

    test "create_book_keeping_annual_revenue/1 with invalid attrs for creates a book_keeping_annual_revenue" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "some name",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_annual_revenue(params)
    end

    test "create_book_keeping_annual_revenue/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_annual_revenue(params)
    end

    test "update_book_keeping_annual_revenue/2 with valid data updates the book_keeping_annual_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_annual_revenue, book_keepings: book_keeping)

      params = %{
        name: "$10M+",
        book_keeping_id: struct.book_keeping_id
      }

      assert {:ok, %BookKeepingAnnualRevenue{} = updated} =
        Services.update_book_keeping_annual_revenue(struct, params)

      assert updated.name                                             == :"$10M+"
      assert updated.price                                            == nil
      assert updated.book_keeping_id                                  == struct.book_keeping_id
      assert match_value_relate.match_for_book_keeping_annual_revenue == 25
    end

    test "update_book_keeping_annual_revenue/2 with invalid data returns not error changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_annual_revenue, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      data = Services.get_book_keeping_annual_revenue!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_annual_revenue(struct, params)
      assert data.book_keeping_id == struct.book_keeping_id
      assert data.name            == struct.name
      assert data.price           == nil
    end

    test "delete_book_keeping_annual_revenue/1 deletes the book_keeping_annual_revenue" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_annual_revenue, book_keepings: book_keeping)
      assert {:ok, %BookKeepingAnnualRevenue{}} = Services.delete_book_keeping_annual_revenue(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_annual_revenue!(struct.id) end
    end

    test "change_book_keeping_annual_revenue/1 returns a book_keeping_annual_revenue changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_annual_revenue, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_annual_revenue(struct)
    end
  end

  describe "book_keeping_annual_revenue by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = BookKeepingAnnualRevenue.changeset(%BookKeepingAnnualRevenue{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingAnnualRevenue{}
        |> BookKeepingAnnualRevenue.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_annual_revenues/0 returns all book_keeping_annual_revenues" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_annual_revenue, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_annual_revenue()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_annual_revenue!/1 returns the book_keeping_annual_revenue with given id" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_annual_revenue, book_keepings: book_keeping)
      data = Services.get_book_keeping_annual_revenue!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_annual_revenue/1 with valid data creates a book_keeping_annual_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)

      params = %{
        name: "$100K - $500K",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_annual_revenue} = Services.create_book_keeping_annual_revenue(params)
      assert book_keeping_annual_revenue.name                         == :"$100K - $500K"
      assert book_keeping_annual_revenue.price                        == 22
      assert book_keeping_annual_revenue.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_annual_revenue == 25
    end

    test "create_book_keeping_annual_revenue/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_annual_revenue(params)
    end

    test "update_book_keeping_annual_revenue/2 with valid data updates the book_keeping_annual_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_annual_revenue, book_keepings: book_keeping)

      params = %{
        name: "$10M+",
        price: 33,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingAnnualRevenue{} = updated} =
        Services.update_book_keeping_annual_revenue(struct, params)

      assert updated.name                                             == :"$10M+"
      assert updated.price                                            == 33
      assert updated.book_keeping_id                                  == struct.book_keeping_id
      assert match_value_relate.match_for_book_keeping_annual_revenue == 25
    end

    test "update_book_keeping_annual_revenue/2 with invalid data returns not error changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_annual_revenue, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping_annual_revenue!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_annual_revenue(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping_annual_revenue/1 deletes the book_keeping_annual_revenue" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_annual_revenue, book_keepings: book_keeping)
      assert {:ok, %BookKeepingAnnualRevenue{}} = Services.delete_book_keeping_annual_revenue(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_annual_revenue!(struct.id) end
    end

    test "change_book_keeping_annual_revenue/1 returns a book_keeping_annual_revenue changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_annual_revenue, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_annual_revenue(struct)
    end
  end
end
