defmodule Core.Services.BookKeepingIndustryTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeepingIndustry
  }

  describe "book_keeping_industry by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingIndustry.changeset(%BookKeepingIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingIndustry{}
        |> BookKeepingIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_industries/0 returns all book_keeping_industries" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_industry, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_industry!/1 returns the book_keeping_industry with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_industry, book_keepings: book_keeping)
      data = Services.get_book_keeping_industry!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_industry/1 with valid data creates a book_keeping_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: ["Legal"],
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_industry} = Services.create_book_keeping_industry(params)
      assert book_keeping_industry.name                         == [:"Legal"]
      assert book_keeping_industry.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_industry == 10
    end

    test "create_book_keeping_industry/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_industry(params)
    end

    test "update_book_keeping_industry/2 with valid data updates the book_keeping_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_industry, book_keepings: book_keeping, name: ["Agriculture/Farming"])
      params = %{name: ["Transportation"]}

      assert {:ok, %BookKeepingIndustry{} = updated} =
        Services.update_book_keeping_industry(struct, params)

      assert updated.name                                       == [:"Transportation"]
      assert updated.book_keeping_id                            == book_keeping.id
      assert match_value_relate.match_for_book_keeping_industry == 10
    end

    test "update_book_keeping_industry/2 with invalid data returns not error changeset" do
      struct = insert(:tp_book_keeping_industry)
      params = %{book_keeping_id: nil, name: [{}]}
      assert {:error, %Ecto.Changeset{}} = Services.update_book_keeping_industry(struct, params)
    end

    test "delete_book_keeping_industry/1 deletes the book_keeping_industry" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_industry, book_keepings: book_keeping)
      assert {:ok, %BookKeepingIndustry{}} = Services.delete_book_keeping_industry(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_industry!(struct.id) end
    end

    test "change_book_keeping_industry/1 returns a book_keeping_industry changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_industry, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_industry(struct)
    end
  end

  describe "book_keeping_industry by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = BookKeepingIndustry.changeset(%BookKeepingIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingIndustry{}
        |> BookKeepingIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_industries/0 returns all book_keeping_industries" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_industry, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_industry!/1 returns the book_keeping_industry with given id" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_industry, book_keepings: book_keeping)
      data = Services.get_book_keeping_industry!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_industry/1 with valid data creates a book_keeping_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)

      params = %{
        name: ["Agriculture/Farming"],
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_industry} = Services.create_book_keeping_industry(params)
      assert book_keeping_industry.name                         == [:"Agriculture/Farming"]
      assert book_keeping_industry.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_industry == 10
    end

    test "create_book_keeping_industry/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_industry(params)
    end

    test "update_book_keeping_industry/2 with valid data updates the book_keeping_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_industry, book_keepings: book_keeping, name: ["Agriculture/Farming"])
      params = %{name: ["Wholesale Distribution"]}
      assert {:ok, %BookKeepingIndustry{} = updated} = Services.update_book_keeping_industry(struct, params)

      assert updated.name                                       == [:"Wholesale Distribution"]
      assert updated.book_keeping_id                            == struct.book_keeping_id
      assert match_value_relate.match_for_book_keeping_industry == 10
    end

    test "update_book_keeping_industry/2 with invalid data returns not error changeset" do
      struct = insert(:pro_book_keeping_industry)
      params = %{book_keeping_id: nil, name: [{}]}
      assert {:error, %Ecto.Changeset{}} = Services.update_book_keeping_industry(struct, params)
    end

    test "delete_book_keeping_industry/1 deletes the book_keeping_industry" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_industry, book_keepings: book_keeping)
      assert {:ok, %BookKeepingIndustry{}} = Services.delete_book_keeping_industry(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_industry!(struct.id) end
    end

    test "change_book_keeping_industry/1 returns a book_keeping_industry changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_industry, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_industry(struct)
    end
  end
end
