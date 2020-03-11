defmodule ServerWeb.GraphQL.Resolvers.Accounts.UserResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Accounts.UserResolver

  describe "#list" do
    it "returns accounts an user" do
      struct = insert(:user)
      {:ok, data} = UserResolver.list(%{}, %{}, %{})
      assert length(data) == 1
      assert List.first(data).id          == struct.id
      assert List.first(data).active      == struct.active
      assert List.first(data).admin_role  == struct.admin_role
      assert List.first(data).avatar      == struct.avatar
      assert List.first(data).bio         == struct.bio
      assert List.first(data).birthday    == struct.birthday
      assert List.first(data).email       == struct.email
      assert List.first(data).first_name  == struct.first_name
      assert List.first(data).init_setup  == struct.init_setup
      assert List.first(data).languages   == struct.languages
      assert List.first(data).last_name   == struct.last_name
      assert List.first(data).middle_name == struct.middle_name
      assert List.first(data).phone       == struct.phone
      assert List.first(data).pro_role    == struct.pro_role
      assert List.first(data).provider    == struct.provider
      assert List.first(data).sex         == struct.sex
      assert List.first(data).ssn         == struct.ssn
      assert List.first(data).street      == struct.street
      assert List.first(data).zip         == struct.zip
    end
  end

  describe "#show" do
    it "returns specific accounts an user by id" do
      struct = insert(:user)
      {:ok, found} = UserResolver.show(%{}, %{id: struct.id}, %{})
      assert found.id          == struct.id
      assert found.active      == struct.active
      assert found.admin_role  == struct.admin_role
      assert found.avatar      == struct.avatar
      assert found.bio         == struct.bio
      assert found.birthday    == struct.birthday
      assert found.email       == struct.email
      assert found.first_name  == struct.first_name
      assert found.init_setup  == struct.init_setup
      assert found.languages   == struct.languages
      assert found.last_name   == struct.last_name
      assert found.middle_name == struct.middle_name
      assert found.phone       == struct.phone
      assert found.pro_role    == struct.pro_role
      assert found.provider    == struct.provider
      assert found.sex         == struct.sex
      assert found.ssn         == struct.ssn
      assert found.street      == struct.street
      assert found.zip         == struct.zip
    end

    it "returns not found when accounts an user does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = UserResolver.show(%{}, %{id: id}, %{})
      assert error == "An User #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:user)
      args = %{id: nil, email: nil, password: nil, password_confirmation: nil}
      {:error, error} = UserResolver.show(%{}, args, %{})
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates accounts an user" do
      struct = insert(:language)

      args = %{
        active: false,
        admin_role: false,
        avatar: "some text",
        bio: "some text",
        birthday: Timex.today,
        email: "lugatex@yahoo.com",
        first_name: "some text",
        init_setup: false,
        languages: "chinese",
        last_name: "some text",
        middle_name: "some text",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "some text",
        pro_role: false,
        provider: "google",
        sex: "some text",
        ssn: 123456789,
        street: "some text",
        zip: 123456789
      }
      {:ok, created} = UserResolver.create(%{}, args, %{})
      assert created.active      == false
      assert created.admin_role  == false
      assert created.avatar      == "some text"
      assert created.bio         == "some text"
      assert created.birthday    == Timex.today
      assert created.email       == "lugatex@yahoo.com"
      assert created.first_name  == "some text"
      assert created.init_setup  == false
      assert created.languages   == [struct]
      assert created.last_name   == "some text"
      assert created.middle_name == "some text"
      assert created.phone       == "some text"
      assert created.pro_role    == false
      assert created.provider    == "google"
      assert created.sex         == "some text"
      assert created.ssn         == 123456789
      assert created.street      == "some text"
      assert created.zip         == 123456789
    end

    it "returns error for missing params" do
      args = %{email: nil, password: nil, password_confirmation: nil}
      {:error, error} = UserResolver.create(%{}, args, %{})
      assert error == [
        [field: :email, message: "Can't be blank"],
        [field: :password, message: "Can't be blank"],
        [field: :password_confirmation, message: "Can't be blank"]
      ]
    end
  end

  describe "#update" do
    it "update specific accounts an user by id" do
      struct_a = insert(:language, abbr: "fra", name: "french")
      struct_b = insert(:user)

      params = %{
        active: true,
        admin_role: true,
        avatar: "updated text",
        bio: "updated text",
        birthday: Timex.today,
        email: "kapranov.lugatex@gmail.com",
        first_name: "updated text",
        init_setup: true,
        languages: "french",
        last_name: "updated text",
        middle_name: "updated text",
        password: "qwertyyy",
        password_confirmation: "qwertyyy",
        phone: "updated text",
        pro_role: true,
        provider: "facebook",
        sex: "updated text",
        ssn: 987654321,
        street: "updated text",
        zip: 987654321
      }
      args = %{id: struct_b.id, user: params}
      {:ok, updated} = UserResolver.update(%{}, args, %{})
      assert updated.id          == struct_b.id
      assert updated.active      == true
      assert updated.admin_role  == true
      assert updated.avatar      == "updated text"
      assert updated.bio         == "updated text"
      assert updated.birthday    == Timex.today
      assert updated.email       == "kapranov.lugatex@gmail.com"
      assert updated.first_name  == "updated text"
      assert updated.init_setup  == true
      assert updated.languages   == [struct_a]
      assert updated.last_name   == "updated text"
      assert updated.middle_name == "updated text"
      assert updated.phone       == "updated text"
      assert updated.pro_role    == true
      assert updated.provider    == "facebook"
      assert updated.sex         == "updated text"
      assert updated.ssn         == 987654321
      assert updated.street      == "updated text"
      assert updated.zip         == 987654321
    end

    it "return error when some params for missing params" do
      struct = insert(:user)
      params = %{}
      args = %{id: struct.id, user: params}
      {:error, error} = UserResolver.update(%{}, args, %{})
      assert error == [
        [field: :password, message: "Can't be blank"],
        [field: :password_confirmation, message: "Can't be blank"]
      ]
    end

    it "returns error for missing params" do
      insert(:user)
      params = %{email: nil, password: nil, password_confirmation: nil}
      args = %{id: nil, user: params}
      {:error, error} = UserResolver.update(%{}, args, %{})
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific accounts an user by id" do
      struct = insert(:user)
      {:ok, deleted} = UserResolver.delete(%{}, %{id: struct.id}, %{})
      assert deleted.id == struct.id
    end

    it "returns not found when accounts an user does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = UserResolver.delete(%{}, %{id: id}, %{})
      assert error == "An User #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:user)
      args = %{id: nil}
      {:error, error} = UserResolver.delete(%{}, args, %{})
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#get_code" do
    it "return code by google" do
      args = %{provider: "google"}
      {:ok, %{code: code}} = UserResolver.get_code(%{}, args, %{})
      assert code =~ "https://accounts.google.com/o/oauth2/v2/auth?"
    end

    it "return code by linkedin" do
      args = %{provider: "linkedin"}
      {:ok, %{code: code}} = UserResolver.get_code(%{}, args, %{})
      assert code =~ "https://www.linkedin.com/oauth/v2/authorization?"
    end

    it "return code by facebook" do
      args = %{provider: "facebook"}
      {:ok, %{code: code}} = UserResolver.get_code(%{}, args, %{})
      assert code == :ok
    end

    it "return code by twitter" do
      args = %{provider: "twitter"}
      {:ok, %{code: code}} = UserResolver.get_code(%{}, args, %{})
      assert code == :ok
    end

    it "return error by localhost" do
      args = %{provider: "localhost"}
      {:ok, %{error: error}} = UserResolver.get_code(%{}, args, %{})
      assert error == "invalid provider"
    end

    it "return error when provider is nil" do
      args = %{provider: nil}
      {:ok, %{error: error}} = UserResolver.get_code(%{}, args, %{})
      assert error == "invalid provider"
    end

    it "return error when provider isn't exist" do
      args = %{provider: "xxx"}
      {:ok, %{error: error}} = UserResolver.get_code(%{}, args, %{})
      assert error == "invalid provider"
    end

    it "return error without provider" do
      args = %{}
      {:ok, %{error: error}} = UserResolver.get_code(%{}, args, %{})
      assert error == "invalid provider"
    end
  end

  describe "#get_token" do
    it "return token by google" do
      args = %{provider: "google", code: "ok_code"}
      {:ok, data} = UserResolver.get_token(%{}, args, %{})
      assert data == %{
        access_token: "token1",
        error: nil,
        error_description: nil,
        expires_in: 3570,
        id_token: "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3ZDU1ZmY0ZTEwOTkxZDZiMGVmZDM5MmI5MWEzM2U1NGMwZTIxOGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyMDA5MzI5NjI2MjE1NzU4MTgiLCJlbWFpbCI6ImthcHJhbm92Lmx1Z2F0ZXhAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJYY3p0RVZCTTI1VUFFRkZyYWpyR3lBIiwibmFtZSI6IkthcHJhbm92IE9sZWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2ctbEl3VEZYVnFUZXFBUWEzbGJVV01HSXAwS3RzQkZFeHV4WTdlPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkthcHJhbm92IiwiZmFtaWx5X25hbWUiOiJPbGVnIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE1ODMwODIzMDMsImV4cCI6MTU4MzA4NTkwM30.jb20PuqB2-ZqMCALYi9t2iKxiCgaYxh5ccjSzmLoS_GkxpegtVu0GnGocbHifieJCrU4K-XpjWkFtSaL9mOmVVWQXnUtXuZKIoPDQFRsD3WMlmCmXAw-fLf_cMGZqf2FbEu1uSvIWrgRIXhnZHfaGXJDp3_kWPyU-5bBNrzdSTmMmnVf2kr5b-lMHueNikTHRk2ovFn6HV_NZX318LV8Yf5EU68j-tWIEIL3IrloFTN0c7zvqIT77S2oY473fNUmRQQJ-ch9myyHMpOExm85t1duYWp8oDVScM9d3P09s_qIDAtxQAUldYjc6eszAVdfd5jPafH-5VEDq_CcYr7peA",
        provider: "google",
        refresh_token: nil,
        scope: "openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile",
        token_type: "Bearer"
      }
    end

    it "return token by linkedin" do
      args = %{provider: "linkedin", code: "ok_code"}
      {:ok, data} = UserResolver.get_token(%{}, args, %{})
      assert data == %{
        access_token: "token1",
        error: nil,
        error_description: nil,
        expires_in: 5183999,
        provider: "linkedin"
      }
    end

    it "return token by facebook" do
      args = %{provider: "facebook", code: "ok_code"}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "facebook"
      }
    end

    it "return token by twitter" do
      args = %{provider: "twitter", code: "ok_code"}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "twitter"
      }
    end

    it "return error token by localhost" do
      args = %{provider: "localhost", code: "ok_code"}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "localhost"
      }
    end

    it "return error when provider isn't exist" do
      args = %{provider: "xxx", code: "ok_code"}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "xxx"
      }
    end

    it "return error when provider is empty string" do
      args = %{provider: "", code: "ok_code"}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: ""
      }
    end

    it "return error when provider is nil" do
      args = %{provider: nil, code: "ok_code"}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: nil
      }
    end

    it "return error when only code" do
      args = %{code: "ok_code"}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: nil
      }
    end

    it "return error when code isn't correct" do
      args = %{provider: "google", code: nil}
      {:ok, error} = UserResolver.get_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "google"
      }
    end
  end

  describe "#get_refresh_token_code" do
    it "return refresh code by google" do
      args = %{provider: "google"}
      {:ok, %{code: data}} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert data =~ "https://accounts.google.com/o/oauth2/v2/auth?"
    end

    it "return refresh code by linkedin" do
      args = %{provider: "linkedin", token: "token1"}
      {:ok, %{code: data}} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert data =~ "https://www.linkedin.com/oauth/v2/accessToken"
    end

    it "return refresh code by linkedin when token isn't correct" do
      args = %{provider: "linkedin", token: "xxx"}
      {:ok, %{code: data}} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert data =~ "https://www.linkedin.com/oauth/v2/accessToken&grant_type=refresh_token&refresh_token=xxx"
    end

    it "return nil refresh code by linkedin when token is nil" do
      args = %{provider: "linkedin", token: nil}
      assert UserResolver.get_refresh_token_code(%{}, args, %{}) == {:ok, %{
          code: nil,
          provider: "linkedin"
        }}
    end

    it "return nil refresh code by linkedin" do
      args = %{provider: "linkedin", code: "ok_code"}
      assert UserResolver.get_refresh_token_code(%{}, args, %{}) == {:ok, %{
          code: nil,
          provider: "linkedin"
        }}
    end

    it "return refresh code by facebook" do
      args = %{provider: "facebook"}
      {:ok, data} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert data == %{code: :ok, provider: "facebook"}
    end

    it "return refresh code by twitter" do
      args = %{provider: "twitter"}
      {:ok, data} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert data == %{code: :ok, provider: "twitter"}
    end

    it "return error when provider isn't correct" do
      args = %{provider: "xxx"}
      {:ok, error} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "xxx"
      }
    end

    it "return error when provider is nil" do
      args = %{provider: nil}
      {:ok, error} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: nil
      }
    end

    it "return error when provider doesn't exist" do
      args = %{}
      {:ok, error} = UserResolver.get_refresh_token_code(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: nil
      }
    end
  end

  describe "#get_refresh_token" do
    it "return refresh token by google" do
      args = %{provider: "google", token: "token1"}
      {:ok, data} = UserResolver.get_refresh_token(%{}, args, %{})
      assert data == %{
        access_token: "token1",
        error: nil,
        error_description: nil,
        expires_in: nil,
        id_token: nil,
        provider: "google",
        refresh_token: nil,
        scope: nil,
        token_type: nil
      }
    end

    it "return error refresh token by google when isn't correct" do
      args = %{provider: "google", token: nil}
      {:ok, error} = UserResolver.get_refresh_token(%{}, args, %{})
      assert error == %{
        error: "invalid_grant",
        error_description: "Bad Request",
        provider: "google",
        access_token: nil,
        expires_in: nil,
        id_token: nil,
        refresh_token: nil,
        scope: nil,
        token_type: nil
      }
    end

    it "return error token by google when doesn't exist" do
      args = %{provider: "google"}
      {:ok, error} = UserResolver.get_refresh_token(%{}, args, %{})
      assert error == %{
        error: "invalid_grant",
        error_description: "Bad Request",
        provider: "google",
        access_token: nil,
        expires_in: nil,
        id_token: nil,
        refresh_token: nil,
        scope: nil,
        token_type: nil
      }
    end

    it "return refresh token by linkedin" do
      args = %{provider: "linkedin", token: "token1"}
      {:ok, data} = UserResolver.get_refresh_token(%{}, args, %{})
      assert data == %{
        access_token: nil,
        error: "access_denied",
        error_description: "Refresh token not allowed",
        expires_in: nil,
        id_token: nil,
        provider: "linkedin",
        refresh_token: nil,
        scope: nil,
        token_type: nil
      }
    end

    it "return error token by linkedin when is nil" do
      args = %{provider: "linkedin", token: nil}
      {:ok, error} = UserResolver.get_refresh_token(%{}, args, %{})
      assert error == %{
        error: "invalid_grant",
        error_description: "The provided authorization grant or refresh token is invalid, expired or revoked.",
        access_token: nil,
        expires_in: nil,
        id_token: nil,
        provider: "linkedin",
        refresh_token: nil,
        scope: nil,
        token_type: nil
      }
    end

    it "return error token by linkedin when doesn't exist" do
      args = %{provider: "linkedin"}
      {:ok, error} = UserResolver.get_refresh_token(%{}, args, %{})
      assert error == %{
        error: "invalid_grant",
        error_description: "The provided authorization grant or refresh token is invalid, expired or revoked.",
        access_token: nil,
        expires_in: nil,
        id_token: nil,
        provider: "linkedin",
        refresh_token: nil,
        scope: nil,
        token_type: nil
      }
    end

    it "return refresh token  by facebook" do
      args = %{provider: "facebook"}
      {:ok, %{access_token: data}} = UserResolver.get_refresh_token(%{}, args, %{})
      assert data == :ok
    end

    it "return refresh token  by twitter" do
      args = %{provider: "twitter"}
      {:ok, %{access_token: data}} = UserResolver.get_refresh_token(%{}, args, %{})
      assert data == :ok
    end

    it "return error when provider is nil" do
      args = %{provider: nil}
      {:ok, error} = UserResolver.get_refresh_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: nil
      }
    end

    it "return error when provider dosn't exist" do
      args = %{}
      {:ok, error} = UserResolver.get_refresh_token(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: nil
      }
    end
  end

  describe "#verify_token" do
    it "return checked out token by google" do
      args = %{provider: "google", token: "token1"}
      {:ok, data} = UserResolver.verify_token(%{}, args, %{})
      assert data == %{
        access_type: "online",
        aud: "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
        azp: "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
        error: nil,
        error_description: nil,
        exp: "1583085800",
        expires_in: "3320",
        provider: "google",
        scope: "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid",
        sub: "108200932962621575818"
      }
    end

    it "return error new token by google when isn't correct" do
      args = %{provider: "google", token: nil}
      {:ok, error} = UserResolver.verify_token(%{}, args, %{})
      assert error == %{
        access_type: nil,
        aud: nil,
        azp: nil,
        error: "invalid_verify_token",
        error_description: "Invalid Value",
        exp: nil,
        expires_in: nil,
        provider: "google",
        scope: nil,
        sub: nil
      }
    end

    it "return error new token by google when doesn't exist" do
      args = %{provider: "google"}
      {:ok, error} = UserResolver.verify_token(%{}, args, %{})
      assert error == %{
        error: "invalid_verify_token",
        error_description: "Invalid Value",
        provider: "google",
        access_type: nil,
        aud: nil,
        azp: nil,
        exp: nil,
        expires_in: nil,
        scope: nil,
        sub: nil
      }
    end

    it "return checked out token by linkedin" do
      args = %{provider: "linkedin", token: "token1"}
      {:ok, data} = UserResolver.verify_token(%{}, args, %{})
      assert data ==  %{
        email: "lugatex@yahoo.com",
        provider: "linkedin"
      }
    end

    it "return error token by linkedin when token is nil" do
      args = %{provider: "linkedin", token: nil}
      {:ok, data} = UserResolver.verify_token(%{}, args, %{})
      assert data == %{
        error: "Invalid access token",
        error_description: "serviceErrorCode 65600 and 401 status"
      }
    end

    it "return error token by linkedin when token doesn't exist" do
      args = %{provider: "linkedin"}
      {:ok, data} = UserResolver.verify_token(%{}, args, %{})
      assert data == %{
        error: "Invalid access token",
        error_description: "serviceErrorCode 65600 and 401 status"
      }

    end

    it "return checked out token by facebook" do
      args = %{provider: "facebook"}
      {:ok, data} = UserResolver.verify_token(%{}, args, %{})
      assert data == %{access_token: :ok, provider: "facebook"}
    end

    it "return checked out token by twitter" do
      args = %{provider: "twitter"}
      {:ok, data} = UserResolver.verify_token(%{}, args, %{})
      assert data == %{access_token: :ok, provider: "twitter"}
    end
  end

  describe "#signup" do
    it "create user used code by google and return access token" do
      args = %{provider: "google", code: "ok_code"}
      {:ok, data} = UserResolver.signup(%{}, args, %{})
      assert data.access_token =~ "SFMyNTY"
      assert data.provider     == "google"
    end

    it "return error by google when code is nil" do
      args = %{provider: "google", code: nil}
      {:ok, error} = UserResolver.signup(%{}, args, %{})
      assert error == %{
        error: "invalid grant",
        error_description: "Bad Request",
        provider: "google"
      }
    end

    it "return error by google when code doesn't exist" do
      args = %{provider: "google"}
      {:ok, error} = UserResolver.signup(%{}, args, %{})
      assert error == %{
        error: "invalid grant",
        error_description: "Bad Request",
        provider: "google"
      }
    end

    it "create user used code by linkedin and return access token" do
      args = %{provider: "linkedin", code: "ok_code"}
      {:ok, data} = UserResolver.signup(%{}, args, %{})
      assert data.access_token =~ "SFMyNTY"
      assert data.provider     == "linkedin"
    end

    it "return error by linkedin when code is nil" do
      args = %{provider: "linkedin", code: nil}
      {:ok, error} = UserResolver.signup(%{}, args, %{})
      assert error == %{
        error: "invalid_request",
        error_description: "Unable to retrieve access token: authorization code not found",
        provider: "linkedin"
      }
    end

    it "create user used code by facebook and return access token" do
      args = %{provider: "facebook"}
      {:ok, data} = UserResolver.signup(%{}, args, %{})
      assert data == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "facebook"
      }
    end

    it "create user used code by twitter and return access token" do
      args = %{provider: "twitter"}
      {:ok, data} = UserResolver.signup(%{}, args, %{})
      assert data == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "twitter"
      }
    end

    it "create user via localhost and return access token" do
      args = %{
        email: "oleg@yahoo.com",
        password: "qwerty",
        password_confirmation: "qwerty",
        provider: "localhost"
      }
      {:ok, data} = UserResolver.signup(%{}, args, %{})
      assert %{
        access_token: _access_token,
        provider: "localhost"
      } = data

    end

    it "return error via localhost when args nil" do
      args = %{provider: "localhost"}
      {:error, error} = UserResolver.signup(%{}, args, %{})
      assert error == [
        [field: :email, message: "Can't be blank"],
        [field: :password, message: "Can't be blank"],
        [field: :password_confirmation, message: "Can't be blank"]
      ]
    end
  end

  describe "#signin" do
    it "signin via google and return access token" do
      insert(:user, provider: "google", email: "kapranov.lugatex@gmail.com")
      args = %{provider: "google", code: "ok_code"}
      {:ok, data} = UserResolver.signin(%{}, args, %{})
      assert data.access_token =~ "SFMyNTY"
      assert data.provider     == "google"
    end

    it "return error via google when code is nil" do
      args = %{provider: "google", code: nil}
      {:ok, error} = UserResolver.signin(%{}, args, %{})
      assert error == %{
        error: "invalid grant",
        error_description: "Bad Request",
        provider: "google"
      }
    end

    it "return error via google when code doesn't exist" do
      args = %{provider: "google"}
      {:ok, error} = UserResolver.signin(%{}, args, %{})
      assert error == %{
        error: "invalid grant",
        error_description: "Bad Request",
        provider: "google"
      }
    end

    it "signin via linkedin and return access token" do
      insert(:user, provider: "linkedin", email: "lugatex@yahoo.com")
      args = %{provider: "linkedin", code: "ok_code"}
      {:ok, data} = UserResolver.signin(%{}, args, %{})
      assert data.access_token =~ "SFMyNTY"
      assert data.provider     == "linkedin"
    end

    it "return error via linkedin when code is nil" do
      args = %{provider: "linkedin", code: nil}
      {:ok, error} = UserResolver.signin(%{}, args, %{})
      assert error == %{
        error: "invalid_request",
        error_description: "Unable to retrieve access token: authorization code not found",
        provider: "linkedin"
      }
    end

    it "return error via linkedin when code doesn't exist" do
      args = %{provider: "linkedin"}
      {:ok, error} = UserResolver.signin(%{}, args, %{})
      assert error == %{
        error: "invalid_request",
        error_description: "Unable to retrieve access token: authorization code not found",
        provider: "linkedin"
      }
    end

    it "signin via facebook and return access token" do
      args = %{provider: "facebook"}
      {:ok, error} = UserResolver.signin(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "facebook"
      }
    end

    it "signin via twitter and return access token" do
      args = %{provider: "twitter"}
      {:ok, error} = UserResolver.signin(%{}, args, %{})
      assert error == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: "twitter"
      }
    end

    it "signin via localhost and return access token" do
      struct =
        insert(:user,
          provider: "localhost",
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          password_hash: "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s"
        )
      Argon2.verify_pass(struct.password, "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s")
      args = %{provider: "localhost", email: struct.email, password: "qwerty"}
      {:ok, data} = UserResolver.signin(%{}, args, %{})
      assert %{
        access_token: access_token,
        provider: "localhost"
      } = data
      assert data == %{
        access_token: access_token,
        provider: struct.provider
      }
    end

    it "return error via localhost when email is nil" do
      struct =
        insert(:user,
          provider: "localhost",
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          password_hash: "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s"
        )
      Argon2.verify_pass(struct.password, "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s")
      args = %{provider: "localhost", email: nil, password: "qwerty"}
      {:ok, data} = UserResolver.signin(%{}, args, %{})
      assert data == %{
        error: "invalid an email",
        error_description: "an email is empty or doesn't correct",
        provider: "localhost"
      }
    end

    it "return error via localhost when password is nil" do
      struct =
        insert(:user,
          provider: "localhost",
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          password_hash: "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s"
        )
      Argon2.verify_pass(struct.password, "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s")
      args = %{provider: "localhost", email: struct.email, password: nil}
      {:ok, data} = UserResolver.signin(%{}, args, %{})
      assert data == %{
        error: "invalid password",
        error_description: "password is not a string",
        provider: "localhost"
      }
    end

    it "return error when args is nil" do
      struct =
        insert(:user,
          provider: "localhost",
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          password_hash: "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s"
        )
      Argon2.verify_pass(struct.password, "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s")
      args = %{}
      {:ok, data} = UserResolver.signin(%{}, args, %{})
      assert data == %{
        error: "invalid provider",
        error_description: "invalid url by provider",
        provider: nil
      }
    end
  end
end
