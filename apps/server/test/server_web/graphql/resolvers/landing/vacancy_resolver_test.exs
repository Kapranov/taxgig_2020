defmodule ServerWeb.GraphQL.Resolvers.Landing.VacancyResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Landing.VacancyResolver

  describe "#list" do
    it "returns Vacancies" do
      struct = insert(:vacancy)
      {:ok, data} = VacancyResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id         == struct.id
      assert List.first(data).content    == struct.content
      assert List.first(data).department == struct.department
      assert List.first(data).title      == struct.title
    end
  end

  describe "#show" do
    it "returns specific Vacancy by id" do
      struct = insert(:vacancy)
      {:ok, found} = VacancyResolver.show(nil, %{id: struct.id}, nil)
      assert found.id         == struct.id
      assert found.content    == struct.content
      assert found.department == struct.department
      assert found.title      == struct.title
    end

    it "returns not found when Vacancy does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = VacancyResolver.show(nil, %{id: id}, nil)
      assert error == "The Vacancy #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:vacancy)
      args = %{id: nil}
      {:error, error} = VacancyResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates Vacancy" do
      args = %{
        content: "some text",
        department: "some text",
        title: "some text"
      }
      {:ok, created} = VacancyResolver.create(nil, args, nil)
      assert created.content    == "some text"
      assert created.department == "some text"
      assert created.title      == "some text"
    end

    it "returns error for missing params" do
      args = %{content: nil, department: nil, title: nil}
      {:error, error} = VacancyResolver.create(nil, args, nil)
      assert error == [
        [field: :content, message: "Can't be blank"],
        [field: :department, message: "Can't be blank"],
        [field: :title, message: "Can't be blank"]

      ]
    end
  end

  describe "#update" do
    it "update specific Vacancy by id" do
      struct = insert(:vacancy)
      params = %{
        content: "updated text",
        department: "updated text",
        title: "updated text"
      }
      args = %{id: struct.id, vacancy: params}
      {:ok, updated} = VacancyResolver.update(nil, args, nil)
      assert updated.id         == struct.id
      assert updated.content    == "updated text"
      assert updated.department == "updated text"
      assert updated.title      == "updated text"
    end

    it "nothing change for missing params" do
      struct = insert(:vacancy)
      params = %{}
      args = %{id: struct.id, vacancy: params}
      {:ok, updated} = VacancyResolver.update(nil, args, nil)
      assert updated.id         == struct.id
      assert updated.content    == struct.content
      assert updated.department == struct.department
      assert updated.title      == struct.title
    end

    it "returns error for missing params" do
      insert(:vacancy)
      params = %{content: nil, department: nil, title: nil}
      args = %{id: nil, vacancy: params}
      {:error, error} = VacancyResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific Vacancy by id" do
      struct = insert(:vacancy)
      {:ok, deleted} = VacancyResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when Vacancy does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = VacancyResolver.delete(nil, %{id: id}, nil)
      assert error == "The Vacancy #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:vacancy)
      args = %{id: nil}
      {:error, error} = VacancyResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
