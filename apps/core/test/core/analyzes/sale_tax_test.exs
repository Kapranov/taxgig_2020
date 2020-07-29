defmodule Core.Analyzes.SaleTaxTest do
  use Core.DataCase

  alias Core.{
    Analyzes,
    Analyzes.SaleTax
  }

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

    test "check_match_sale_tax_frequency" do
    end

    test "check_match_sale_tax_industry" do
    end
  end

  describe "#check_price" do
    test "check_price_sale_tax_count" do
    end

    test "check_price_sale_tax_frequency" do
    end
  end

  describe "#check_value" do
    test "check_value_sale_tax_count" do
    end
  end

  describe "#total_all" do
  end

  describe "#total_match" do
  end

  describe "#total_price" do
  end

  describe "total_value" do
  end
end
