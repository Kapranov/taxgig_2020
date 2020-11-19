defmodule Core.Contracts.ServiceReviewTest do
  use Core.DataCase

  alias Core.Contracts
  alias Decimal, as: D

  describe "service_review" do
    alias Core.Contracts.ServiceReview

    @valid_attrs %{
      client_comment: "some text",
      communication: 22,
      final_rating: 1.99,
      pro_response: "some text",
      professionalism: 22,
      work_quality: 22
    }

    @update_attrs %{
      client_comment: "updated some text",
      communication: 33,
      final_rating: 9.99,
      pro_response: "updated some text",
      professionalism: 33,
      work_quality: 33
    }

    @invalid_attrs %{
      communication: nil,
      final_rating: nil,
      professionalism: nil,
      work_quality: nil
    }

    test "list_service_review/0 returns all service_reviews" do
      struct = insert(:service_review)
      [data] = Contracts.list_service_review

      assert data.id              == struct.id
      assert data.client_comment  == struct.client_comment
      assert data.communication   == struct.communication
      assert data.final_rating    == struct.final_rating
      assert data.pro_response    == struct.pro_response
      assert data.professionalism == struct.professionalism
      assert data.work_quality    == struct.work_quality
    end

    test "get_service_review!/1 returns the service_review with given id" do
      struct = insert(:service_review)
      data = Contracts.get_service_review!(struct.id)

      assert data.id              == struct.id
      assert data.client_comment  == struct.client_comment
      assert data.communication   == struct.communication
      assert data.final_rating    == struct.final_rating
      assert data.pro_response    == struct.pro_response
      assert data.professionalism == struct.professionalism
      assert data.work_quality    == struct.work_quality
    end

    test "create_service_review/1 with valid data creates the service_review" do
      assert {:ok, %ServiceReview{} = created} =
        Contracts.create_service_review(@valid_attrs)

      assert created.client_comment  == "some text"
      assert created.communication   == 22
      assert created.final_rating    == D.new("1.99")
      assert created.pro_response    == "some text"
      assert created.professionalism == 22
      assert created.work_quality    == 22
    end

    test "create_service_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_service_review(@invalid_attrs)
    end

    test "update_service_review/2 with valid data updates the service_review" do
      struct = insert(:service_review)
      assert {:ok, %ServiceReview{} = updated} = Contracts.update_service_review(struct, @update_attrs)
      assert updated.client_comment  == "updated some text"
      assert updated.communication   == 33
      assert updated.final_rating    == D.new("9.99")
      assert updated.pro_response    == "updated some text"
      assert updated.professionalism == 33
      assert updated.work_quality    == 33
    end

    test "update_service_review/2 with invalid data returns error changeset" do
      struct = insert(:service_review)
      assert {:error, %Ecto.Changeset{}} = Contracts.update_service_review(struct, @invalid_attrs)
    end

    test "delete_service_review/1 deletes the service_review" do
      struct = insert(:service_review)
      assert {:ok, %ServiceReview{}} = Contracts.delete_service_review(struct)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_service_review!(struct.id) end
    end

    test "change_service_review/1 returns the service_review changeset" do
      struct = insert(:service_review)
      assert %Ecto.Changeset{} = Contracts.change_service_review(struct)
    end
  end
end
