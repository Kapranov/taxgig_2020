defmodule Core.Accounts.ProfileTest do
  use Core.DataCase

  alias Core.Accounts

  describe "profile" do
    alias Core.{
      Accounts.Profile,
      Config,
      Repo
    }

    alias Core.Media.File, as: FileModel

    @valid_attrs %{
      address: "some text",
      banner: "some text",
      description: "some text",
      logo: nil

    }

    @update_attrs %{
      address: "updated text",
      banner: "updated text",
      description: "updated text"
    }

    @invalid_attrs %{user_id: nil}

    @upload_attrs %{
      id: Ecto.UUID.generate,
      content_type: "image/jpg",
      name: "logo.jpg",
      size: 1111,
      url: "/media/logo.jpg",
      inserted_at: Timex.shift(Timex.now, days: -4),
      updated_at: Timex.shift(Timex.now, days: -3)
    }

    def upload_fixture(attrs \\ %FileModel{}) do
      upload =
        attrs
        |> Map.merge(@upload_attrs)

      upload
    end

    test "list_profile/0 returns all profiles" do
      insert(:profile)

      data =
        Accounts.list_profile()
        |> Repo.preload([:us_zipcode, :user])
        |> Enum.count
      assert data == 1
    end

    test "get_profile!/1 returns the profile with given user_id" do
      struct = insert(:profile)
      data = Accounts.get_profile!(struct.user_id)

      assert data.address           == struct.address
      assert data.banner            == struct.banner
      assert data.description       == struct.description
      assert data.user_id           == struct.user_id
      assert data.us_zipcode_id     == struct.us_zipcode_id

      assert data.logo.id           == struct.logo.id
      assert data.logo.content_type == "image/jpg"
      assert data.logo.name         == "Logo"
      assert data.logo.size         == 5024
      assert data.logo.url          == struct.logo.url
      assert data.logo.inserted_at  == struct.logo.inserted_at
      assert data.logo.updated_at   == struct.logo.updated_at

      assert data.user.id          == struct.user.id
      assert data.user.active      == struct.user.active
      assert data.user.avatar      == struct.user.avatar
      assert data.user.bio         == struct.user.bio
      assert data.user.birthday    == struct.user.birthday
      assert data.user.email       == struct.user.email
      assert data.user.first_name  == struct.user.first_name
      assert data.user.init_setup  == struct.user.init_setup
      assert data.user.last_name   == struct.user.last_name
      assert data.user.middle_name == struct.user.middle_name
      assert data.user.phone       == struct.user.phone
      assert data.user.provider    == struct.user.provider
      assert data.user.role        == struct.user.role
      assert data.user.sex         == struct.user.sex
      assert data.user.ssn         == struct.user.ssn
      assert data.user.street      == struct.user.street
      assert data.user.zip         == struct.user.zip
      assert data.user.inserted_at == struct.user.inserted_at
      assert data.user.updated_at  == struct.user.updated_at

      assert data.us_zipcode.id      == struct.us_zipcode.id
      assert data.us_zipcode.city    == struct.us_zipcode.city
      assert data.us_zipcode.state   == struct.us_zipcode.state
      assert data.us_zipcode.zipcode == struct.us_zipcode.zipcode
    end

    test "create_profile/1 via multi created an user with only user_id" do
      user = insert(:user)
      zipcode = insert(:us_zipcode)
      file = generate_file()
      params = Map.merge(@valid_attrs, %{
        user_id: user.id,
        us_zipcode_id: zipcode.id,
        logo: %{
          content_type: file.content_type,
          name: file.name,
          size: file.size,
          url: file.url
        }
      })
      assert {:ok, %Profile{} = struct} = Accounts.create_profile(params)
      data = struct |> Repo.preload([:us_zipcode, :user])
      assert data.address           == "some text"
      assert data.banner            == "some text"
      assert data.description       == "some text"
      assert data.user_id           == user.id
      assert data.us_zipcode_id     == zipcode.id

      assert data.logo.content_type == "image/jpg"
      assert data.logo.name         == "image_tmp.jpg"
      assert data.logo.size         == 5024
      assert data.logo.url          == file.url
      assert data.logo.inserted_at  == formatting_time(file.inserted_at)
      assert data.logo.updated_at   == formatting_time(file.updated_at)

      assert data.user.id          == user.id
      assert data.user.active      == user.active
      assert data.user.avatar      == user.avatar
      assert data.user.bio         == user.bio
      assert data.user.birthday    == user.birthday
      assert data.user.email       == user.email
      assert data.user.first_name  == user.first_name
      assert data.user.init_setup  == user.init_setup
      assert data.user.last_name   == user.last_name
      assert data.user.middle_name == user.middle_name
      assert data.user.phone       == user.phone
      assert data.user.provider    == user.provider
      assert data.user.role        == user.role
      assert data.user.sex         == user.sex
      assert data.user.ssn         == user.ssn
      assert data.user.street      == user.street
      assert data.user.zip         == user.zip
      assert data.user.inserted_at == user.inserted_at
      assert data.user.updated_at  == user.updated_at

      assert data.us_zipcode.id      == zipcode.id
      assert data.us_zipcode.city    == zipcode.city
      assert data.us_zipcode.state   == zipcode.state
      assert data.us_zipcode.zipcode == zipcode.zipcode
    end

    test "create users_languages schema" do
      data = build(:users_languages)
      assert [
        %Core.Localization.Language{
          id: _,
          abbr: _,
          name: _,
          inserted_at: _,
          updated_at: _,
        }
      ] = data.languages

      assert data.languages |> Enum.count == 1
    end

    test "update_profile/2 with valid data updates the profile" do
      struct = insert(:profile)

      params = Map.merge(@update_attrs, %{})
      data =
        Accounts.get_profile!(struct.user_id)
        |> Repo.preload([:us_zipcode, :user])
      assert {:ok, %Profile{} = updated} = Accounts.update_profile(data, params)
      assert updated.address           == "updated text"
      assert updated.banner            == "updated text"
      assert updated.description       == "updated text"
      assert updated.user_id           == struct.user_id
      assert updated.us_zipcode_id     == struct.us_zipcode_id

      assert updated.logo.content_type == "image/jpg"
      assert updated.logo.name         == "Logo"
      assert updated.logo.size         == 5024
      assert updated.logo.url          == struct.logo.url
      assert updated.logo.inserted_at  == struct.logo.inserted_at

      assert updated.user.id          == struct.user.id
      assert updated.user.active      == struct.user.active
      assert updated.user.avatar      == struct.user.avatar
      assert updated.user.bio         == struct.user.bio
      assert updated.user.birthday    == struct.user.birthday
      assert updated.user.email       == struct.user.email
      assert updated.user.first_name  == struct.user.first_name
      assert updated.user.init_setup  == struct.user.init_setup
      assert updated.user.last_name   == struct.user.last_name
      assert updated.user.middle_name == struct.user.middle_name
      assert updated.user.phone       == struct.user.phone
      assert updated.user.role        == struct.user.role
      assert updated.user.provider    == struct.user.provider
      assert updated.user.sex         == struct.user.sex
      assert updated.user.ssn         == struct.user.ssn
      assert updated.user.street      == struct.user.street
      assert updated.user.zip         == struct.user.zip
      assert updated.user.inserted_at == struct.user.inserted_at
      assert updated.user.updated_at  == struct.user.updated_at

      assert updated.us_zipcode.id      == struct.us_zipcode.id
      assert updated.us_zipcode.city    == struct.us_zipcode.city
      assert updated.us_zipcode.state   == struct.us_zipcode.state
      assert updated.us_zipcode.zipcode == struct.us_zipcode.zipcode
    end

    test "update_profile/2 with valid data updates the profile and its media files" do
      struct = insert(:profile)

      params = Map.merge(@update_attrs, %{})

      data =
        Accounts.get_profile!(struct.user_id)
        |> Repo.preload([:us_zipcode, :user])

      assert {:ok, %Profile{} = updated} = Accounts.update_profile(data, params)

      <<"https://taxgig.me:4001/media/", logo_id::binary-size(64), ".jpg?name=image_tmp.jpg" >> = updated.logo.url

      assert updated.address           == "updated text"
      assert updated.banner            == "updated text"
      assert updated.description       == "updated text"
      assert updated.user_id           == struct.user_id
      assert updated.us_zipcode_id     == struct.us_zipcode_id

      assert updated.logo.name         == "Logo"
      assert updated.logo.url          == "https://taxgig.me:4001/media/#{logo_id}.jpg?name=image_tmp.jpg"
      assert updated.logo.content_type == "image/jpg"
      assert updated.logo.size         == 5024

      %Profile{logo: %{url: logo_url}, id: user_id} = updated

      %URI{path: "/media/" <> logo_path} = URI.parse(logo_url)

      refute File.exists?(Config.get!([Core.Uploaders.Local, :uploads]) <> "/" <> logo_path)

      file = %Plug.Upload{
        content_type: "image/jpg",
        path: Path.absname("test/fixtures/bernie.jpg"),
        filename: "bernie.jpg"
      }

      {:ok, data} = Core.Upload.store(file)

      assert {:ok, updated} =
        Accounts.update_profile(
          updated,
          Map.put(
            @update_attrs,
            :logo,
            %{
              name: file.filename,
              content_type: file.content_type,
              size: data.size,
              url: data.url
            }
          )
        )

      <<"https://taxgig.me:4001/media/", logo_id::binary-size(64), ".jpg?name=bernie.jpg" >> = updated.logo.url

      assert %Profile{} = updated
      assert updated.id == user_id

      refute File.exists?(Config.get!([Core.Uploaders.Local, :uploads]) <> "/" <> logo_path)

      assert updated.logo.name         == "bernie.jpg"
      assert updated.logo.url          == "https://taxgig.me:4001/media/#{logo_id}.jpg?name=bernie.jpg"
      assert updated.logo.content_type == "image/jpg"
      assert updated.logo.size         == 63657

      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(data.url)
    end

    test "update_profile/2 with invalid data returns error changeset" do
      struct = insert(:profile)
      assert {:error, %Ecto.Changeset{}} =
        Accounts.update_profile(struct, @invalid_attrs)

      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end

    test "delete_profile/1 deletes the profile" do
      struct = insert(:profile)
      data = Accounts.get_profile!(struct.user_id)
      assert {:ok, %Profile{}} = Accounts.delete_profile(data)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(data.user_id) end

      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end

    test "delete_profile/1 deletes the profile with media files version 1" do
      struct = insert(:profile)

      data =
        Accounts.get_profile!(struct.user_id)
        |> Repo.preload([:us_zipcode, :user])

      %Profile{logo: %{url: logo_url}, id: user_id} = data
      %URI{path: "/media/" <> logo_path} = URI.parse(logo_url)

      refute File.exists?(Config.get!([Core.Uploaders.Local, :uploads]) <> "/" <> logo_path)

      assert {:ok, %Profile{}} = Accounts.delete_profile(data)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(user_id) end
      refute File.exists?(Config.get!([Core.Uploaders.Local, :uploads]) <> "/" <> logo_path)

      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(data.logo.url)
    end

    test "delete_profile/1 deletes the profile with media files version 2" do
      struct = insert(:profile)

      data =
        Accounts.get_profile!(struct.user_id)
        |> Repo.preload([:us_zipcode, :user])

      %{profile: %Profile{logo: %{url: logo_url}, id: user_id} = data}

      %URI{path: "/media/" <> logo_path} = URI.parse(logo_url)

      refute File.exists?(Config.get!([Core.Uploaders.Local, :uploads]) <> "/" <> logo_path)
      assert {:ok, %Profile{}} = Accounts.delete_profile(data)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(user_id) end
      refute File.exists?(Config.get!([Core.Uploaders.Local, :uploads]) <> "/" <> logo_path)

      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(data.logo.url)
    end

    test "change_profile/1 returns profile changeset" do
      struct = insert(:profile)
      data = Accounts.get_profile!(struct.user_id)
      assert %Ecto.Changeset{} = Accounts.change_profile(data)

      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end
  end

  def generate_file do
    File.cp!("test/fixtures/image.jpg", "test/fixtures/image_tmp.jpg")

    file = %Plug.Upload{
      content_type: "image/jpg",
      path: Path.absname("test/fixtures/image_tmp.jpg"),
      filename: "image_tmp.jpg"
    }

    {:ok, %{
        content_type: content_type,
        name: name,
        size: size,
        url: url
      }
    } = Core.Upload.store(file)

    %Core.Media.File{
      id: Ecto.UUID.generate(),
      content_type: content_type,
      name: name,
      size: size,
      url: url,
      inserted_at: Timex.shift(Timex.now, days: 0),
      updated_at: Timex.shift(Timex.now, days: 0)
    }
  end

  defp formatting_time(timestamp) do
    timestamp
    |> DateTime.truncate(:second)
  end
end
