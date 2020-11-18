defmodule Core.Contracts.ProjectTest do
  use Core.DataCase

  alias Core.Contracts

  describe "project via role's Tp" do
    alias Core.Contracts.Project

    @valid_attrs %{
      end_time: Date.utc_today(),
      id_from_stripe_card: FlakeId.get(),
      id_from_stripe_transfer: FlakeId.get(),
      instant_matched: true,
      project_price: 22,
      status: "Canceled"
    }

    @update_attrs %{
      end_time: Timex.shift(Timex.now, days: -2),
      id_from_stripe_card: FlakeId.get(),
      id_from_stripe_transfer: FlakeId.get(),
      instant_matched: false,
      project_price: 33,
      status: "Done"
    }

    @invalid_attrs %{
      instant_matched: nil,
      status: nil,
      user_id: nil
    }

    test "list_project/0 returns all projects" do
      pro = insert(:pro_user)
      user = insert(:tp_user)
      addon = insert(:tp_addon, user: user)
      offer = insert(:tp_offer, user: user)
      struct = insert(:tp_project, addon: addon, offer: offer, assigned_pro: pro.id, users: user)
      [data] = Contracts.list_project

      assert data.id                      == struct.id
      assert data.addon_id                == addon.id
      assert data.assigned_pro            == pro.id
      assert data.end_time                == struct.end_time
      assert data.id_from_stripe_card     == struct.id_from_stripe_card
      assert data.id_from_stripe_transfer == struct.id_from_stripe_transfer
      assert data.instant_matched         == struct.instant_matched
      assert data.offer_id                == offer.id
      assert data.project_price           == struct.project_price
      assert data.status                  == struct.status
      assert data.user_id                 == user.id
    end

    test "get_project!/1 returns the project with given id" do
      pro = insert(:pro_user)
      user = insert(:tp_user)
      addon = insert(:tp_addon, user: user)
      offer = insert(:tp_offer, user: user)
      struct = insert(:tp_project, addon: addon, offer: offer, assigned_pro: pro.id, users: user)
      data = Contracts.get_project!(struct.id)

      assert data.addon_id                == addon.id
      assert data.assigned_pro            == pro.id
      assert data.end_time                == struct.end_time
      assert data.id                      == struct.id
      assert data.id_from_stripe_card     == struct.id_from_stripe_card
      assert data.id_from_stripe_transfer == struct.id_from_stripe_transfer
      assert data.instant_matched         == struct.instant_matched
      assert data.offer_id                == offer.id
      assert data.project_price           == struct.project_price
      assert data.status                  == struct.status
      assert data.user_id                 == user.id
    end

    test "create_project/1 with valid data creates the project" do
      langs = insert(:language)
      pro = insert(:pro_user, languages: [langs])
      user = insert(:tp_user, languages: [langs])
      addon = insert(:tp_addon, user: user)
      offer = insert(:tp_offer, user: user)

      params = Map.merge(@valid_attrs, %{
        addon_id: addon.id,
        assigned_pro: pro.id,
        offer_id: offer.id,
        user_id: user.id
      })

      assert {:ok, %Project{} = created} =
        Contracts.create_project(params)

      assert %Ecto.Association.NotLoaded{} = created.users
      assert created.addon_id                == addon.id
      assert created.assigned_pro            == pro.id
      assert created.end_time                == Date.utc_today()
      assert created.id_from_stripe_card     == @valid_attrs.id_from_stripe_card
      assert created.id_from_stripe_transfer == @valid_attrs.id_from_stripe_transfer
      assert created.instant_matched         == true
      assert created.offer_id                == offer.id
      assert created.project_price           == 22
      assert created.status                  == :Canceled
      assert created.user_id                 == user.id
    end

    test "create_project/1 with not correct some fields the project" do
      user = insert(:tp_user)
      params = Map.merge(@invalid_attrs, %{ user_id: user.id })
      assert {:error, %Ecto.Changeset{}} = Contracts.create_addon(params)
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_addon(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      langs = insert(:language)
      pro = insert(:pro_user)
      user = insert(:tp_user, languages: [langs])
      addon = insert(:tp_addon, user: user)
      offer = insert(:tp_offer, user: user)
      struct = insert(:tp_project, addon: addon, offer: offer, assigned_pro: pro.id, users: user)
      params = Map.merge(@update_attrs, %{ user_id: user.id })
      assert {:ok, %Project{} = updated} = Contracts.update_project(struct, params)
      assert updated.user_id     == user.id
    end

    test "update_project/2 with invalid data returns error changeset" do
      langs = insert(:language)
      user = insert(:tp_user, languages: [langs])
      struct = insert(:tp_project, users: user)
      assert {:error, %Ecto.Changeset{}} = Contracts.update_project(struct, @invalid_attrs)
    end

#    test "delete_project/1 deletes the project" do
#      langs = insert(:language)
#      user = insert(:tp_user, languages: [langs])
#      struct = insert(:tp_project, users: user)
#      assert {:ok, %Project{}} = Contracts.delete_project(struct)
#      assert_raise Ecto.NoResultsError, fn -> Contracts.get_project!(struct.id) end
#    end
#
#    test "change_project/1 returns the project changeset" do
#      pro = insert(:pro_user)
#      user = insert(:tp_user)
#      addon = insert(:tp_addon, user: user)
#      offer = insert(:tp_offer, user: user)
#      struct = insert(:tp_project, addon: addon, offer: offer, assigned_pro: pro.id, users: user)
#      assert %Ecto.Changeset{} = Contracts.change_project(struct)
#    end
  end
end
