defmodule ServerWeb.GraphQL.Resolvers.Products.BookKeepingIndustriesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BookKeepingIndustriesResolver

  describe "#index" do
    it "returns BookKeepingIndustries via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      book_keeping_industry = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == book_keeping_industry.id
      assert List.first(data).inserted_at == book_keeping_industry.inserted_at
      assert List.first(data).name        == book_keeping_industry.name
      assert List.first(data).updated_at  == book_keeping_industry.updated_at

      assert List.first(data).book_keeping_id           == book_keeping_industry.book_keeping_id
      assert List.first(data).book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert List.first(data).book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at

      assert List.last(data).id          == book_keeping_industry.id
      assert List.last(data).inserted_at == book_keeping_industry.inserted_at
      assert List.last(data).name        == book_keeping_industry.name
      assert List.last(data).updated_at  == book_keeping_industry.updated_at

      assert List.last(data).book_keeping_id           == book_keeping_industry.book_keeping_id
      assert List.last(data).book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert List.last(data).book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at
    end

    it "returns BookKeepingIndustries via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      book_keeping_industry = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == book_keeping_industry.id
      assert List.first(data).inserted_at == book_keeping_industry.inserted_at
      assert List.first(data).name        == book_keeping_industry.name
      assert List.first(data).updated_at  == book_keeping_industry.updated_at

      assert List.first(data).book_keeping_id           == book_keeping_industry.book_keeping_id
      assert List.first(data).book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert List.first(data).book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at

      assert List.last(data).id          == book_keeping_industry.id
      assert List.last(data).inserted_at == book_keeping_industry.inserted_at
      assert List.last(data).name        == book_keeping_industry.name
      assert List.last(data).updated_at  == book_keeping_industry.updated_at

      assert List.last(data).book_keeping_id           == book_keeping_industry.book_keeping_id
      assert List.last(data).book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert List.last(data).book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at
    end
  end

  describe "#show" do
    it "returns specific BookKeepingIndustry by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      book_keeping_industry = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:ok, found} = BookKeepingIndustriesResolver.show(nil, %{id: book_keeping_industry.id}, context)

      assert found.id          == book_keeping_industry.id
      assert found.inserted_at == book_keeping_industry.inserted_at
      assert found.name        == book_keeping_industry.name
      assert found.updated_at  == book_keeping_industry.updated_at

      assert found.book_keeping_id           == book_keeping_industry.book_keepings.id
      assert found.book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert found.book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at
    end

    it "returns specific BookKeepingIndustry by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      book_keeping_industry = insert(:pro_book_keeping_industry, book_keepings: book_keeping)
      context = %{context: %{current_user: user}}
      {:ok, found} = BookKeepingIndustriesResolver.show(nil, %{id: book_keeping_industry.id}, context)

      assert found.id          == book_keeping_industry.id
      assert found.inserted_at == book_keeping_industry.inserted_at
      assert found.name        == book_keeping_industry.name
      assert found.updated_at  == book_keeping_industry.updated_at

      assert found.book_keeping_id           == book_keeping_industry.book_keepings.id
      assert found.book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert found.book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at
    end

    it "returns not found when BookKeepingIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      insert(:book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingIndustriesResolver.show(nil, %{id: id}, context)
      assert error == "The BookKeepingIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      insert(:book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingIndustriesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BookKeepingIndustry by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      book_keeping_industry = insert(:tp_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingIndustriesResolver.find(nil, %{id: book_keeping_industry.id}, context)

      assert found.id          == book_keeping_industry.id
      assert found.inserted_at == book_keeping_industry.inserted_at
      assert found.name        == book_keeping_industry.name
      assert found.updated_at  == book_keeping_industry.updated_at

      assert found.book_keeping_id           == book_keeping_industry.book_keepings.id
      assert found.book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert found.book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at
    end

    it "find specific BookKeepingIndustry by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      book_keeping_industry = insert(:pro_book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingIndustriesResolver.find(nil, %{id: book_keeping_industry.id}, context)

      assert found.id          == book_keeping_industry.id
      assert found.inserted_at == book_keeping_industry.inserted_at
      assert found.name        == book_keeping_industry.name
      assert found.updated_at  == book_keeping_industry.updated_at

      assert found.book_keeping_id           == book_keeping_industry.book_keepings.id
      assert found.book_keepings.inserted_at == book_keeping_industry.book_keepings.inserted_at
      assert found.book_keepings.updated_at  == book_keeping_industry.book_keepings.updated_at
    end

    it "returns not found when BookKeepingIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      insert(:book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingIndustriesResolver.find(nil, %{id: id}, context)
      assert error == "The BookKeepingIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      insert(:book_keeping_industry, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BookKeepingIndustriesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BookKeepingIndustry an event by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        book_keeping_id: book_keeping.id,
        name: ["Agriculture/Farming"]
      }

      {:ok, created} = BookKeepingIndustriesResolver.create(nil, args, context)

      assert created.name            == [:"Agriculture/Farming"]
      assert created.book_keeping_id == book_keeping.id
    end

    it "creates BookKeepingIndustry an event by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        book_keeping_id: book_keeping.id,
        name: ["Agriculture/Farming", "Automotive Sales/Repair"]
      }

      {:ok, created} = BookKeepingIndustriesResolver.create(nil, args, context)

      assert created.name            == [:"Agriculture/Farming", :"Automotive Sales/Repair"]
      assert created.book_keeping_id == book_keeping.id
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:book_keeping, user: user)
      context = %{context: %{current_user: user}}
      args = %{book_keeping_id: nil}
      {:error, error} = BookKeepingIndustriesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BookKeepingIndustriesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_book_keeping, user: user)
      book_keeping = insert(:tp_book_keeping, user: user)
      book_keeping_industry = insert(:tp_book_keeping_industry, book_keepings: book_keeping)
      context = %{context: %{current_user: user}}

      params = %{
        book_keeping_id: book_keeping.id,
        name: ["Wholesale Distribution"]
      }

      args = %{id: book_keeping_industry.id, book_keeping_industry: params}
      {:ok, updated} = BookKeepingIndustriesResolver.update(nil, args, context)

      assert updated.id              == book_keeping_industry.id
      assert updated.book_keeping_id == book_keeping.id
      assert updated.inserted_at     == book_keeping_industry.inserted_at
      assert updated.name            == [:"Wholesale Distribution"]
      assert updated.updated_at      == book_keeping_industry.updated_at
    end

    it "update specific BookKeepingIndustriesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_book_keeping, user: user)
      book_keeping = insert(:pro_book_keeping, user: user)
      book_keeping_industry = insert(:pro_book_keeping_industry, book_keepings: book_keeping)
      context = %{context: %{current_user: user}}


      params = %{
        book_keeping_id: book_keeping.id,
        name: ["Transportation", "Wholesale Distribution"]
      }

      args = %{id: book_keeping_industry.id, book_keeping_industry: params}
      {:ok, updated} = BookKeepingIndustriesResolver.update(nil, args, context)

      assert updated.id              == book_keeping_industry.id
      assert updated.book_keeping_id == book_keeping.id
      assert updated.inserted_at     == book_keeping_industry.inserted_at
      assert updated.name            == [:"Transportation", :"Wholesale Distribution"]
      assert updated.updated_at      == book_keeping_industry.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      insert(:book_keeping_industry, book_keepings: book_keeping, name: ["Agriculture/Farming"])
      context = %{context: %{current_user: user}}
      args = %{id: nil, book_keeping_industry: nil}
      {:error, error} = BookKeepingIndustriesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BookKeepingIndustry by id" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      struct = insert(:book_keeping_industry, book_keepings: book_keeping, name: ["Agriculture/Farming"])
      context = %{context: %{current_user: user}}
      {:ok, delete} = BookKeepingIndustriesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BookKeepingIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      insert(:book_keeping_industry, book_keepings: book_keeping, name: ["Agriculture/Farming"])
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingIndustriesResolver.delete(nil, %{id: id}, context)
      assert error == "The BookKeepingIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, user: user)
      insert(:book_keeping_industry, book_keepings: book_keeping, name: ["Agriculture/Farming"])
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingIndustriesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
