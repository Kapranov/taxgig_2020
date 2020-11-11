defmodule ServerWeb.Seeder.StripeAccountToken do
  @moduledoc """
  Seeds for `Stripy.StripeAccountToken` context.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccountToken,
    StripeService.StripePlatformAccountTokenService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeAccountToken)
  end

  @doc """
  Used to create a remote `Stripe.Token` record as well as
  an associated local `StripeAccountToken` record.

  fronend - [:business_type, :first_name, :last_name, :maiden_name, :email, :phone, address: %{:city, :country, :line1, :postal_code, :state}, dob: %{:day, :month, :year}, :ssn_last_4, :tos_shown_and_accepted]
  backend - []

  1. If create a new `StripeAccountToken` and `StripeAccount` this performs only
     one records and for role's pro.
  2. if has one record return error
  3. If `StripeAccountToken` creation fails, don't create `StripeAccount` and return an error
  4. If `StripeAccountToken` creation succeeds return created `StripeAccountToken`

  ## Example

  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_account_token()
  end

  @spec seed_stripe_account_token() :: [Ecto.Schema.t()]
  defp seed_stripe_account_token do
    preloads = [profile: [:us_zipcode]]
    user =
      CoreRepo.get_by(User, %{email: "op@taxgig.com"})
      |> CoreRepo.preload(preloads)

    user_attrs = %{"user_id" => user.id}

    [year, month, day] =
      user.birthday
      |> to_string
      |> String.replace("0", "")
      |> String.split("-")

    # [_, _, _, _, _, num1, num2, num3, num4] = user.ssn |> Integer.digits
    # ssn_last_4 = "#{num1}#{num2}#{num3}#{num4}" |> String.to_integer

    attrs = %{
      business_type: "individual",
      individual: %{
        first_name: user.first_name,
        last_name: user.last_name,
        maiden_name: user.middle_name,
        email: user.email,
        phone: user.phone,
        address: %{
          city: user.profile.us_zipcode.city,
          country: "us",
          line1: user.profile.address,
          postal_code: user.profile.us_zipcode.zipcode,
          state: user.profile.us_zipcode.state
        },
        dob: %{
          day: String.to_integer(day),
          month: String.to_integer(month),
          year: String.to_integer(year)
        },
        ssn_last_4: "0000"
      },
      tos_shown_and_accepted: true
    }

    platform_account_token(attrs, user_attrs)
  end

  @spec platform_account_token(map, map) ::
          {:ok, StripeAccountToken.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_account_token(attrs, user_attrs) do
    querty =
      try do
        Queries.by_value(StripeAccountToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    case StripyRepo.aggregate(querty, :count, :id) < 10 do
      true ->
        case Accounts.by_role(user_attrs["user_id"]) do
          false -> {:error, %Ecto.Changeset{}}
          true ->
            with {:ok,  %StripeAccountToken{} = data} <- StripePlatformAccountTokenService.create(attrs, user_attrs) do
              {:ok, data}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end
