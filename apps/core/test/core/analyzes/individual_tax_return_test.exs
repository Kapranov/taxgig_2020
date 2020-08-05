defmodule Core.Analyzes.IndividualTaxReturnTest do
  use Core.DataCase

  alias Core.{
    Analyzes,
    Analyzes.IndividualTaxReturn
  }

  describe "#check_match" do
    test "return match_foreign_account by role Tp" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)
      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)
      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_pro.id => match.match_for_individual_foreign_account}
    end

    test "return match_foreign_account when more one pro by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 44, user: pro3)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert itr_pro1.foreign_account                   == true
      assert itr_pro2.foreign_account                   == true
      assert itr_pro3.foreign_account                   == true
      assert itr_pro1.price_foreign_account             == 22
      assert itr_pro2.price_foreign_account             == 33
      assert itr_pro3.price_foreign_account             == 44
      assert data                                == %{
        itr_pro1.id => match.match_for_individual_foreign_account,
        itr_pro2.id => match.match_for_individual_foreign_account,
        itr_pro3.id => match.match_for_individual_foreign_account
      }
    end

    test "return match_foreign_account by role Pro" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)
      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)
      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_tp.id => match.match_for_individual_foreign_account}
    end

    test "return match_foreign_account when more one tp by role Pro" do
      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, foreign_account: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, foreign_account: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, foreign_account: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_tp1.foreign_account                    == true
      assert itr_tp2.foreign_account                    == true
      assert itr_tp3.foreign_account                    == true
      assert itr_tp1.price_foreign_account              == nil
      assert itr_tp2.price_foreign_account              == nil
      assert itr_tp3.price_foreign_account              == nil
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert data                                == %{
        itr_tp1.id => match.match_for_individual_foreign_account,
        itr_tp2.id => match.match_for_individual_foreign_account,
        itr_tp3.id => match.match_for_individual_foreign_account
      }
    end

    test "return match_home_owner by role Tp" do
    end

    test "return match_home_owner by role Pro" do
    end

    test "return match_individual_employment_status by role Tp" do
    end

    test "return match_individual_employment_status by role Pro" do
    end

    test "return match_individual_filing_status by role Tp" do
    end

    test "return match_individual_filing_status by role Pro" do
    end

    test "return match_individual_industry by role Tp" do
    end

    test "return match_individual_industry by role Pro" do
    end

    test "return match_individual_itemized_deduction by role Tp" do
    end

    test "return match_individual_itemized_deduction by role Pro" do
    end

    test "return match_living_abroad by role Tp" do
    end

    test "return match_living_abroad by role Pro" do
    end

    test "return match_non_resident_earning by role Tp" do
    end

    test "return match_non_resident_earning by role Pro" do
    end

    test "return match_own_stock_crypto by role Tp" do
    end

    test "return match_own_stock_crypto by role Pro" do
    end

    test "return match_rental_property_income by role Tp" do
    end

    test "return match_rental_property_income by role Pro" do
    end

    test "return match_stock_divident by role Tp" do
    end

    test "return match_stock_divident by role Pro" do
    end
  end

  describe "#check_price" do
    test "return price_foreign_account by role Tp" do
    end

    test "return price_foreign_account by role Pro" do
    end

    test "return price_home_owner by role Tp" do
    end

    test "return price_home_owner by role Pro" do
    end

    test "return price_individual_employment_status by role Tp" do
    end

    test "return price_individual_employment_status by role Pro" do
    end

    test "return price_individual_filing_status by role Tp" do
    end

    test "return price_individual_filing_status by role Pro" do
    end

    test "return price_individual_itemized_deduction by role Tp" do
    end

    test "return price_individual_itemized_deduction by role Pro" do
    end

    test "return price_living_abroad by role Tp" do
    end

    test "return price_living_abroad by role Pro" do
    end

    test "return price_non_resident_earning by role Tp" do
    end

    test "return price_non_resident_earning by role Pro" do
    end

    test "return price_own_stock_crypto by role Tp" do
    end

    test "return price_own_stock_crypto by role Pro" do
    end

    test "return price_rental_property_income by role Tp" do
    end

    test "return price_rental_property_income by role Pro" do
    end

    test "return price_sole_proprietorship_count by role Tp" do
    end

    test "return price_sole_proprietorship_count by role Pro" do
    end

    test "return price_state by role Tp" do
    end

    test "return price_state by role Pro" do
    end

    test "return price_stock_divident by role Tp" do
    end

    test "return price_stock_divident by role Pro" do
    end

    test "return price_tax_year by role Tp" do
    end

    test "return price_tax_year by role Pro" do
    end
  end

  describe "#check_value" do
    test "return value_foreign_account_limit by role Tp" do
    end

    test "return value_foreign_account_limit by role Pro" do
    end

    test "return value_foreign_financial_interest by role Tp" do
    end

    test "return value_foreign_financial_interest by role Pro" do
    end

    test "return value_home_owner by role Tp" do
    end

    test "return value_home_owner by role Pro" do
    end

    test "return value_individual_employment_status by role Tp" do
    end

    test "return value_individual_employment_status by role Pro" do
    end

    test "return value_individual_filing_status by role Tp" do
    end

    test "return value_individual_filing_status by role Pro" do
    end

    test "return value_individual_stock_transaction_count by role Tp" do
    end

    test "return value_individual_stock_transaction_count by role Pro" do
    end

    test "return value_k1_count by role Tp" do
    end

    test "return value_k1_count by role Pro" do
    end

    test "return value_rental_property_income by role Tp" do
    end

    test "return value_rental_property_income by role Pro" do
    end

    test "return value_sole_proprietorship_count by role Tp" do
    end

    test "return value_sole_proprietorship_count by role Pro" do
    end

    test "return value_state by role Tp" do
    end

    test "return value_state by role Pro" do
    end

    test "return value_tax_year by role Tp" do
    end

    test "return value_tax_year by role Pro" do
    end
  end

  describe "#total_match" do
    test "return result by total_match where role is Tp" do
    end

    test "return result by total_match where role is Pro" do
    end

    test "return error when is not correct individual_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_match(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "#total_price" do
    test "return result by total_price where role is Tp" do
    end

    test "return result by total_price where role is Pro" do
    end

    test "return error when is not correct individual_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_price(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "total_value" do
    test "return result by total_value where role is Tp" do
    end

    test "return result by total_value where role is Pro" do
    end

    test "return error when is not correct individual_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_value(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "#total_all" do
    test "return result by total_all where role is Tp" do
    end

    test "return result by total_all where role is Pro" do
    end

    test "return error when is not correct individual_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_all(id)
      assert data == {:error, [field: :user_id, message: "UserId Not Found in SaleTax"]}
    end
  end

  @spec format_name(atom() | nil) :: String.t() | nil
  defp format_name(data) do
    if is_nil(data), do: nil, else: to_string(data)
  end

  @spec format_names([atom()] | nil) :: [String.t()] | nil
  defp format_names(data) do
    if is_nil(data) do
      nil
    else
      Enum.reduce(data, [], fn(x, acc) ->
        [to_string(x) | acc]
      end) |> Enum.sort()
    end
  end
end
