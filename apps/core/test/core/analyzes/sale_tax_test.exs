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

    test "return match_sale_tax_count when more one pro by role Tp" do
      match = insert(:match_value_relat)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      tp = insert(:tp_user, languages: [])
      st_pro1 = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro1)
      st_pro2 = insert(:pro_sale_tax, price_sale_tax_count: 44, user: pro2)
      st_pro3 = insert(:pro_sale_tax, price_sale_tax_count: 55, user: pro3)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_tp.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro1.price_sale_tax_count    == 33
      assert st_pro2.price_sale_tax_count    == 44
      assert st_pro3.price_sale_tax_count    == 55
      assert data                            == %{
        st_pro1.id => match.match_for_sale_tax_count,
        st_pro2.id => match.match_for_sale_tax_count,
        st_pro3.id => match.match_for_sale_tax_count
      }
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
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp.sale_tax_count            == 22
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{st_tp.id => match.match_for_sale_tax_count}
    end

    test "return match_sale_tax_count when more one tp by role Pro" do
      match = insert(:match_value_relat)
      pro = insert(:pro_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      st_tp1 = insert(:tp_sale_tax, sale_tax_count: 22, user: tp1)
      st_tp2 = insert(:tp_sale_tax, sale_tax_count: 33, user: tp2)
      st_tp3 = insert(:tp_sale_tax, sale_tax_count: 44, user: tp3)
      data = SaleTax.check_match_sale_tax_count(st_pro.id)
      assert match.match_for_sale_tax_count  == 50
      assert st_tp1.sale_tax_count           == 22
      assert st_tp2.sale_tax_count           == 33
      assert st_tp3.sale_tax_count           == 44
      assert st_pro.price_sale_tax_count     == 33
      assert data                            == %{
        st_tp1.id => match.match_for_sale_tax_count,
        st_tp2.id => match.match_for_sale_tax_count,
        st_tp3.id => match.match_for_sale_tax_count
      }
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

    test "return match_sale_tax_frequency when more one pro by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      st_pro1 = insert(:pro_sale_tax, user: pro1)
      st_pro2 = insert(:pro_sale_tax, user: pro2)
      st_pro3 = insert(:pro_sale_tax, user: pro3)
      stf_pro1 = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro1)
      stf_pro2 = insert(:pro_sale_tax_frequency, name: name, price: 33, sale_taxes: st_pro2)
      stf_pro3 = insert(:pro_sale_tax_frequency, name: name, price: 44, sale_taxes: st_pro3)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro1.name)          == "Monthly"
      assert format_name(stf_pro2.name)          == "Monthly"
      assert format_name(stf_pro3.name)          == "Monthly"
      assert stf_pro1.price                      == 22
      assert stf_pro2.price                      == 33
      assert stf_pro3.price                      == 44
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{
        st_pro1.id => match.match_for_sale_tax_frequency,
        st_pro2.id => match.match_for_sale_tax_frequency,
        st_pro3.id => match.match_for_sale_tax_frequency,
      }
    end

    test "return match_sale_tax_frequency when match is 0 by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat, match_for_sale_tax_frequency: 0)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 0
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_pro.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_frequency when match is 1 by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat, match_for_sale_tax_frequency: 1)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 1
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_pro.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_frequency when price is 0 by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 0, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 0
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return match_sale_tax_frequency when price is nil by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: nil, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == nil
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return match_sale_tax_frequency when price is 1 by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 1, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 1
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_pro.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_frequency when name is nil by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: nil, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert stf_tp.name                        == nil
      assert stf_tp.price                       == nil
      assert data                               == :error
    end

    test "return match_sale_tax_frequency when name is diffrence by role Tp" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: "Quarterly", sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_tp.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Quarterly"
      assert stf_tp.price                       == nil
      assert data                               == %{}
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

    test "return match_sale_tax_frequency when more one tp by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      stf_pro = insert(:tp_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      st_tp1 = insert(:tp_sale_tax, user: tp1)
      st_tp2 = insert(:tp_sale_tax, user: tp2)
      st_tp3 = insert(:tp_sale_tax, user: tp3)
      stf_tp1 = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp1)
      stf_tp2 = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp2)
      stf_tp3 = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp3)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_tp1.name)          == "Monthly"
      assert format_name(stf_tp2.name)          == "Monthly"
      assert format_name(stf_tp3.name)          == "Monthly"
      assert stf_tp1.price                      == nil
      assert stf_tp2.price                      == nil
      assert stf_tp3.price                      == nil
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert data                               == %{
        st_tp1.id => match.match_for_sale_tax_frequency,
        st_tp2.id => match.match_for_sale_tax_frequency,
        st_tp3.id => match.match_for_sale_tax_frequency,
      }
    end

    test "return match_sale_tax_frequency when match is 0 by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat, match_for_sale_tax_frequency: 0)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 0
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_tp.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_frequency when match is 1 by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat, match_for_sale_tax_frequency: 1)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 1
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_tp.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_frequency when match is nil by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat, match_for_sale_tax_frequency: nil)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == nil
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_tp.id => 0}
    end

    test "return match_sale_tax_frequency when price is 0 by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 0, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 0
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == :error
    end

    test "return match_sale_tax_frequency when price is nil by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: nil, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == nil
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == :error
    end

    test "return match_sale_tax_frequency when price is 1 by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 1, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 1
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_tp.id => match.match_for_sale_tax_frequency}
    end

    test "return match_sale_tax_frequency when name is nil by role Pro" do
      name = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: nil, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert stf_tp.name                        == nil
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return match_sale_tax_frequency when name is diffrence by role Pro" do
      name_for_tp = "Annually"
      name_for_pro = "Monthly"
      match = insert(:match_value_relat)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name_for_pro, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name_for_tp, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_frequency(st_pro.id)
      assert match.match_for_sale_tax_frequency == 10
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Annually"
      assert stf_tp.price                       == nil
      assert data                               == %{}
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

    test "return match_sale_tax_industry when more one pro by role Tp" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_tp = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      st_pro1 = insert(:pro_sale_tax, user: pro1)
      st_pro2 = insert(:pro_sale_tax, user: pro2)
      st_pro3 = insert(:pro_sale_tax, user: pro3)
      stf_pro1 = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro1)
      stf_pro2 = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro2)
      stf_pro3 = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro3)
      data = SaleTax.check_match_sale_tax_industry(st_tp.id)
      assert match.match_for_sale_tax_industry == 10
      assert format_names(stf_pro1.name)       == names
      assert format_names(stf_pro2.name)       == names
      assert format_names(stf_pro3.name)       == names
      assert format_names(stf_tp.name)         == name
      assert data                              == %{
        st_pro1.id => match.match_for_sale_tax_industry,
        st_pro2.id => match.match_for_sale_tax_industry,
        st_pro3.id => match.match_for_sale_tax_industry
      }
    end

    test "return match_sale_tax_industry when name is nil by role Tp" do
      name = []
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
      assert data                              == %{}
    end

    test "return match_sale_tax_industry when name is other one by role Tp" do
      name = ["Financial Services"]
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
      assert data                              == %{}
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

    test "return match_sale_tax_industry when more one tp by role Pro" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      match = insert(:match_value_relat)
      pro = insert(:pro_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      stf_pro = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      st_tp1 = insert(:tp_sale_tax, user: tp1)
      st_tp2 = insert(:tp_sale_tax, user: tp2)
      st_tp3 = insert(:tp_sale_tax, user: tp3)
      stf_tp1 = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp1)
      stf_tp2 = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp2)
      stf_tp3 = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp3)
      data = SaleTax.check_match_sale_tax_industry(st_pro.id)
      assert match.match_for_sale_tax_industry == 10
      assert format_names(stf_tp1.name)        == name
      assert format_names(stf_tp2.name)        == name
      assert format_names(stf_tp3.name)        == name
      assert format_names(stf_pro.name)        == names
      assert data                              == %{
        st_tp1.id => match.match_for_sale_tax_industry,
        st_tp2.id => match.match_for_sale_tax_industry,
        st_tp3.id => match.match_for_sale_tax_industry
      }
    end

    test "return match_sale_tax_industry when match is 0 by role Pro" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      match = insert(:match_value_relat, match_for_sale_tax_industry: 0)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_industry(st_pro.id)
      assert match.match_for_sale_tax_industry == 0
      assert format_names(stf_pro.name)        == names
      assert format_names(stf_tp.name)         == name
      assert data                              == %{st_tp.id => match.match_for_sale_tax_industry}
    end

    test "return match_sale_tax_industry when match is nil by role Pro" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      match = insert(:match_value_relat, match_for_sale_tax_industry: 0)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_industry(st_pro.id)
      assert match.match_for_sale_tax_industry == 0
      assert format_names(stf_pro.name)        == names
      assert format_names(stf_tp.name)         == name
      assert data                              == %{st_tp.id => match.match_for_sale_tax_industry}
    end

    test "return match_sale_tax_industry when match is 1 by role Pro" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Legal", "Education"])
      match = insert(:match_value_relat, match_for_sale_tax_industry: 0)
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_industry, name: names, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_industry, name: name, sale_taxes: st_tp)
      data = SaleTax.check_match_sale_tax_industry(st_pro.id)
      assert match.match_for_sale_tax_industry == 0
      assert format_names(stf_pro.name)        == names
      assert format_names(stf_tp.name)         == name
      assert data                              == %{st_tp.id => match.match_for_sale_tax_industry}
    end

    test "return match_sale_tax_industry when name is other one by role Pro" do
      name = Enum.sort(["Legal"])
      names = Enum.sort(["Transportation", "Hospitality", "Retail", "Education"])
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
      assert data                              == %{}
    end

    test "return match_sale_tax_industry when name is nil by role Pro" do
      name = Enum.sort(["Legal"])
      names = Enum.sort([])
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
      assert data                              == %{}
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

    test "return price_sale_tax_count when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      st_pro1 = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro1)
      st_pro2 = insert(:pro_sale_tax, price_sale_tax_count: 33, user: pro2)
      st_pro3 = insert(:pro_sale_tax, price_sale_tax_count: 44, user: pro3)
      data = SaleTax.check_price_sale_tax_count(st_tp.id)
      assert st_pro1.price_sale_tax_count == 22
      assert st_pro2.price_sale_tax_count == 33
      assert st_pro3.price_sale_tax_count == 44
      assert st_pro1.sale_tax_count       == nil
      assert st_pro2.sale_tax_count       == nil
      assert st_pro3.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count   == nil
      assert st_tp.sale_tax_count         == 22
      assert data                         == %{
        st_pro1.id => 484,
        st_pro2.id => 726,
        st_pro3.id => 968,
      }
    end

    test "return price_sale_tax_count when sale_tax_count is 0 by role Tp" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 0, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_tp.id)
      assert st_pro.price_sale_tax_count == 22
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 0
      assert data                        == :error
    end

    test "return price_sale_tax_count when sale_tax_count is 1 by role Tp" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 0, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_tp.id)
      assert st_pro.price_sale_tax_count == 22
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 0
      assert data                        == :error
    end

    test "return price_sale_tax_count when is 0 by role Tp" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 0, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_tp.id)
      assert st_pro.price_sale_tax_count == 0
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 22
      assert data                        == %{}
    end

    test "return price_sale_tax_count when is nil by role Tp" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: nil, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_tp.id)
      assert st_pro.price_sale_tax_count == nil
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 22
      assert data                        == %{}
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

    test "return price_sale_tax_count when more one tp by role Pro" do
      pro = insert(:pro_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      st_tp1 = insert(:tp_sale_tax, sale_tax_count: 22, user: tp1)
      st_tp2 = insert(:tp_sale_tax, sale_tax_count: 33, user: tp2)
      st_tp3 = insert(:tp_sale_tax, sale_tax_count: 44, user: tp3)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_tp1.sale_tax_count       == 22
      assert st_tp2.sale_tax_count       == 33
      assert st_tp3.sale_tax_count       == 44
      assert st_tp1.price_sale_tax_count == nil
      assert st_tp2.price_sale_tax_count == nil
      assert st_tp3.price_sale_tax_count == nil
      assert st_pro.sale_tax_count       == nil
      assert st_pro.price_sale_tax_count == 22
      assert data                         == %{
        st_tp1.id => 484,
        st_tp2.id => 726,
        st_tp3.id => 968,
      }
    end

    test "return price_sale_tax_count when sale_tax_count is 0 by role Pro" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 0, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_pro.price_sale_tax_count == 22
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 0
      assert data                        == %{}
    end

    test "return price_sale_tax_count when sale_tax_count is nil by role Pro" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: nil, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_pro.price_sale_tax_count == 22
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == nil
      assert data                        == %{}
    end

    test "return price_sale_tax_count when sale_tax_count is 1 by role Pro" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 22, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 1, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_pro.price_sale_tax_count == 22
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 1
      assert data                        == %{}
    end

    test "return price_sale_tax_count when is 0 by role Pro" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 0, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_pro.price_sale_tax_count == 0
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 22
      assert data                        == :error
    end

    test "return price_sale_tax_count when is nil by role Pro" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: nil, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_pro.price_sale_tax_count == nil
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 22
      assert data                        == :error
    end

    test "return price_sale_tax_count when is 1 by role Pro" do
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, price_sale_tax_count: 1, user: pro)
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_price_sale_tax_count(st_pro.id)
      assert st_pro.price_sale_tax_count == 1
      assert st_pro.sale_tax_count       == nil
      assert st_tp.price_sale_tax_count  == nil
      assert st_tp.sale_tax_count        == 22
      assert data                        == %{st_tp.id => 22}
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

    test "return price_sale_tax_frequency when name is nil by role Tp" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: nil, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_tp.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert stf_tp.name                        == nil
      assert stf_tp.price                       == nil
      assert data                               == :error
    end

    test "return price_sale_tax_frequency when name is other one by role Tp" do
      name_for_tp = "Annually"
      name_for_pro = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name_for_pro, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name_for_tp, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_tp.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Annually"
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return price_sale_tax_frequency when price is 0 by role Tp" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 0, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_tp.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 0
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return price_sale_tax_frequency when price is nil by role Tp" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: nil, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_tp.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == nil
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return price_sale_tax_frequency when price is 1 by role Tp" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 1, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_tp.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 1
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_pro.id => 1}
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

    test "return price_sale_tax_frequency when name is nil by role Pro" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: nil, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_pro.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert stf_tp.name                        == nil
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return price_sale_tax_frequency when name is other one by role Pro" do
      name_for_tp = "Annually"
      name_for_pro = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name_for_pro, price: 22, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name_for_tp, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_pro.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 22
      assert format_name(stf_tp.name)           == "Annually"
      assert stf_tp.price                       == nil
      assert data                               == %{}
    end

    test "return price_sale_tax_frequency when price is 0 by role Pro" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 0, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_pro.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 0
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == :error
    end

    test "return price_sale_tax_frequency when price is nil by role Pro" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: nil, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_pro.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == nil
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == :error
    end

    test "return price_sale_tax_frequency when price is 1 by role Pro" do
      name = "Monthly"
      pro = insert(:pro_user)
      tp = insert(:tp_user, languages: [])
      st_pro = insert(:pro_sale_tax, user: pro)
      st_tp = insert(:tp_sale_tax, user: tp)
      stf_pro = insert(:pro_sale_tax_frequency, name: name, price: 1, sale_taxes: st_pro)
      stf_tp = insert(:tp_sale_tax_frequency, name: name, sale_taxes: st_tp)
      data = SaleTax.check_price_sale_tax_frequency(st_pro.id)
      assert format_name(stf_pro.name)          == "Monthly"
      assert stf_pro.price                      == 1
      assert format_name(stf_tp.name)           == "Monthly"
      assert stf_tp.price                       == nil
      assert data                               == %{st_tp.id => 1}
    end
  end

  describe "#check_value" do
    test "return value_sale_tax_count by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 22)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert D.to_string(match.value_for_sale_tax_count) == "22"
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == 22
      assert data                                        == %{st_tp.id => D.new("484")}
    end

    test "return value_sale_tax_count when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 0)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert D.to_string(match.value_for_sale_tax_count) == "0"
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == 22
      assert data                                        == %{st_tp.id => D.new("0")}
    end

    test "return value_sale_tax_count when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: nil)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert match.value_for_sale_tax_count == nil
      assert st_tp.price_sale_tax_count     == nil
      assert st_tp.sale_tax_count           == 22
      assert data                           == %{st_tp.id => D.new("0.0")}
    end

    test "return value_sale_tax_count when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 0)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: 22, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert D.to_string(match.value_for_sale_tax_count) == "0"
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == 22
      assert data                                        == %{st_tp.id => D.new("0")}
    end

    test "return value_sale_tax_count when sale_tax_count is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 22)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: 0, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert D.to_string(match.value_for_sale_tax_count) == "22"
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == 0
      assert data                                        == :error
    end

    test "return value_sale_tax_count when sale_tax_count is nil by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 22)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: nil, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert D.to_string(match.value_for_sale_tax_count) == "22"
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == nil
      assert data                                        == :error
    end

    test "return value_sale_tax_count when sale_tax_count is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_sale_tax_count: 22)
      tp = insert(:tp_user, languages: [])
      st_tp = insert(:tp_sale_tax, sale_tax_count: 1, user: tp)
      data = SaleTax.check_value_sale_tax_count(st_tp.id)
      assert D.to_string(match.value_for_sale_tax_count) == "22"
      assert st_tp.price_sale_tax_count                  == nil
      assert st_tp.sale_tax_count                        == 1
      assert data                                        == %{st_tp.id => D.new("22")}
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
