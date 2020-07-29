defmodule Core.Analyzes.SaleTaxTest do
  use Core.DataCase

  alias Core.{
    Analyzes,
    Analyzes.SaleTax
  }

  alias Decimal, as: D

  describe "#check_match" do
    test "return match_sale_tax_count by role Tp" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{st_pro.id => match.match_for_sale_tax_count}
    end

    test "return match_sale_tax_count is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_sale_tax_count: 0)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 0
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{st_pro.id => match.match_for_sale_tax_count}
    end

    test "return match_sale_tax_count is nil by role Tp" do
      match = insert(:match_value_relat, match_for_sale_tax_count: nil)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == nil
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{st_pro.id => 0}
    end

    test "return match_sale_tax_count when price_sale_tax_count is 1 by role Tp" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 1, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 1
      assert data                            == %{}
    end

    test "return match_sale_tax_count when price_sale_tax_count is 0 by role Tp" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 0, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 0
      assert data                            == %{}
    end

    test "return match_sale_tax_count when price_sale_tax_count is nil by role Tp" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: nil, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == nil
      assert data                            == %{}
    end

    test "return match_sale_tax_count when sale_tax_count is 1 by role Tp" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 1, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 1
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{st_pro.id => match.match_for_sale_tax_count}
    end

    test "return match_sale_tax_count when sale_tax_count is 0 by role Tp" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 0, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 0
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == :error
    end

    test "return match_sale_tax_count when sale_tax_count is nil by role Tp" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: nil, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == nil
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == :error
    end

    test "return match_sale_tax_count by role Pro" do
      insert(:match_value_relat)
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, user: user)
      data = SaleTax.check_match_sale_tax_count(struct.id)
      assert data == %{}
    end

    test "return match_sale_tax_count is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_sale_tax_count: 0)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 0
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{st_tp.id => match.match_for_sale_tax_count}
    end

    test "return match_sale_tax_count is nil by role Pro" do
      match = insert(:match_value_relat, match_for_sale_tax_count: nil)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == nil
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{st_tp.id => 0}
    end

    test "return match_sale_tax_count when price_sale_tax_count is 1 by role Pro" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 1, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 1
      assert data                            == %{st_tp.id => match.match_for_sale_tax_count}
    end

    test "return match_sale_tax_count when price_sale_tax_count is 0 by role Pro" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 0, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 0
      assert data                            == :error
    end

    test "return match_sale_tax_count when price_sale_tax_count is nil by role Pro" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: nil, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == nil
      assert data                            == :error
    end

    test "return match_sale_tax_count when sale_tax_count is 1 by role Pro" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 1, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 1
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{}
    end

    test "return match_sale_tax_count when sale_tax_count is 0 by role Pro" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 0, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 0
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{}
    end

    test "return match_sale_tax_count when sale_tax_count is nil by role Pro" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: nil, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == nil
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{}
    end

    test "return match_sale_tax_frequency by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_pro.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_frequency by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_tp.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_industry by role Tp" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_industry(st_tp.id)
      assert match.match_for_sale_tax_industry == 10
      assert format_names(stf_pro.name)        == names
      assert format_names(stf_tp.name)         == name
      assert data                              == %{st_pro.id => match.match_for_sale_tax_industry}
    end

    test "return match_sale_tax_industry by role Pro" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_industry(st_pro.id)
      assert match.match_for_sale_tax_industry == 10
      assert format_names(stf_pro.name)        == names
      assert format_names(stf_tp.name)         == name
      assert data                              == %{st_tp.id => match.match_for_sale_tax_industry}
    end
  end

  describe "#check_price" do
    test "return price_sale_tax_count by role Tp" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_tp.id)
      assert st_pro.price_sale_tax_count == 22
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 22
      assert data                        == %{st_pro.id => 484}
    end

    test "return price_sale_tax_count by role Pro" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_pro.price_sale_tax_count == 22
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 22
      assert data                        == %{st_tp.id => 484}
    end

    test "return price_sale_tax_frequency by role Tp" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_tp.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_pro.id => 22}
    end

    test "return price_sale_tax_frequency by role Pro" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_pro.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_tp.id => 22}
    end
  end

  describe "#check_value" do
    test "return value_sale_tax_count by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 22)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert D.to_string(match.value_for_sale_tax_count) == "22"
      assert st_pro.price_sale_tax_count                 == 22
      assert st_pro.sale_tax_count                       == nil
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == 22
      assert data                                        == %{st_tp.id => D.new("484")}
    end

    test "return value_sale_tax_count by role Pro" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 22)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_pro.id)
      assert D.to_string(match.value_for_sale_tax_count) == "22"
      assert st_pro.price_sale_tax_count                 == 22
      assert st_pro.sale_tax_count                       == nil
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == 22
      assert data                                        == :error
    end
  end

  describe "#total_match" do
    test "return result by total_match by role Tp" do
      name_frequency = "Monthly"
      name_industry = Enum.sort(["Legal"])
      names_industry = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      insert(:pro_sale_tax_frequency, name: name_frequency, price: 22, sale_taxes: st_pro)
      insert(:tp_sale_tax_frequency, name: name_frequency, sale_taxes: st_tp)
      insert(:pro_sale_tax_industry, name: names_industry, sale_taxes: st_pro)
      insert(:tp_sale_tax_industry, name: name_industry, sale_taxes: st_tp)
      data = Analyzes.total_match(st_tp.id)
      assert data == %{st_pro.id => 70}
    end

    test "return result by total_match by role Pro" do
      name_frequency = "Monthly"
      name_industry = Enum.sort(["Legal"])
      names_industry = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      insert(:pro_sale_tax_frequency, name: name_frequency, price: 22, sale_taxes: st_pro)
      insert(:tp_sale_tax_frequency, name: name_frequency, sale_taxes: st_tp)
      insert(:pro_sale_tax_industry, name: names_industry, sale_taxes: st_pro)
      insert(:tp_sale_tax_industry, name: name_industry, sale_taxes: st_tp)
      data = Analyzes.total_match(st_pro.id)
      assert data == %{st_tp.id => 70}
    end
  end

  describe "#total_price" do
    test "return result by total_price by role Tp" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = Analyzes.total_price(st_tp.id)
      assert data == %{st_pro.id => 506}
    end

    test "return result by total_price by role Pro" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = Analyzes.total_price(st_pro.id)
      assert data == %{st_tp.id => 506}
    end
  end

  describe "#total_value" do
    test "return result by total_value by role Tp" do
      insert(:match_value_relat, value_for_sale_tax_count: 22)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = Analyzes.total_value(st_tp.id)
      assert data == %{st_tp.id => D.new("484")}
    end

    test "return result by total_value by role Pro" do
      insert(:match_value_relat, value_for_sale_tax_count: 22)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = Analyzes.total_value(st_pro.id)
      assert data == %{st_pro.id => D.new("0")}
    end
  end

  describe "#total_all" do
    test "return result by total_all by role Tp" do
      name_frequency = "Monthly"
      name_industry = Enum.sort(["Legal"])
      names_industry = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      insert(:match_value_relat, value_for_sale_tax_count: 22)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      insert(:pro_sale_tax_frequency, name: name_frequency, price: 22, sale_taxes: st_pro)
      insert(:tp_sale_tax_frequency, name: name_frequency, sale_taxes: st_tp)
      insert(:pro_sale_tax_industry, name: names_industry, sale_taxes: st_pro)
      insert(:tp_sale_tax_industry, name: name_industry, sale_taxes: st_tp)

      data = Analyzes.total_all(st_tp.id)
      assert data == [
        %{id: st_tp.id, sum_value: %{st_tp.id => D.new("484")}},
        %{id: st_pro.id, sum_match: 70},
        %{id: st_pro.id, sum_price: 748}
      ]
    end

    test "return result by total_all by role Pro" do
      name_frequency = "Monthly"
      name_industry = Enum.sort(["Legal"])
      names_industry = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      insert(:match_value_relat, value_for_sale_tax_count: 22)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      insert(:pro_sale_tax_frequency, name: name_frequency, price: 22, sale_taxes: st_pro)
      insert(:tp_sale_tax_frequency, name: name_frequency, sale_taxes: st_tp)
      insert(:pro_sale_tax_industry, name: names_industry, sale_taxes: st_pro)
      insert(:tp_sale_tax_industry, name: name_industry, sale_taxes: st_tp)

      data = Analyzes.total_all(st_pro.id)
      assert data == [
        %{id: st_pro.id, sum_value: %{st_pro.id => D.new("0")}},
        %{id: st_tp.id, sum_match: 70},
        %{id: st_tp.id, sum_price: 748}
      ]
    end
  end

  @spec format_name(atom()) :: String.t()
  defp format_name(data), do: to_string(data)

  @spec format_names([atom()]) :: [String.t()]
  defp format_names(data) do
    Enum.reduce(data, [], fn(x, acc) ->
      [to_string(x) | acc]
    end) |> Enum.sort()
  end
end
