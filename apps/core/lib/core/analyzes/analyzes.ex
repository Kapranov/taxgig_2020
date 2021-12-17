defmodule Core.Analyzes do
  @moduledoc """
  Analyze's Services.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Analyzes.BookKeeping,
    Analyzes.BusinessTaxReturn,
    Analyzes.IndividualTaxReturn,
    Analyzes.SaleTax,
    Contracts.Project,
    Queries,
    Services
  }

  alias Core.Services.BookKeeping, as: ServiceBookKeeping
  alias Core.Services.BookKeepingAnnualRevenue, as: ServiceBookKeepingAnnualRevenue
  alias Core.Services.BookKeepingNumberEmployee, as: ServiceBookKeepingNumberEmployee
  alias Core.Services.BookKeepingTypeClient, as: ServiceBookKeepingTypeClient
  alias Core.Services.BusinessEntityType, as: ServiceBusinessEntityType
  alias Core.Services.BusinessNumberEmployee, as: ServiceBusinessNumberEmployee
  alias Core.Services.BusinessTaxReturn, as: ServiceBusinessTaxReturn
  alias Core.Services.BusinessTotalRevenue, as: ServiceBusinessTotalRevenue
  alias Core.Services.IndividualEmploymentStatus, as: ServiceIndividualEmploymentStatus
  alias Core.Services.IndividualFilingStatus, as: ServiceIndividualFilingStatus
  alias Core.Services.IndividualItemizedDeduction, as: ServiceIndividualItemizedDeduction
  alias Core.Services.IndividualTaxReturn, as: ServiceIndividualTaxReturn
  alias Core.Services.SaleTax, as: ServiceSaleTax
  alias Core.Services.SaleTaxFrequency, as: ServiceSaleTaxFrequency
  alias Core.Services.SaleTaxIndustry, as: ServiceSaleTaxIndustry

  alias Decimal, as: D

  @type word() :: String.t()

  @spec total_all(word, integer) :: [%{atom => word, atom => integer | float}]
  def total_all(id, num \\ 5) do
    case ServiceBookKeeping.by_role(id) do
      {:error, _} ->
        case ServiceBusinessTaxReturn.by_role(id) do
          {:error, _} ->
            case ServiceIndividualTaxReturn.by_role(id) do
              {:error, _} ->
                case ServiceSaleTax.by_role(id) do
                  {:error, msg} -> {:error, msg}
                true ->
                  match = total_match(id)
                  price = total_price(id)
                  [value] = total_value(id) |> Map.values
                  Map.merge(
                    Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
                    Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
                    fn _k, v1, v2 -> Map.merge(v1, v2) end
                  ) |> Enum.map(fn {_k, v} ->
                    record = Map.merge(v, Queries.by_sale_taxes_for_tp(
                      ServiceSaleTax,
                      User,
                      Project,
                      ServiceSaleTaxFrequency,
                      ServiceSaleTaxIndustry,
                      :user_id,
                      :sale_tax_id,
                      v.id,
                      "SaleTax"
                    ))
                    langs = Accounts.get_user!(record.user.id).languages
                    Map.merge(record, %{
                      user: %{
                        avatar: record.user.avatar,
                        first_name: record.user.first_name,
                        id: record.user.id,
                        languages: langs
                      }
                    })
                  end)
                  |> Enum.reject(&(&1.project.status != :New))
                  |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
                  |> Enum.take(num)
                false ->
                    match = total_match(id)
                    price = total_price(id)
                    [value] = total_value(id) |> Map.values
                    Map.merge(
                      Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
                      Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
                      fn _k, v1, v2 -> Map.merge(v1, v2) end
                    ) |> Enum.map(fn {_k, v} ->
                      record = Services.get_sale_tax!(v.id)
                      Map.merge(v, %{
                        name: "SaleTax",
                        user: %{
                          id: record.user_id,
                          first_name: record.user.first_name,
                          last_name: record.user.last_name,
                          middle_name: record.user.middle_name,
                          avatar: record.user.avatar,
                          profession: record.user.profession,
                          languages: record.user.languages,
                          pro_ratings: record.user.pro_ratings
                        }
                      })
                    end)
                    |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
                end
              true ->
                match = total_match(id)
                price = total_price(id)
                [value] = total_value(id) |> Map.values
                Map.merge(
                  Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
                  Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
                  fn _k, v1, v2 -> Map.merge(v1, v2) end
                ) |> Enum.map(fn {_k, v} ->
                  record = Map.merge(v, Queries.by_individual_tax_returns_for_tp(
                    ServiceIndividualTaxReturn,
                    User,
                    Project,
                    ServiceIndividualEmploymentStatus,
                    ServiceIndividualFilingStatus,
                    ServiceIndividualItemizedDeduction,
                    :user_id,
                    :individual_tax_return_id,
                    v.id,
                    "IndividualTaxReturn"
                  ))
                  langs = Accounts.get_user!(record.user.id).languages
                  Map.merge(record, %{
                    user: %{
                      avatar: record.user.avatar,
                      first_name: record.user.first_name,
                      id: record.user.id,
                      languages: langs
                    }
                  })
                end)
                |> Enum.reject(&(&1.project.status != :New))
                |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
                |> Enum.take(num)
              false ->
                match = total_match(id)
                price = total_price(id)
                [value] = total_value(id) |> Map.values
                Map.merge(
                  Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
                  Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
                  fn _k, v1, v2 -> Map.merge(v1, v2) end
                ) |> Enum.map(fn {_k, v} ->
                  record = Services.get_individual_tax_return!(v.id)
                  Map.merge(v, %{
                    name: "IndividualTaxReturn",
                    user: %{
                      id: record.user_id,
                      first_name: record.user.first_name,
                      last_name: record.user.last_name,
                      middle_name: record.user.middle_name,
                      avatar: record.user.avatar,
                      profession: record.user.profession,
                      languages: record.user.languages,
                      platform: record.user.platform,
                      pro_ratings: record.user.pro_ratings
                    }
                  })
                end)
                |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
            end
          true ->
            match = total_match(id)
            price = total_price(id)
            [value] = total_value(id) |> Map.values
            Map.merge(
              Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
              Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
              fn _k, v1, v2 -> Map.merge(v1, v2) end
            ) |> Enum.map(fn {_k, v} ->
              record = Map.merge(v, Queries.by_business_tax_returns_for_tp(
                ServiceBusinessTaxReturn,
                User,
                Project,
                ServiceBusinessEntityType,
                ServiceBusinessNumberEmployee,
                ServiceBusinessTotalRevenue,
                :user_id,
                :business_tax_return_id,
                v.id,
                "BusinessTaxReturn"
              ))
              langs = Accounts.get_user!(record.user.id).languages
              Map.merge(record, %{
                user: %{
                  avatar: record.user.avatar,
                  first_name: record.user.first_name,
                  id: record.user.id,
                  languages: langs
                }
              })
            end)
            |> Enum.reject(&(&1.project.status != :New))
            |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
            |> Enum.take(num)
          false ->
            match = total_match(id)
            price = total_price(id)
            [value] = total_value(id) |> Map.values
            Map.merge(
              Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
              Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
              fn _k, v1, v2 -> Map.merge(v1, v2) end
            ) |> Enum.map(fn {_k, v} ->
              record = Services.get_business_tax_return!(v.id)
              Map.merge(v, %{
                name: "BusinessTaxReturn",
                user: %{
                  id: record.user_id,
                  first_name: record.user.first_name,
                  last_name: record.user.last_name,
                  middle_name: record.user.middle_name,
                  avatar: record.user.avatar,
                  profession: record.user.profession,
                  languages: record.user.languages,
                  platform: record.user.platform,
                  pro_ratings: record.user.pro_ratings
                }
              })
            end)
            |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
        end
      true ->
          match = total_match(id)
          price = total_price(id)
          [value] = total_value(id) |> Map.values
          Map.merge(
            Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
            Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
            fn _k, v1, v2 -> Map.merge(v1, v2) end
          ) |> Enum.map(fn {_k, v} ->
            record = Map.merge(v, Queries.by_book_keepings_for_tp(
              ServiceBookKeeping,
              User,
              Project,
              ServiceBookKeepingAnnualRevenue,
              ServiceBookKeepingNumberEmployee,
              ServiceBookKeepingTypeClient,
              :user_id,
              :book_keeping_id,
              v.id,
              "BookKeeping"
            ))
            langs = Accounts.get_user!(record.user.id).languages
            Map.merge(record, %{
              user: %{
                avatar: record.user.avatar,
                first_name: record.user.first_name,
                id: record.user.id,
                languages: langs
              }
            })
          end)
          |> Enum.reject(&(&1.project.status != :New))
          |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
          |> Enum.take(num)
      false ->
          match = total_match(id)
          price = total_price(id)
          [value] = total_value(id) |> Map.values
          Map.merge(
            Enum.into(match, %{}, fn {k, v} -> {k, %{id: k, sum_match: v}} end),
            Enum.into(price, %{}, fn {k, v} -> {k, %{id: k, sum_price: v, sum_value: value}} end),
            fn _k, v1, v2 -> Map.merge(v1, v2) end
          ) |> Enum.map(fn {_k, v} ->
            record = Services.get_book_keeping!(v.id)
            Map.merge(v, %{
              name: "BookKeeping",
              user: %{
                id: record.user_id,
                first_name: record.user.first_name,
                last_name: record.user.last_name,
                middle_name: record.user.middle_name,
                avatar: record.user.avatar,
                profession: record.user.profession,
                languages: record.user.languages,
                platform: record.user.platform,
                pro_ratings: record.user.pro_ratings
              }
            })
          end)
          |> Enum.reject(&(&1.user.platform.client_limit_reach == true))
          |> Enum.sort_by(&Map.fetch(&1, :sum_match), :desc)
    end
  end

  @spec total_match(word) :: [%{atom => word, atom => integer}]
  def total_match(id) do
    # BookKeeping.check_match_payroll(id)
    # BookKeeping.check_match_book_keeping_additional_need(id)
    # BookKeeping.check_match_book_keeping_annual_revenue(id)
    # BookKeeping.check_match_book_keeping_industry(id)
    # BookKeeping.check_match_book_keeping_number_employee(id)
    # BookKeeping.check_match_book_keeping_type_client(id)
    #
    # BusinessTaxReturn.check_match_business_entity_type(id)
    # BusinessTaxReturn.check_match_business_industry(id)
    # BusinessTaxReturn.check_match_business_number_of_employee(id)
    # BusinessTaxReturn.check_match_business_total_revenue(id)
    #
    # IndividualTaxReturn.check_match_foreign_account(id)
    # IndividualTaxReturn.check_match_home_owner(id)
    # IndividualTaxReturn.check_match_individual_employment_status(id)
    # IndividualTaxReturn.check_match_individual_filing_status(id)
    # IndividualTaxReturn.check_match_individual_industry(id)
    # IndividualTaxReturn.check_match_individual_itemized_deduction(id)
    # IndividualTaxReturn.check_match_living_abroad(id)
    # IndividualTaxReturn.check_match_non_resident_earning(id)
    # IndividualTaxReturn.check_match_own_stock_crypto(id)
    # IndividualTaxReturn.check_match_rental_property_income(id)
    # IndividualTaxReturn.check_match_stock_divident(id)
    #
    # SaleTax.check_match_sale_tax_count(id)
    # SaleTax.check_match_sale_tax_frequency(id)
    # SaleTax.check_match_sale_tax_industry(id)

    case ServiceBookKeeping.by_role(id) do
      {:error, _} ->
        case ServiceBusinessTaxReturn.by_role(id) do
          {:error, _} ->
            case ServiceIndividualTaxReturn.by_role(id) do
              {:error, _} ->
                case ServiceSaleTax.by_role(id) do
                  {:error, msg} -> msg
                  _ ->
                    cnt1 =
                      case SaleTax.check_match_sale_tax_count(id) do
                        :error -> %{}
                        data -> data
                      end

                    cnt2 =
                      case SaleTax.check_match_sale_tax_frequency(id) do
                        :error -> %{}
                        data -> data
                      end

                    cnt3 =
                      case SaleTax.check_match_sale_tax_industry(id) do
                        :error -> %{}
                        data -> data
                      end

                    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
                    Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
                end
              _ ->
                cnt1 =
                  case IndividualTaxReturn.check_match_foreign_account(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt2 =
                  case IndividualTaxReturn.check_match_home_owner(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt3 =
                  case IndividualTaxReturn.check_match_individual_employment_status(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt4 =
                  case IndividualTaxReturn.check_match_individual_filing_status(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt5 =
                  case IndividualTaxReturn.check_match_individual_industry(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt6 =
                  case IndividualTaxReturn.check_match_individual_itemized_deduction(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt7 =
                  case IndividualTaxReturn.check_match_living_abroad(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt8 =
                  case IndividualTaxReturn.check_match_non_resident_earning(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt9 =
                  case IndividualTaxReturn.check_match_own_stock_crypto(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt10 =
                  case IndividualTaxReturn.check_match_rental_property_income(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt11 =
                  case IndividualTaxReturn.check_match_stock_divident(id) do
                    :error -> %{}
                    data -> data
                  end

                rst1 = Map.merge(cnt1,  cnt2, fn _k, v1, v2 -> v1 + v2 end)
                rst2 = Map.merge(rst1,  cnt3, fn _k, v1, v2 -> v1 + v2 end)
                rst3 = Map.merge(rst2,  cnt4, fn _k, v1, v2 -> v1 + v2 end)
                rst4 = Map.merge(rst3,  cnt5, fn _k, v1, v2 -> v1 + v2 end)
                rst5 = Map.merge(rst4,  cnt6, fn _k, v1, v2 -> v1 + v2 end)
                rst6 = Map.merge(rst5,  cnt7, fn _k, v1, v2 -> v1 + v2 end)
                rst7 = Map.merge(rst6,  cnt8, fn _k, v1, v2 -> v1 + v2 end)
                rst8 = Map.merge(rst7,  cnt9, fn _k, v1, v2 -> v1 + v2 end)
                rst9 = Map.merge(rst8, cnt10, fn _k, v1, v2 -> v1 + v2 end)
                Map.merge(rst9, cnt11, fn _k, v1, v2 -> v1 + v2 end)
            end
          _ ->
            cnt1 =
              case BusinessTaxReturn.check_match_business_entity_type(id) do
                :error -> %{}
                data -> data
              end

            cnt2 =
              case BusinessTaxReturn.check_match_business_industry(id) do
                :error -> %{}
                data -> data
              end

            cnt3 =
              case BusinessTaxReturn.check_match_business_number_of_employee(id) do
                :error -> %{}
                data -> data
              end

            cnt4 =
              case BusinessTaxReturn.check_match_business_total_revenue(id) do
                :error -> %{}
                data -> data
              end

            rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
            rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
            Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
        end
              _ ->
                cnt1 =
                  case BookKeeping.check_match_payroll(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt2 =
                  case BookKeeping.check_match_book_keeping_additional_need(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt3 =
                  case BookKeeping.check_match_book_keeping_annual_revenue(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt4 =
                  case BookKeeping.check_match_book_keeping_industry(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt5 =
                  case BookKeeping.check_match_book_keeping_type_client(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt6 =
                  case BookKeeping.check_match_book_keeping_number_employee(id) do
                    :error -> %{}
                    data -> data
                  end

                rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
                rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
                rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
                rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)
                Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)
            end
  end

  @spec total_price(word) :: [%{atom => word, atom => integer}]
  def total_price(id) do
    # BookKeeping.check_price_payroll(id)
    # BookKeeping.check_price_book_keeping_additional_need(id)
    # BookKeeping.check_price_book_keeping_annual_revenue(id)
    # BookKeeping.check_price_book_keeping_number_employee(id)
    # BookKeeping.check_price_book_keeping_transaction_volume(id)
    # BookKeeping.check_price_book_keeping_type_client(id)
    #
    # BusinessTaxReturn.check_price_business_entity_type(id)
    # BusinessTaxReturn.check_price_business_number_of_employee(id)
    # BusinessTaxReturn.check_price_business_total_revenue(id)
    # BusinessTaxReturn.check_price_state(id)
    # BusinessTaxReturn.check_price_tax_year(id)
    #
    # IndividualTaxReturn.check_price_foreign_account(id)
    # IndividualTaxReturn.check_price_home_owner(id)
    # IndividualTaxReturn.check_price_individual_employment_status(id)
    # IndividualTaxReturn.check_price_individual_filing_status(id)
    # IndividualTaxReturn.check_price_individual_itemized_deduction(id)
    # IndividualTaxReturn.check_price_living_abroad(id)
    # IndividualTaxReturn.check_price_non_resident_earning(id)
    # IndividualTaxReturn.check_price_own_stock_crypto(id)
    # IndividualTaxReturn.check_price_rental_property_income(id)
    # IndividualTaxReturn.check_price_sole_proprietorship_count(id)
    # IndividualTaxReturn.check_price_state(id)
    # IndividualTaxReturn.check_price_stock_divident(id)
    # IndividualTaxReturn.check_price_tax_year(id)
    #
    # SaleTax.check_price_sale_tax_count(id)
    # SaleTax.check_price_sale_tax_frequency(id)

    case ServiceBookKeeping.by_role(id) do
      {:error, _} ->
        case ServiceBusinessTaxReturn.by_role(id) do
          {:error, _} ->
            case ServiceIndividualTaxReturn.by_role(id) do
              {:error, _} ->
                case ServiceSaleTax.by_role(id) do
                  {:error, msg} -> msg
                  _ ->
                    cnt1 =
                      case SaleTax.check_price_sale_tax_count(id) do
                        :error -> %{}
                        data -> data
                      end

                    cnt2 =
                      case SaleTax.check_price_sale_tax_frequency(id) do
                        :error -> %{}
                        data -> data
                      end

                    Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
                end
              _ ->
                cnt1 =
                  case IndividualTaxReturn.check_price_foreign_account(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt2 =
                  case IndividualTaxReturn.check_price_home_owner(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt3 =
                  case IndividualTaxReturn.check_price_individual_employment_status(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt4 =
                  case IndividualTaxReturn.check_price_individual_filing_status(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt5 =
                  case IndividualTaxReturn.check_price_individual_itemized_deduction(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt6 =
                  case IndividualTaxReturn.check_price_living_abroad(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt7 =
                  case IndividualTaxReturn.check_price_non_resident_earning(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt8 =
                  case IndividualTaxReturn.check_price_own_stock_crypto(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt9 =
                  case IndividualTaxReturn.check_price_rental_property_income(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt10 =
                  case IndividualTaxReturn.check_price_sole_proprietorship_count(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt11 =
                  case IndividualTaxReturn.check_price_state(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt12 =
                  case IndividualTaxReturn.check_price_stock_divident(id) do
                    :error -> %{}
                    data -> data
                  end

                cnt13 =
                  case IndividualTaxReturn.check_price_tax_year(id) do
                    :error -> %{}
                    data -> data
                  end

                 rst1 = Map.merge(cnt1,   cnt2, fn _k, v1, v2 -> v1 + v2 end)
                 rst2 = Map.merge(rst1,   cnt3, fn _k, v1, v2 -> v1 + v2 end)
                 rst3 = Map.merge(rst2,   cnt4, fn _k, v1, v2 -> v1 + v2 end)
                 rst4 = Map.merge(rst3,   cnt5, fn _k, v1, v2 -> v1 + v2 end)
                 rst5 = Map.merge(rst4,   cnt6, fn _k, v1, v2 -> v1 + v2 end)
                 rst6 = Map.merge(rst5,   cnt7, fn _k, v1, v2 -> v1 + v2 end)
                 rst7 = Map.merge(rst6,   cnt8, fn _k, v1, v2 -> v1 + v2 end)
                 rst8 = Map.merge(rst7,   cnt9, fn _k, v1, v2 -> v1 + v2 end)
                 rst9 = Map.merge(rst8,  cnt10, fn _k, v1, v2 -> v1 + v2 end)
                rst10 = Map.merge(rst9,  cnt11, fn _k, v1, v2 -> v1 + v2 end)
                rst11 = Map.merge(rst10, cnt12, fn _k, v1, v2 -> v1 + v2 end)
                Map.merge(rst11, cnt13, fn _k, v1, v2 -> v1 + v2 end)
            end
          _ ->
            cnt1 =
              case BusinessTaxReturn.check_price_business_entity_type(id) do
                :error -> %{}
                data -> data
              end

            cnt2 =
              case BusinessTaxReturn.check_price_business_number_of_employee(id) do
                :error -> %{}
                data -> data
              end

            cnt3 =
              case BusinessTaxReturn.check_price_business_total_revenue(id) do
                :error -> %{}
                data -> data
              end

            cnt4 =
              case BusinessTaxReturn.check_price_state(id) do
                :error -> %{}
                data -> data
              end

            cnt5 =
              case BusinessTaxReturn.check_price_tax_year(id) do
                :error -> %{}
                data -> data
              end

            rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
            rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
            rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
            Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)
        end
      _ ->
        cnt1 =
          case BookKeeping.check_price_payroll(id) do
            :error -> %{}
            data -> data
          end

        cnt2 =
          case BookKeeping.check_price_book_keeping_additional_need(id) do
            :error -> %{}
            data -> data
          end

        cnt3 =
          case BookKeeping.check_price_book_keeping_annual_revenue(id) do
            :error -> %{}
            data -> data
          end

        cnt4 =
          case BookKeeping.check_price_book_keeping_number_employee(id) do
            :error -> %{}
            data -> data
          end

        cnt5 =
          case BookKeeping.check_price_book_keeping_transaction_volume(id) do
            :error -> %{}
            data -> data
          end

        cnt6 =
          case BookKeeping.check_price_book_keeping_type_client(id) do
            :error -> %{}
            data -> data
          end

        rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
        rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
        rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
        rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)
        Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)
    end
  end

  @spec total_value(word) :: [%{atom => word, atom => float}]
  def total_value(id) do
    # BookKeeping.check_value_payroll(id)
    # BookKeeping.check_value_tax_year(id)
    # BookKeeping.check_value_book_keeping_additional_need(id)
    # BookKeeping.check_value_book_keeping_annual_revenue(id)
    # BookKeeping.check_value_book_keeping_number_employee(id)
    # BookKeeping.check_value_book_keeping_transaction_volume(id)
    # BookKeeping.check_value_book_keeping_type_client(id)
    #
    # BusinessTaxReturn.check_value_accounting_software(id)
    # BusinessTaxReturn.check_value_business_entity_type(id)
    # BusinessTaxReturn.check_value_business_foreign_ownership_count(id)
    # BusinessTaxReturn.check_value_business_total_revenue(id)
    # BusinessTaxReturn.check_value_business_transaction_count(id)
    # BusinessTaxReturn.check_value_dispose_property(id)
    # BusinessTaxReturn.check_value_foreign_shareholder(id)
    # BusinessTaxReturn.check_value_income_over_thousand(id)
    # BusinessTaxReturn.check_value_invest_research(id)
    # BusinessTaxReturn.check_value_k1_count(id)
    # BusinessTaxReturn.check_value_make_distribution(id)
    # BusinessTaxReturn.check_value_state(id)
    # BusinessTaxReturn.check_value_tax_exemption(id)
    # BusinessTaxReturn.check_value_tax_year
    # BusinessTaxReturn.check_value_total_asset_over(id)
    #
    # IndividualTaxReturn.check_value_foreign_account_limit(id)
    # IndividualTaxReturn.check_value_foreign_financial_interest(id)
    # IndividualTaxReturn.check_value_home_owner(id)
    # IndividualTaxReturn.check_value_individual_employment_status(id)
    # IndividualTaxReturn.check_value_individual_filing_status(id)
    # IndividualTaxReturn.check_value_individual_stock_transaction_count(id)
    # IndividualTaxReturn.check_value_k1_count(id)
    # IndividualTaxReturn.check_value_rental_property_income(id)
    # IndividualTaxReturn.check_value_sole_proprietorship_count(id)
    # IndividualTaxReturn.check_value_state(id)
    # IndividualTaxReturn.check_value_tax_year(id)
    #
    # SaleTax.check_value_sale_tax_count(id)

    case ServiceBookKeeping.by_role(id) do
      {:error, _} ->
        case ServiceBusinessTaxReturn.by_role(id) do
          {:error, _} ->
            case ServiceIndividualTaxReturn.by_role(id) do
              {:error, _} ->
                case ServiceSaleTax.by_role(id) do
                  {:error, msg} -> msg
                  _ ->
                    val1 =
                      case SaleTax.check_value_sale_tax_count(id) do
                        :error -> D.new("0")
                        data -> data[id]
                      end

                    %{id => D.new(val1)}
                end
              _ ->
                val1 =
                  case IndividualTaxReturn.check_value_foreign_account_limit(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val2 =
                  case IndividualTaxReturn.check_value_foreign_financial_interest(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val3 =
                  case IndividualTaxReturn.check_value_home_owner(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val4 =
                  case IndividualTaxReturn.check_value_individual_employment_status(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val5 =
                  case IndividualTaxReturn.check_value_individual_filing_status(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val6 =
                  case IndividualTaxReturn.check_value_individual_stock_transaction_count(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val7 =
                  case IndividualTaxReturn.check_value_k1_count(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val8 =
                  case IndividualTaxReturn.check_value_rental_property_income(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val9 =
                  case IndividualTaxReturn.check_value_sole_proprietorship_count(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val10 =
                  case IndividualTaxReturn.check_value_state(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                val11 =
                  case IndividualTaxReturn.check_value_tax_year(id) do
                    :error -> D.new("0")
                    data -> data[id]
                  end

                result =
                  D.add(val1, val2)
                    |> D.add(val3)
                    |> D.add(val4)
                    |> D.add(val5)
                    |> D.add(val6)
                    |> D.add(val7)
                    |> D.add(val8)
                    |> D.add(val9)
                    |> D.add(val10)
                    |> D.add(val11)

                %{id => result}
            end
          _ ->
            val1 =
              case BusinessTaxReturn.check_value_accounting_software(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val2 =
              case BusinessTaxReturn.check_value_business_entity_type(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val3 =
              case BusinessTaxReturn.check_value_business_foreign_ownership_count(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val4 =
              case BusinessTaxReturn.check_value_business_total_revenue(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val5 =
              case BusinessTaxReturn.check_value_business_transaction_count(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val6 =
              case BusinessTaxReturn.check_value_dispose_property(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val7 =
              case BusinessTaxReturn.check_value_foreign_shareholder(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val8 =
              case BusinessTaxReturn.check_value_income_over_thousand(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val9 =
              case BusinessTaxReturn.check_value_invest_research(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val10 =
              case BusinessTaxReturn.check_value_k1_count(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val11 =
              case BusinessTaxReturn.check_value_make_distribution(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val12 =
              case BusinessTaxReturn.check_value_state(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val13 =
              case BusinessTaxReturn.check_value_tax_exemption(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val14 =
              case BusinessTaxReturn.check_value_tax_year (id) do
                :error -> D.new("0")
                data -> data[id]
              end

            val15 =
              case BusinessTaxReturn.check_value_total_asset_over(id) do
                :error -> D.new("0")
                data -> data[id]
              end

            result =
              D.add(val1, val2)
                |> D.add(val3)
                |> D.add(val4)
                |> D.add(val5)
                |> D.add(val6)
                |> D.add(val7)
                |> D.add(val8)
                |> D.add(val9)
                |> D.add(val10)
                |> D.add(val11)
                |> D.add(val12)
                |> D.add(val13)
                |> D.add(val14)
                |> D.add(val15)

            %{id => result}
        end
      _ ->
        val1 =
          case BookKeeping.check_value_payroll(id) do
            :error -> D.new("0")
            data -> data[id]
          end

        val2 =
          case BookKeeping.check_value_tax_year(id) do
            :error -> D.new("0")
            data -> data[id]
          end

        val3 =
          case BookKeeping.check_value_book_keeping_additional_need(id) do
            :error -> D.new("0")
            data -> data[id]
          end

        val4 =
          case BookKeeping.check_value_book_keeping_annual_revenue(id) do
            :error -> D.new("0")
            data -> data[id]
          end

        val5 =
          case BookKeeping.check_value_book_keeping_number_employee(id) do
            :error -> D.new("0")
            data -> data[id]
          end

        val6 =
          case BookKeeping.check_value_book_keeping_transaction_volume(id) do
            :error -> D.new("0")
            data -> data[id]
          end

        val7 =
          case BookKeeping.check_value_book_keeping_type_client(id) do
            :error -> D.new("0")
            data -> data[id]
          end

        result =
          D.add(val1, val2)
            |> D.add(val3)
            |> D.add(val4)
            |> D.add(val5)
            |> D.add(val6)
            |> D.add(val7)

        %{id => result}
    end
  end
end
