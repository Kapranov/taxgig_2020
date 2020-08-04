defmodule Core.Analyzes.BusinessTaxReturnTest do
  use Core.DataCase

  alias Core.{
    Analyzes,
    Analyzes.BusinessTaxReturn
  }

  alias Decimal, as: D

  describe "#check_match" do
    test "return match_business_entity_type by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_pro.id => match.match_for_business_enity_type}
    end

    test "return match_business_entity_type when more one pro by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, user: pro3)
      bet_pro1 = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro1)
      bet_pro2 = insert(:pro_business_entity_type, name: name, price: 33, business_tax_returns: btr_pro2)
      bet_pro3 = insert(:pro_business_entity_type, name: name, price: 44, business_tax_returns: btr_pro3)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro1.name)          == name
      assert format_name(bet_pro2.name)          == name
      assert format_name(bet_pro3.name)          == name
      assert bet_pro1.price                      == 22
      assert bet_pro2.price                      == 33
      assert bet_pro3.price                      == 44
      assert data                                == %{
        btr_pro1.id => match.match_for_business_enity_type,
        btr_pro2.id => match.match_for_business_enity_type,
        btr_pro3.id => match.match_for_business_enity_type
      }
    end

    test "return match_business_entity_type when match is 0 by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat, match_for_business_enity_type: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 0
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_pro.id => match.match_for_business_enity_type}
    end

    test "return match_business_entity_type when match is nil by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat, match_for_business_enity_type: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == nil
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_pro.id => 0}
    end

    test "return match_business_entity_type when match is 1 by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat, match_for_business_enity_type: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 1
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_pro.id => match.match_for_business_enity_type}
    end

    test "return match_business_entity_type when name is another one by role Tp" do
      name_for_tp = "LLC"
      name_for_pro = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name_for_tp
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name_for_pro
      assert bet_pro.price                       == 22
      assert data                                == %{}
    end

    test "return match_business_entity_type when name is nil by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: nil, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == nil
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == :error
    end

    test "return match_business_entity_type when price is 0 by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 0
      assert data                                == %{}
    end

    test "return match_business_entity_type when price is nil by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == nil
      assert data                                == %{}
    end

    test "return match_business_entity_type when price is 1 by role Tp" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 1
      assert data                                == %{btr_pro.id => match.match_for_business_enity_type}
    end

    test "return match_business_entity_type by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_tp.id => match.match_for_business_enity_type}
    end

    test "return match_business_entity_type when more one pro by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, user: tp3)
      bet_tp1 = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp1)
      bet_tp2 = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp2)
      bet_tp3 = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp1.name)           == name
      assert format_name(bet_tp2.name)           == name
      assert format_name(bet_tp3.name)           == name
      assert bet_tp1.price                       == nil
      assert bet_tp2.price                       == nil
      assert bet_tp3.price                       == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{
        btr_tp1.id => match.match_for_business_enity_type,
        btr_tp2.id => match.match_for_business_enity_type,
        btr_tp3.id => match.match_for_business_enity_type
      }
    end

    test "return match_business_entity_type when match is 0 by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat, match_for_business_enity_type: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 0
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_tp.id => match.match_for_business_enity_type}
    end

    test "return match_business_entity_type when match is nil by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat, match_for_business_enity_type: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == nil
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_tp.id => 0}
    end

    test "return match_business_entity_type when match is 1 by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat, match_for_business_enity_type: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 1
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_tp.id => match.match_for_business_enity_type}
    end

    test "return match_business_entity_type when name is another one by role Pro" do
      name_for_tp = "LLC"
      name_for_pro = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name_for_tp
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name_for_pro
      assert bet_pro.price                       == 22
      assert data                                == %{}
    end

    test "return match_business_entity_type when name is nil by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: nil, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == nil
      assert bet_pro.price                       == 22
      assert data                                == :error
    end

    test "return match_business_entity_type when price is 0 by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 0
      assert data                                == :error
    end

    test "return match_business_entity_type when price is nil by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == nil
      assert data                                == :error
    end

    test "return match_business_entity_type when price is 1 by role Pro" do
      name = "Partnership"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_entity_type(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 1
      assert data                                == %{btr_tp.id => match.match_for_business_enity_type}
    end

    test "return match_business_industry by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_tp.id)

      assert match.match_for_business_industry == 10
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_pro.id => match.match_for_business_industry}
    end

    test "return match_business_industry when more one pro by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, user: pro3)
      bi_pro1 = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro1)
      bi_pro2 = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro2)
      bi_pro3 = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro3)

      data = BusinessTaxReturn.check_match_business_industry(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert match.match_for_business_industry == 10
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro1.name)        == names
      assert format_names(bi_pro2.name)        == names
      assert format_names(bi_pro3.name)        == names
      assert data                              == %{
        btr_pro1.id => match.match_for_business_industry,
        btr_pro2.id => match.match_for_business_industry,
        btr_pro3.id => match.match_for_business_industry
      }
    end

    test "return match_business_industry when match is 0 by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_business_industry: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_tp.id)

      assert match.match_for_business_industry == 0
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_pro.id => match.match_for_business_industry}
    end

    test "return match_business_industry when match is nil by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_business_industry: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_tp.id)

      assert match.match_for_business_industry == nil
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_pro.id => 0}
    end

    test "return match_business_industry when match is 1 by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_business_industry: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_tp.id)

      assert match.match_for_business_industry == 1
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_pro.id => match.match_for_business_industry}
    end

    test "return match_business_industry when name is nil by role Tp" do
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: nil, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_tp.id)

      assert match.match_for_business_industry == 10
      assert format_name(bi_tp.name)           == nil
      assert format_names(bi_pro.name)         == names
      assert data                              == :error
    end

    test "return match_business_industry when name is another one by role Tp" do
      name = Enum.sort(["Non Profit"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_tp.id)

      assert match.match_for_business_industry == 10
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{}
    end

    test "return match_business_industry by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_pro.id)

      assert match.match_for_business_industry == 10
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_tp.id => match.match_for_business_industry}
    end

    test "return match_business_industry when more one pro by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, user: tp3)
      bi_tp1 = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp1)
      bi_tp2 = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp2)
      bi_tp3 = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert match.match_for_business_industry   == 10
      assert format_names(bi_tp1.name)           == name
      assert format_names(bi_tp2.name)           == name
      assert format_names(bi_tp3.name)           == name
      assert format_names(bi_pro.name)           == names
      assert data                                == %{
        btr_tp1.id => match.match_for_business_industry,
        btr_tp2.id => match.match_for_business_industry,
        btr_tp3.id => match.match_for_business_industry
      }
    end

    test "return match_business_industry when match is 0 by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_business_industry: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_pro.id)

      assert match.match_for_business_industry == 0
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_tp.id => match.match_for_business_industry}
    end

    test "return match_business_industry when match is nil by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_business_industry: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_pro.id)

      assert match.match_for_business_industry == nil
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_tp.id => 0}
    end

    test "return match_business_industry when match is 1 by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_business_industry: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_pro.id)

      assert match.match_for_business_industry == 1
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{btr_tp.id => match.match_for_business_industry}
    end

    test "return match_business_industry when name is nil by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = []

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_pro.id)

      assert match.match_for_business_industry == 10
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{}
    end

    test "return match_business_industry when name is another one by role Pro" do
      name = Enum.sort(["Non Profit"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bi_tp = insert(:tp_business_industry, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bi_pro = insert(:pro_business_industry, name: names, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_industry(btr_pro.id)

      assert match.match_for_business_industry == 10
      assert format_names(bi_tp.name)          == name
      assert format_names(bi_pro.name)         == names
      assert data                              == %{}
    end

    test "return match_business_number_employee by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_pro.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_number_employee when more one pro by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, user: pro3)
      bne_pro1 = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro1)
      bne_pro2 = insert(:pro_business_number_employee, name: name, price: 33, business_tax_returns: btr_pro2)
      bne_pro3 = insert(:pro_business_number_employee, name: name, price: 44, business_tax_returns: btr_pro3)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bne_tp.name)            == name
      assert bne_tp.price                        == nil
      assert format_name(bne_pro1.name)          == name
      assert format_name(bne_pro2.name)          == name
      assert format_name(bne_pro3.name)          == name
      assert bne_pro1.price                      == 22
      assert bne_pro2.price                      == 33
      assert bne_pro3.price                      == 44
      assert data                                == %{
        btr_pro1.id => match.match_for_business_number_of_employee,
        btr_pro2.id => match.match_for_business_number_of_employee,
        btr_pro3.id => match.match_for_business_number_of_employee
      }
    end

    test "return match_business_number_employee when match is 0 by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat, match_for_business_number_of_employee: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 0
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_pro.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_number_employee when match is nil by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat, match_for_business_number_of_employee: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == nil
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_pro.id => 0}
    end

    test "return match_business_number_employee when match is 1 by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat, match_for_business_number_of_employee: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 1
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_pro.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_number_employee when name is nil by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: nil, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == nil
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == :error
    end

    test "return match_business_number_employee when name is another one by role Tp" do
      name_for_tp = "101 - 500 employees"
      name_for_pro = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name_for_tp
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name_for_pro
      assert bne_pro.price                               == 22
      assert data                                        == %{}
    end

    test "return match_business_number_employee when price is nil by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == nil
      assert data                                        == %{}
    end

    test "return match_business_number_employee when price is 0 by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 0
      assert data                                        == %{}
    end

    test "return match_business_number_employee when price is 1 by role Tp" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 1
      assert data                                        == %{btr_pro.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_number_employee by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_tp.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_number_employee when more one pro by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, user: tp3)
      bne_tp1 = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp1)
      bne_tp2 = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp2)
      bne_tp3 = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_enity_type == 50
      assert format_name(bne_tp1.name)           == name
      assert format_name(bne_tp2.name)           == name
      assert format_name(bne_tp3.name)           == name
      assert bne_tp1.price                       == nil
      assert bne_tp2.price                       == nil
      assert bne_tp3.price                       == nil
      assert format_name(bne_pro.name)           == name
      assert bne_pro.price                       == 22
      assert data                                == %{
        btr_tp1.id => match.match_for_business_number_of_employee,
        btr_tp2.id => match.match_for_business_number_of_employee,
        btr_tp3.id => match.match_for_business_number_of_employee
      }
    end

    test "return match_business_number_employee when match is 0 by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat, match_for_business_number_of_employee: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == 0
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_tp.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_number_employee when match is nil by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat, match_for_business_number_of_employee: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == nil
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_tp.id => 0}
    end

    test "return match_business_number_employee when match is 1 by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat, match_for_business_number_of_employee: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == 1
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_tp.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_number_employee when name is nil by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: nil, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == nil
      assert bne_pro.price                               == 22
      assert data                                        == :error
    end

    test "return match_business_number_employee when name is another one by role Pro" do
      name_for_tp = "101 - 500 employees"
      name_for_pro = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name_for_tp
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name_for_pro
      assert bne_pro.price                               == 22
      assert data                                        == %{}
    end

    test "return match_business_number_employee when price is nil by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_tp.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == nil
      assert data                                        == %{}
    end

    test "return match_business_number_employee when price is 0 by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 0
      assert data                                        == :error
    end

    test "return match_business_number_employee when price is 1 by role Pro" do
      name = "1 employee"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_number_of_employee(btr_pro.id)

      assert match.match_for_business_number_of_employee == 20
      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 1
      assert data                                        == %{btr_tp.id => match.match_for_business_number_of_employee}
    end

    test "return match_business_total_revenue by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_pro.id => match.match_for_business_total_revenue}
    end

    test "return match_business_total_revenue when more one pro by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, user: pro3)
      br_pro1 = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro1)
      br_pro2 = insert(:pro_business_total_revenue, name: name, price: 33, business_tax_returns: btr_pro2)
      br_pro3 = insert(:pro_business_total_revenue, name: name, price: 44, business_tax_returns: btr_pro3)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro1.name)              == name
      assert format_name(br_pro2.name)              == name
      assert format_name(br_pro3.name)              == name
      assert br_pro1.price                          == 22
      assert br_pro2.price                          == 33
      assert br_pro3.price                          == 44
      assert data                                   == %{
        btr_pro1.id => match.match_for_business_total_revenue,
        btr_pro2.id => match.match_for_business_total_revenue,
        btr_pro3.id => match.match_for_business_total_revenue
      }
    end

    test "return match_business_total_revenue when is match is 0 by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat, match_for_business_total_revenue: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 0
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_pro.id => match.match_for_business_total_revenue}
    end

    test "return match_business_total_revenue when is match is nil by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat, match_for_business_total_revenue: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == nil
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_pro.id => 0}
    end

    test "return match_business_total_revenue when is match is 1 by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat, match_for_business_total_revenue: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 1
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_pro.id => match.match_for_business_total_revenue}
    end

    test "return match_business_total_revenue when is name is nil by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: nil, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == nil
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == :error
    end

    test "return match_business_total_revenue when is name is another one by role Tp" do
      name_for_tp = "$500K - $1M"
      name_for_pro = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name_for_tp
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name_for_pro
      assert br_pro.price                           == 22
      assert data                                   == %{}
    end

    test "return match_business_total_revenue when is price is nil by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == nil
      assert data                                   == %{}
    end

    test "return match_business_total_revenue when is price is 0 by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 0
      assert data                                   == %{}
    end

    test "return match_business_total_revenue when is price is 1 by role Tp" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_tp.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 1
      assert data                                   == %{btr_pro.id => match.match_for_business_total_revenue}
    end

    test "return match_business_total_revenue by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_tp.id => match.match_for_business_total_revenue}
    end

    test "return match_business_total_revenue when more one pro by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, user: tp3)
      br_tp1 = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp1)
      br_tp2 = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp2)
      br_tp3 = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp1.name)               == name
      assert format_name(br_tp2.name)               == name
      assert format_name(br_tp3.name)               == name
      assert br_tp1.price                           == nil
      assert br_tp2.price                           == nil
      assert br_tp3.price                           == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{
        btr_tp1.id => match.match_for_business_total_revenue,
        btr_tp2.id => match.match_for_business_total_revenue,
        btr_tp3.id => match.match_for_business_total_revenue
      }
    end

    test "return match_business_total_revenue when is match is 0 by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat, match_for_business_total_revenue: 0)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 0
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_tp.id => match.match_for_business_total_revenue}
    end

    test "return match_business_total_revenue when is match is nil by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat, match_for_business_total_revenue: nil)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == nil
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_tp.id => 0}
    end

    test "return match_business_total_revenue when is match is 1 by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat, match_for_business_total_revenue: 1)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 1
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_tp.id => match.match_for_business_total_revenue}
    end

    test "return match_business_total_revenue when is name is nil by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: nil, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == nil
      assert br_pro.price                           == 22
      assert data                                   == :error
    end

    test "return match_business_total_revenue when is name is another one by role Pro" do
      name_for_tp = "$500K - $1M"
      name_for_pro = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name_for_tp
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name_for_pro
      assert br_pro.price                           == 22
      assert data                                   == %{}
    end

    test "return match_business_total_revenue when is price is nil by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == nil
      assert data                                   == :error
    end

    test "return match_business_total_revenue when is price is 0 by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 0
      assert data                                   == :error
    end

    test "return match_business_total_revenue when is price is 1 by role Pro" do
      name = "$1M - $5M"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_match_business_total_revenue(btr_pro.id)

      assert match.match_for_business_total_revenue == 20
      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 1
      assert data                                   == %{btr_tp.id => match.match_for_business_total_revenue}
    end
  end

  describe "#check_price" do
    test "return price_business_entity_type by role Tp" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_tp.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_pro.id => 22}
    end

    test "return match_business_entity_type when more one pro by role Tp" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, user: pro3)
      bet_pro1 = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro1)
      bet_pro2 = insert(:pro_business_entity_type, name: name, price: 33, business_tax_returns: btr_pro2)
      bet_pro3 = insert(:pro_business_entity_type, name: name, price: 44, business_tax_returns: btr_pro3)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_tp.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro1.name)          == name
      assert format_name(bet_pro2.name)          == name
      assert format_name(bet_pro3.name)          == name
      assert bet_pro1.price                      == 22
      assert bet_pro2.price                      == 33
      assert bet_pro3.price                      == 44
      assert data                                == %{
        btr_pro1.id => 22,
        btr_pro2.id => 33,
        btr_pro3.id => 44
      }
    end

    test "return price_business_entity_type when name is nil by role Tp" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: nil, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_tp.id)

      assert format_name(bet_tp.name)            == nil
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == :error
    end

    test "return price_business_entity_type when name is another one by role Tp" do
      name_for_tp = "LLC"
      name_for_pro = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_tp.id)

      assert format_name(bet_tp.name)            == name_for_tp
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name_for_pro
      assert bet_pro.price                       == 22
      assert data                                == %{}
    end

    test "return price_business_entity_type when price is nil by role Tp" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_tp.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == nil
      assert data                                == %{}
    end

    test "return price_business_entity_type when price is 0 by role Tp" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_tp.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 0
      assert data                                == %{}
    end

    test "return price_business_entity_type when price is 1 by role Tp" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_tp.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 1
      assert data                                == %{btr_pro.id => 1}
    end

    test "return price_business_entity_type by role Pro" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_pro.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{btr_tp.id => 22}
    end

    test "return price_business_entity_type when more one pro by role Pro" do
      name = "Partnership"

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, user: tp3)
      bet_tp1 = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp1)
      bet_tp2 = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp2)
      bet_tp3 = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_pro.id)

      assert format_name(bet_tp1.name)           == name
      assert format_name(bet_tp2.name)           == name
      assert format_name(bet_tp3.name)           == name
      assert bet_tp1.price                       == nil
      assert bet_tp2.price                       == nil
      assert bet_tp3.price                       == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 22
      assert data                                == %{
        btr_tp1.id => 22,
        btr_tp2.id => 22,
        btr_tp3.id => 22
      }
    end

    test "return price_business_entity_type when name is nil by role Pro" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: nil, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_pro.id)

      assert format_name(bet_tp.name)  == name
      assert bet_tp.price              == nil
      assert format_name(bet_pro.name) == nil
      assert bet_pro.price             == 22
      assert data                      == :error
    end

    test "return price_business_entity_type when name is another one by role Pro" do
      name_for_tp = "LLC"
      name_for_pro = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_pro.id)

      assert format_name(bet_tp.name)            == name_for_tp
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name_for_pro
      assert bet_pro.price                       == 22
      assert data                                == %{}
    end

    test "return price_business_entity_type when price is nil by role Pro" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_pro.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == nil
      assert data                                == :error
    end

    test "return price_business_entity_type when price is 0 by role Pro" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_pro.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 0
      assert data                                == :error
    end

    test "return price_business_entity_type when price is 1 by role Pro" do
      name = "Partnership"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_entity_type(btr_pro.id)

      assert format_name(bet_tp.name)            == name
      assert bet_tp.price                        == nil
      assert format_name(bet_pro.name)           == name
      assert bet_pro.price                       == 1
      assert data                                == %{btr_tp.id => 1}
    end

    test "return price_business_number_of_employee by role Tp" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_tp.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_pro.id => 22}
    end

    test "return price_business_number_employee when more one pro by role Tp" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, user: pro3)
      bne_pro1 = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro1)
      bne_pro2 = insert(:pro_business_number_employee, name: name, price: 33, business_tax_returns: btr_pro2)
      bne_pro3 = insert(:pro_business_number_employee, name: name, price: 44, business_tax_returns: btr_pro3)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_tp.id)

      assert format_name(bne_tp.name)            == name
      assert bne_tp.price                        == nil
      assert format_name(bne_pro1.name)          == name
      assert format_name(bne_pro2.name)          == name
      assert format_name(bne_pro3.name)          == name
      assert bne_pro1.price                      == 22
      assert bne_pro2.price                      == 33
      assert bne_pro3.price                      == 44
      assert data                                == %{
        btr_pro1.id => 22,
        btr_pro2.id => 33,
        btr_pro3.id => 44
      }
    end

    test "return price_business_number_of_employee when name is nil by role Tp" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: nil, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_tp.id)

      assert format_name(bne_tp.name)                    == nil
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == :error
    end

    test "return price_business_number_of_employee when name is another one by role Tp" do
      name_for_tp = "500+ employees"
      name_for_pro = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_tp.id)

      assert format_name(bne_tp.name)                    == name_for_tp
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name_for_pro
      assert bne_pro.price                               == 22
      assert data                                        == %{}
    end

    test "return price_business_number_of_employee when price is nil by role Tp" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_tp.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == nil
      assert data                                        == %{}
    end

    test "return price_business_number_of_employee when price is 0 by role Tp" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_tp.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 0
      assert data                                        == %{}
    end

    test "return price_business_number_of_employee when price is 1 by role Tp" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_tp.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 1
      assert data                                        == %{btr_pro.id => 1}
    end

    test "return price_business_number_of_employee by role Pro" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_pro.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 22
      assert data                                        == %{btr_tp.id => 22}
    end

    test "return price_business_number_employee when more one pro by role Pro" do
      name = "1 employee"

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, user: tp3)
      bne_tp1 = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp1)
      bne_tp2 = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp2)
      bne_tp3 = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_pro.id)

      assert format_name(bne_tp1.name)           == name
      assert format_name(bne_tp2.name)           == name
      assert format_name(bne_tp3.name)           == name
      assert bne_tp1.price                       == nil
      assert bne_tp2.price                       == nil
      assert bne_tp3.price                       == nil
      assert format_name(bne_pro.name)           == name
      assert bne_pro.price                       == 22
      assert data                                == %{
        btr_tp1.id => 22,
        btr_tp2.id => 22,
        btr_tp3.id => 22
      }
    end

    test "return price_business_number_of_employee when name is nil by role Pro" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: nil, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_pro.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == nil
      assert bne_pro.price                               == 22
      assert data                                        == :error
    end

    test "return price_business_number_of_employee when name is another one by role Pro" do
      name_for_tp = "500+ employees"
      name_for_pro = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_pro.id)

      assert format_name(bne_tp.name)                    == name_for_tp
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name_for_pro
      assert bne_pro.price                               == 22
      assert data                                        == %{}
    end

    test "return price_business_number_of_employee when price is nil by role Pro" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_pro.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == nil
      assert data                                        == :error
    end

    test "return price_business_number_of_employee when price is 0 by role Pro" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_pro.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 0
      assert data                                        == :error
    end

    test "return price_business_number_of_employee when price is 1 by role Pro" do
      name = "1 employee"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bne_tp = insert(:tp_business_number_employee, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bne_pro = insert(:pro_business_number_employee, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_number_of_employee(btr_pro.id)

      assert format_name(bne_tp.name)                    == name
      assert bne_tp.price                                == nil
      assert format_name(bne_pro.name)                   == name
      assert bne_pro.price                               == 1
      assert data                                        == %{btr_tp.id => 1}
    end

    test "return price_business_total_revenue by role Tp" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_tp.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_pro.id => 22}
    end

    test "return price_business_total_revenue when more one pro by role Tp" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, user: pro3)
      br_pro1 = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro1)
      br_pro2 = insert(:pro_business_total_revenue, name: name, price: 33, business_tax_returns: btr_pro2)
      br_pro3 = insert(:pro_business_total_revenue, name: name, price: 44, business_tax_returns: btr_pro3)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_tp.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro1.name)              == name
      assert format_name(br_pro2.name)              == name
      assert format_name(br_pro3.name)              == name
      assert br_pro1.price                          == 22
      assert br_pro2.price                          == 33
      assert br_pro3.price                          == 44
      assert data                                   == %{
        btr_pro1.id => 22,
        btr_pro2.id => 33,
        btr_pro3.id => 44
      }
    end

    test "return price_business_total_revenue when name is nil by role Tp" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: nil, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_tp.id)

      assert format_name(br_tp.name)                == nil
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == :error
    end

    test "return price_business_total_revenue when name is another one by role Tp" do
      name_for_tp = "$500K - $1M"
      name_for_pro = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_tp.id)

      assert format_name(br_tp.name)                == name_for_tp
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name_for_pro
      assert br_pro.price                           == 22
      assert data                                   == %{}
    end

    test "return price_business_total_revenue when price is nil by role Tp" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_tp.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == nil
      assert data                                   == %{}
    end

    test "return price_business_total_revenue when price is 0 by role Tp" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_tp.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 0
      assert data                                   == %{}
    end

    test "return price_business_total_revenue when price is 1 by role Tp" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_tp.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 1
      assert data                                   == %{btr_pro.id => 1}
    end

    test "return price_business_total_revenue by role Pro" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_pro.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{btr_tp.id => 22}
    end

    test "return price_business_total_revenue when more one pro by role Pro" do
      name = "$1M - $5M"

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, user: tp3)
      br_tp1 = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp1)
      br_tp2 = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp2)
      br_tp3 = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_pro.id)

      assert format_name(br_tp1.name)               == name
      assert format_name(br_tp2.name)               == name
      assert format_name(br_tp3.name)               == name
      assert br_tp1.price                           == nil
      assert br_tp2.price                           == nil
      assert br_tp3.price                           == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 22
      assert data                                   == %{
        btr_tp1.id => 22,
        btr_tp2.id => 22,
        btr_tp3.id => 22
      }
    end

    test "return price_business_total_revenue when name is nil by role Pro" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: nil, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_pro.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == nil
      assert br_pro.price                           == 22
      assert data                                   == :error
    end

    test "return price_business_total_revenue when name is another one by role Pro" do
      name_for_tp = "$500K - $1M"
      name_for_pro = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name_for_tp, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name_for_pro, price: 22, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_pro.id)

      assert format_name(br_tp.name)                == name_for_tp
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name_for_pro
      assert br_pro.price                           == 22
      assert data                                   == %{}
    end

    test "return price_business_total_revenue when price is nil by role Pro" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: nil, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_pro.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == nil
      assert data                                   == :error
    end

    test "return price_business_total_revenue when price is 0 by role Pro" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 0, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_pro.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 0
      assert data                                   == :error
    end

    test "return price_business_total_revenue when price is 1 by role Pro" do
      name = "$1M - $5M"

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 1, business_tax_returns: btr_pro)

      data = BusinessTaxReturn.check_price_business_total_revenue(btr_pro.id)

      assert format_name(br_tp.name)                == name
      assert br_tp.price                            == nil
      assert format_name(br_pro.name)               == name
      assert br_pro.price                           == 1
      assert data                                   == %{btr_tp.id => 1}
    end

    test "return price_state by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{btr_pro.id => 66}
    end

    test "return price_state when more one pro by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, price_state: 22, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, price_state: 33, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, price_state: 44, user: pro3)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)   == state
      assert btr_tp.price_state           == nil
      assert format_names(btr_pro1.state) == nil
      assert format_names(btr_pro2.state) == nil
      assert format_names(btr_pro3.state) == nil
      assert btr_pro1.price_state         == 22
      assert btr_pro2.price_state         == 33
      assert btr_pro3.price_state         == 44
      assert data                         == %{
        btr_pro1.id => 66,
        btr_pro2.id => 99,
        btr_pro3.id => 132
      }
    end

    test "return price_state when state is nil by role Tp" do
      state = []

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{btr_pro.id => 0}
    end

    test "return price_state when state is one by role Tp" do
      state = ["Michigan", "Michigan", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{btr_pro.id => 22}
    end

    test "return price_state when state is two by role Tp" do
      state = ["Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{btr_pro.id => 44}
    end

    test "return price_state when price is nil by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: nil, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == nil
      assert data                        == %{}
    end

    test "return price_state when price is 0 by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 0, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 0
      assert data                        == %{btr_pro.id => 0}
    end

    test "return price_state when price is 1 by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 1, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 1
      assert data                        == %{btr_pro.id => 3}
    end

    test "return price_state by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{btr_tp.id => 22}
    end

    test "return price_state when more one tp by role Pro" do
      state_for_tp1 = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort() |> Enum.uniq()
      state_for_tp2 = ["American Samoa", "Michigan", "American Samoa"] |> Enum.sort() |> Enum.uniq()
      state_for_tp3 = ["New Jersey", "Delaware", "California", "Connecticut"] |> Enum.sort() |> Enum.uniq()

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, state: state_for_tp1, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, state: state_for_tp2, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, state: state_for_tp3, user: tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp1.state) == state_for_tp1
      assert format_names(btr_tp2.state) == state_for_tp2
      assert format_names(btr_tp3.state) == state_for_tp3
      assert btr_tp1.price_state         == nil
      assert btr_tp2.price_state         == nil
      assert btr_tp3.price_state         == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{
        btr_tp1.id => 66,
        btr_tp2.id => 66,
        btr_tp3.id => 66
      }
    end

    test "return price_state when state is nil by role Pro" do
      state = []

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{}
    end

    test "return price_state when state is one by role Pro" do
      state = ["Michigan", "Michigan", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{}
    end

    test "return price_state when state is two by role Pro" do
      state = ["Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{btr_tp.id => 22}
    end

    test "return price_state when price is nil by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: nil, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == nil
      assert data                        == :error
    end

    test "return price_state when price is 0 by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 0, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 0
      assert data                        == :error
    end

    test "return price_state when price is 1 by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 1, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state)  == state
      assert btr_tp.price_state          == nil
      assert format_names(btr_pro.state) == nil
      assert btr_pro.price_state         == 1
      assert data                        == %{btr_tp.id => 1}
    end

    test "return price_tax_year by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{btr_pro.id => 44}
    end

    test "return price_tax_year when more one pro by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, price_tax_year: 22, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, price_tax_year: 33, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, price_tax_year: 44, user: pro3)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)   == tax_year
      assert btr_tp.price_tax_year           == nil
      assert format_names(btr_pro1.tax_year) == nil
      assert format_names(btr_pro2.tax_year) == nil
      assert format_names(btr_pro3.tax_year) == nil
      assert btr_pro1.price_tax_year         == 22
      assert btr_pro2.price_tax_year         == 33
      assert btr_pro3.price_tax_year         == 44
      assert data                            == %{
        btr_pro1.id => 44,
        btr_pro2.id => 66,
        btr_pro3.id => 88
      }
    end

    test "return price_tax_year when tax_year is nil by role Tp" do
      tax_year = []

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == :error
    end

    test "return price_tax_year when tax_year is one by role Tp" do
      tax_year = ["2017", "2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == :error
    end

    test "return price_tax_year when tax_year is two by role Tp" do
      tax_year = ["2015", "2017", "2017", "2015"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{btr_pro.id => 22}
    end

    test "return price_tax_year when price_tax_year is nil by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: nil, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == nil
      assert data                           == %{}
    end

    test "return price_tax_year when price_tax_year is 0 by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 0, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 0
      assert data                           == %{btr_pro.id => 0}
    end

    test "return price_tax_year when price_tax_year is 1 by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 1, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 1
      assert data                           == %{btr_pro.id => 2}
    end

    test "return price_tax_year by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{btr_tp.id => 44}
    end

    test "return price_tax_year when more one tp by role Pro" do
      tax_year_for_tp1 = ["2019", "2012", "2011"] |> Enum.sort() |> Enum.uniq()
      tax_year_for_tp2 = ["2018", "2017", "2014"] |> Enum.sort() |> Enum.uniq()
      tax_year_for_tp3 = ["2014", "2011", "2014", "2015"] |> Enum.sort() |> Enum.uniq()

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      btr_tp1 = insert(:tp_business_tax_return, tax_year: tax_year_for_tp1, user: tp1)
      btr_tp2 = insert(:tp_business_tax_return, tax_year: tax_year_for_tp2, user: tp2)
      btr_tp3 = insert(:tp_business_tax_return, tax_year: tax_year_for_tp3, user: tp3)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp1.tax_year) == tax_year_for_tp1
      assert format_names(btr_tp2.tax_year) == tax_year_for_tp2
      assert format_names(btr_tp3.tax_year) == tax_year_for_tp3
      assert btr_tp1.price_tax_year         == nil
      assert btr_tp2.price_tax_year         == nil
      assert btr_tp3.price_tax_year         == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{
        btr_tp1.id => 44,
        btr_tp2.id => 44,
        btr_tp3.id => 44
      }
    end

    test "return price_tax_year when tax_year is nil by role Pro" do
      tax_year = []

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{}
    end

    test "return price_tax_year when tax_year is one by role Pro" do
      tax_year = ["2017", "2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{}
    end

    test "return price_tax_year when tax_year is two by role Pro" do
      tax_year = ["2015", "2017", "2017", "2015"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{btr_tp.id => 22}
    end

    test "return price_tax_year when price_tax_year is nil by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: nil, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == nil
      assert data                           == :error
    end

    test "return price_tax_year when price_tax_year is 0 by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 0, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 0
      assert data                           == :error
    end

    test "return price_tax_year when price_tax_year is 1 by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 1, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year)  == tax_year
      assert btr_tp.price_tax_year          == nil
      assert format_names(btr_pro.tax_year) == nil
      assert btr_pro.price_tax_year         == 1
      assert data                           == %{btr_tp.id => 2}
    end
  end

  describe "#check_value" do
    test "return value_accounting_software by role Tp" do
      match = insert(:match_value_relat, value_for_business_accounting_software: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, accounting_software: true, user: tp)
      data = BusinessTaxReturn.check_value_accounting_software(btr_tp.id)
      assert D.to_string(match.value_for_business_accounting_software) == "22"
      assert btr_tp.accounting_software                                == true
      assert data                                                      == %{btr_tp.id => D.new("22")}
    end

    test "return value_accounting_software match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_accounting_software: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, accounting_software: true, user: tp)
      data = BusinessTaxReturn.check_value_accounting_software(btr_tp.id)
      assert D.to_string(match.value_for_business_accounting_software) == "0"
      assert btr_tp.accounting_software                                == true
      assert data                                                      == %{btr_tp.id => D.new("0")}
    end

    test "return value_accounting_software match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_accounting_software: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, accounting_software: true, user: tp)
      data = BusinessTaxReturn.check_value_accounting_software(btr_tp.id)
      assert D.to_string(match.value_for_business_accounting_software) == "1"
      assert btr_tp.accounting_software                                == true
      assert data                                                      == %{btr_tp.id => D.new("1")}
    end

    test "return value_accounting_software match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_accounting_software: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, accounting_software: true, user: tp)
      data = BusinessTaxReturn.check_value_accounting_software(btr_tp.id)
      assert match.value_for_business_accounting_software == nil
      assert btr_tp.accounting_software                   == true
      assert data                                         == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_accounting_software when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_accounting_software: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, accounting_software: false, user: tp)
      data = BusinessTaxReturn.check_value_accounting_software(btr_tp.id)
      assert D.to_string(match.value_for_business_accounting_software) == "22"
      assert btr_tp.accounting_software                                == false
      assert data                                                      == :error
    end

    test "return value_accounting_software when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_accounting_software: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, accounting_software: nil, user: tp)
      data = BusinessTaxReturn.check_value_accounting_software(btr_tp.id)
      assert D.to_string(match.value_for_business_accounting_software) == "22"
      assert btr_tp.accounting_software                                == nil
      assert data                                                      == :error
    end

    test "return value_accounting_software by role Pro" do
      match = insert(:match_value_relat, value_for_business_accounting_software: 22)
      pro = insert(:pro_user)
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_accounting_software(btr_pro.id)
      assert D.to_string(match.value_for_business_accounting_software) == "22"
      assert btr_pro.accounting_software                               == nil
      assert data                                                      == :error
    end

    test "return value_business_entity_type by role Tp" do
      name = "Partnership"
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_entity_type(btr_tp.id)
      assert format_name(bet_tp.name)  == name
      assert bet_tp.price              == nil
      assert data                      == %{btr_tp.id => D.new("299.99")}
    end

    test "return value_business_entity_type when name is nil by role Tp" do
      name = nil
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bet_tp = insert(:tp_business_entity_type, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_entity_type(btr_tp.id)
      assert format_name(bet_tp.name)  == nil
      assert bet_tp.price              == nil
      assert data                      == :error
    end

    test "return value_business_entity_type by role Pro" do
      name = "Partnership"
      pro = insert(:tp_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      bet_pro = insert(:pro_business_entity_type, name: name, price: 22, business_tax_returns: btr_pro)
      data = BusinessTaxReturn.check_value_business_entity_type(btr_pro.id)
      assert format_name(bet_pro.name)  == name
      assert bet_pro.price              == 22
      assert data                       == :error
    end

    test "return value_business_foreign_ownership_count by role Tp" do
      name = "1"
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bfo_tp = insert(:tp_business_foreign_ownership_count, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_foreign_ownership_count(btr_tp.id)
      assert format_name(bfo_tp.name)  == name
      assert data                      == %{btr_tp.id => D.new("150.0")}
    end

    test "return value_business_foreign_ownership_count when name is nil by role Tp" do
      name = nil
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      bfo_tp = insert(:tp_business_foreign_ownership_count, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_foreign_ownership_count(btr_tp.id)
      assert format_name(bfo_tp.name)  == nil
      assert data                      == :error
    end

    test "return value_business_total_revenue by role Tp" do
      name = "$1M - $5M"
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_total_revenue(btr_tp.id)
      assert format_name(br_tp.name)  == name
      assert br_tp.price              == nil
      assert data                     == %{btr_tp.id => D.new("300.0")}
    end

    test "return value_business_total_revenue when name is nil by role Tp" do
      name = nil
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      br_tp = insert(:tp_business_total_revenue, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_total_revenue(btr_tp.id)
      assert format_name(br_tp.name)  == nil
      assert br_tp.price              == nil
      assert data                     == :error
    end

    test "return value_business_total_revenue by role Pro" do
      name = "$1M - $5M"
      pro = insert(:tp_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      br_pro = insert(:pro_business_total_revenue, name: name, price: 22, business_tax_returns: btr_pro)
      data = BusinessTaxReturn.check_value_business_total_revenue(btr_pro.id)
      assert format_name(br_pro.name)  == name
      assert br_pro.price              == 22
      assert data                      == :error
    end

    test "value_business_transaction_count by role Tp" do
      name = "1-10"
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      btc_tp = insert(:tp_business_transaction_count, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_transaction_count(btr_tp.id)
      assert format_name(btc_tp.name)  == name
      assert data                      == %{btr_tp.id => D.new("29.99")}
    end

    test "value_business_transaction_count when name is nil by role Tp" do
      name = nil
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      btc_tp = insert(:tp_business_transaction_count, name: name, business_tax_returns: btr_tp)
      data = BusinessTaxReturn.check_value_business_transaction_count(btr_tp.id)
      assert format_name(btc_tp.name)  == name
      assert data                      == :error
    end

    test "return value_dispose_property by role Tp" do
      match = insert(:match_value_relat, value_for_business_dispose_property: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, dispose_property: true, user: tp)
      data = BusinessTaxReturn.check_value_dispose_property(btr_tp.id)
      assert D.to_string(match.value_for_business_dispose_property) == "22"
      assert btr_tp.dispose_property                                == true
      assert data                                                   == %{btr_tp.id => D.new("22")}
    end

    test "return value_dispose_property when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_dispose_property: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, dispose_property: true, user: tp)
      data = BusinessTaxReturn.check_value_dispose_property(btr_tp.id)
      assert D.to_string(match.value_for_business_dispose_property) == "0"
      assert btr_tp.dispose_property                                == true
      assert data                                                   == %{btr_tp.id => D.new("0")}
    end

    test "return value_dispose_property when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_dispose_property: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, dispose_property: true, user: tp)
      data = BusinessTaxReturn.check_value_dispose_property(btr_tp.id)
      assert D.to_string(match.value_for_business_dispose_property) == "1"
      assert btr_tp.dispose_property                                == true
      assert data                                                   == %{btr_tp.id => D.new("1")}
    end

    test "return value_dispose_property when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_dispose_property: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, dispose_property: true, user: tp)
      data = BusinessTaxReturn.check_value_dispose_property(btr_tp.id)
      assert match.value_for_business_dispose_property == nil
      assert btr_tp.dispose_property                   == true
      assert data                                      == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_dispose_property when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_dispose_property: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, dispose_property: false, user: tp)
      data = BusinessTaxReturn.check_value_dispose_property(btr_tp.id)
      assert D.to_string(match.value_for_business_dispose_property) == "22"
      assert btr_tp.dispose_property                                == false
      assert data                                                   == :error
    end

    test "return value_dispose_property when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_dispose_property: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, dispose_property: nil, user: tp)
      data = BusinessTaxReturn.check_value_dispose_property(btr_tp.id)
      assert D.to_string(match.value_for_business_dispose_property) == "22"
      assert btr_tp.dispose_property                                == nil
      assert data                                                   == :error
    end

    test "return value_dispose_property by role Pro" do
      match = insert(:match_value_relat, value_for_business_dispose_property: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_dispose_property(btr_pro.id)
      assert D.to_string(match.value_for_business_dispose_property) == "22"
      assert btr_pro.dispose_property                               == nil
      assert data                                                   == :error
    end

    test "return value_foreign_shareholder by role Tp" do
      match = insert(:match_value_relat, value_for_business_foreign_shareholder: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, foreign_shareholder: true, user: tp)
      data = BusinessTaxReturn.check_value_foreign_shareholder(btr_tp.id)
      assert D.to_string(match.value_for_business_foreign_shareholder) == "22"
      assert btr_tp.foreign_shareholder                                == true
      assert data                                                      == %{btr_tp.id => D.new("22")}
    end

    test "return value_foreign_shareholder when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_foreign_shareholder: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, foreign_shareholder: true, user: tp)
      data = BusinessTaxReturn.check_value_foreign_shareholder(btr_tp.id)
      assert D.to_string(match.value_for_business_foreign_shareholder) == "0"
      assert btr_tp.foreign_shareholder                                == true
      assert data                                                      == %{btr_tp.id => D.new("0")}
    end

    test "return value_foreign_shareholder when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_foreign_shareholder: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, foreign_shareholder: true, user: tp)
      data = BusinessTaxReturn.check_value_foreign_shareholder(btr_tp.id)
      assert match.value_for_business_foreign_shareholder == nil
      assert btr_tp.foreign_shareholder                   == true
      assert data                                         == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_foreign_shareholder when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_foreign_shareholder: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, foreign_shareholder: true, user: tp)
      data = BusinessTaxReturn.check_value_foreign_shareholder(btr_tp.id)
      assert D.to_string(match.value_for_business_foreign_shareholder) == "1"
      assert btr_tp.foreign_shareholder                                == true
      assert data                                                      == %{btr_tp.id => D.new("1")}
    end

    test "return value_foreign_shareholder when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_foreign_shareholder: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, foreign_shareholder: false, user: tp)
      data = BusinessTaxReturn.check_value_foreign_shareholder(btr_tp.id)
      assert D.to_string(match.value_for_business_foreign_shareholder) == "22"
      assert btr_tp.foreign_shareholder                                == false
      assert data                                                      == :error
    end

    test "return value_foreign_shareholder when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_foreign_shareholder: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, foreign_shareholder: nil, user: tp)
      data = BusinessTaxReturn.check_value_foreign_shareholder(btr_tp.id)
      assert D.to_string(match.value_for_business_foreign_shareholder) == "22"
      assert btr_tp.foreign_shareholder                                == nil
      assert data                                                      == :error
    end

    test "return value_foreign_shareholder by role Pro" do
      match = insert(:match_value_relat, value_for_business_foreign_shareholder: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_foreign_shareholder(btr_pro.id)
      assert D.to_string(match.value_for_business_foreign_shareholder) == "22"
      assert btr_pro.foreign_shareholder                               == nil
      assert data                                                      == :error
    end

    test "return value_income_over_thousand by role Tp" do
      match = insert(:match_value_relat, value_for_business_income_over_thousand: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, income_over_thousand: true, user: tp)
      data = BusinessTaxReturn.check_value_income_over_thousand(btr_tp.id)
      assert D.to_string(match.value_for_business_income_over_thousand) == "22"
      assert btr_tp.income_over_thousand                                == true
      assert data                                                       == %{btr_tp.id => D.new("22")}
    end

    test "return value_income_over_thousand when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_income_over_thousand: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, income_over_thousand: true, user: tp)
      data = BusinessTaxReturn.check_value_income_over_thousand(btr_tp.id)
      assert D.to_string(match.value_for_business_income_over_thousand) == "0"
      assert btr_tp.income_over_thousand                                == true
      assert data                                                       == %{btr_tp.id => D.new("0")}
    end

    test "return value_income_over_thousand when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_income_over_thousand: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, income_over_thousand: true, user: tp)
      data = BusinessTaxReturn.check_value_income_over_thousand(btr_tp.id)
      assert D.to_string(match.value_for_business_income_over_thousand) == "1"
      assert btr_tp.income_over_thousand                                == true
      assert data                                                       == %{btr_tp.id => D.new("1")}
    end

    test "return value_income_over_thousand when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_income_over_thousand: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, income_over_thousand: true, user: tp)
      data = BusinessTaxReturn.check_value_income_over_thousand(btr_tp.id)
      assert match.value_for_business_income_over_thousand == nil
      assert btr_tp.income_over_thousand                   == true
     assert data                                          == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_income_over_thousand when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_income_over_thousand: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, income_over_thousand: false, user: tp)
      data = BusinessTaxReturn.check_value_income_over_thousand(btr_tp.id)
      assert D.to_string(match.value_for_business_income_over_thousand) == "22"
      assert btr_tp.income_over_thousand                                == false
      assert data                                                       == :error
    end

    test "return value_income_over_thousand when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_income_over_thousand: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, income_over_thousand: nil, user: tp)
      data = BusinessTaxReturn.check_value_income_over_thousand(btr_tp.id)
      assert D.to_string(match.value_for_business_income_over_thousand) == "22"
      assert btr_tp.income_over_thousand                                == nil
      assert data                                                       == :error
    end

    test "return value_income_over_thousand by role Pro" do
      match = insert(:match_value_relat, value_for_business_income_over_thousand: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_income_over_thousand(btr_pro.id)
      assert D.to_string(match.value_for_business_income_over_thousand) == "22"
      assert btr_pro.income_over_thousand                               == nil
      assert data                                                       == :error
    end

    test "return value_invest_research by role Tp" do
      match = insert(:match_value_relat, value_for_business_invest_research: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, invest_research: true, user: tp)
      data = BusinessTaxReturn.check_value_invest_research(btr_tp.id)
      assert D.to_string(match.value_for_business_invest_research) == "22"
      assert btr_tp.invest_research                                == true
      assert data                                                  == %{btr_tp.id => D.new("22")}
    end

    test "return value_invest_research when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_invest_research: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, invest_research: true, user: tp)
      data = BusinessTaxReturn.check_value_invest_research(btr_tp.id)
      assert D.to_string(match.value_for_business_invest_research) == "0"
      assert btr_tp.invest_research                                == true
      assert data                                                  == %{btr_tp.id => D.new("0")}
    end

    test "return value_invest_research when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_invest_research: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, invest_research: true, user: tp)
      data = BusinessTaxReturn.check_value_invest_research(btr_tp.id)
      assert D.to_string(match.value_for_business_invest_research) == "1"
      assert btr_tp.invest_research                                == true
      assert data                                                  == %{btr_tp.id => D.new("1")}
    end

    test "return value_invest_research when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_invest_research: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, invest_research: true, user: tp)
      data = BusinessTaxReturn.check_value_invest_research(btr_tp.id)
      assert match.value_for_business_invest_research == nil
      assert btr_tp.invest_research                   == true
      assert data                                     == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_invest_research when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_invest_research: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, invest_research: false, user: tp)
      data = BusinessTaxReturn.check_value_invest_research(btr_tp.id)
      assert D.to_string(match.value_for_business_invest_research) == "22"
      assert btr_tp.invest_research                                == false
      assert data                                                  == :error
    end

    test "return value_invest_research when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_invest_research: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, invest_research: nil, user: tp)
      data = BusinessTaxReturn.check_value_invest_research(btr_tp.id)
      assert D.to_string(match.value_for_business_invest_research) == "22"
      assert btr_tp.invest_research                                == nil
      assert data                                                  == :error
    end

    test "return value_invest_research by role Pro" do
      match = insert(:match_value_relat, value_for_business_invest_research: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_invest_research(btr_pro.id)
      assert D.to_string(match.value_for_business_invest_research) == "22"
      assert btr_pro.invest_research                               == nil
      assert data                                                  == :error
    end

    test "return value_k1_count by role Tp" do
      match = insert(:match_value_relat, value_for_business_k1_count: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, k1_count: 22, user: tp)
      data = BusinessTaxReturn.check_value_k1_count(btr_tp.id)
      assert D.to_string(match.value_for_business_k1_count) == "22"
      assert btr_tp.k1_count                                == 22
      assert data                                           == %{btr_tp.id => D.new("484")}
    end

    test "return value_k1_count when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_k1_count: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, k1_count: 22, user: tp)
      data = BusinessTaxReturn.check_value_k1_count(btr_tp.id)
      assert D.to_string(match.value_for_business_k1_count) == "0"
      assert btr_tp.k1_count                                == 22
      assert data                                           == %{btr_tp.id => D.new("0")}
    end

    test "return value_k1_count when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_k1_count: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, k1_count: 22, user: tp)
      data = BusinessTaxReturn.check_value_k1_count(btr_tp.id)
      assert D.to_string(match.value_for_business_k1_count) == "1"
      assert btr_tp.k1_count                                == 22
      assert data                                           == %{btr_tp.id => D.new("22")}
    end

    test "return value_k1_count when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_k1_count: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, k1_count: 22, user: tp)
      data = BusinessTaxReturn.check_value_k1_count(btr_tp.id)
      assert match.value_for_business_k1_count == nil
      assert btr_tp.k1_count                   == 22
      assert data                              == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_k1_count when is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_k1_count: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, k1_count: 0, user: tp)
      data = BusinessTaxReturn.check_value_k1_count(btr_tp.id)
      assert D.to_string(match.value_for_business_k1_count) == "22"
      assert btr_tp.k1_count                                == 0
      assert data                                           == :error
    end

    test "return value_k1_count when k1_count is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_k1_count: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, k1_count: nil, user: tp)
      data = BusinessTaxReturn.check_value_k1_count(btr_tp.id)
      assert D.to_string(match.value_for_business_k1_count) == "22"
      assert btr_tp.k1_count                                == nil
      assert data                                           == :error
    end

    test "return value_k1_count when k1_count is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_k1_count: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, k1_count: 1, user: tp)
      data = BusinessTaxReturn.check_value_k1_count(btr_tp.id)
      assert D.to_string(match.value_for_business_k1_count) == "22"
      assert btr_tp.k1_count                                == 1
      assert data                                           == %{btr_tp.id => D.new("22")}
    end

    test "return value_k1_count by role Pro" do
      match = insert(:match_value_relat, value_for_business_k1_count: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_k1_count(btr_pro.id)
      assert D.to_string(match.value_for_business_k1_count) == "22"
      assert btr_pro.k1_count                               == nil
      assert data                                           == :error
    end

    test "return value_make_distribution by role Tp" do
      match = insert(:match_value_relat, value_for_business_make_distribution: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, make_distribution: true, user: tp)
      data = BusinessTaxReturn.check_value_make_distribution(btr_tp.id)
      assert D.to_string(match.value_for_business_make_distribution) == "22"
      assert btr_tp.make_distribution                                == true
      assert data                                                    == %{btr_tp.id => D.new("22")}
    end

    test "return value_make_distribution when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_make_distribution: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, make_distribution: true, user: tp)
      data = BusinessTaxReturn.check_value_make_distribution(btr_tp.id)
      assert D.to_string(match.value_for_business_make_distribution) == "0"
      assert btr_tp.make_distribution                                == true
      assert data                                                    == %{btr_tp.id => D.new("0")}
    end

    test "return value_make_distribution when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_make_distribution: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, make_distribution: true, user: tp)
      data = BusinessTaxReturn.check_value_make_distribution(btr_tp.id)
      assert D.to_string(match.value_for_business_make_distribution) == "1"
      assert btr_tp.make_distribution                                == true
      assert data                                                    == %{btr_tp.id => D.new("1")}
    end

    test "return value_make_distribution when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_make_distribution: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, make_distribution: true, user: tp)
      data = BusinessTaxReturn.check_value_make_distribution(btr_tp.id)
      assert match.value_for_business_make_distribution == nil
      assert btr_tp.make_distribution                   == true
      assert data                                       == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_make_distribution when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_make_distribution: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, make_distribution: false, user: tp)
      data = BusinessTaxReturn.check_value_make_distribution(btr_tp.id)
      assert D.to_string(match.value_for_business_make_distribution) == "22"
      assert btr_tp.make_distribution                                == false
      assert data                                                    == :error
    end

    test "return value_make_distribution when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_make_distribution: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, make_distribution: nil, user: tp)
      data = BusinessTaxReturn.check_value_make_distribution(btr_tp.id)
      assert D.to_string(match.value_for_business_make_distribution) == "22"
      assert btr_tp.make_distribution                                == nil
      assert data                                                    == :error
    end

    test "return value_make_distribution bt role Pro" do
      match = insert(:match_value_relat, value_for_business_make_distribution: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_make_distribution(btr_pro.id)
      assert D.to_string(match.value_for_business_make_distribution) == "22"
      assert btr_pro.make_distribution                               == nil
      assert data                                                    == :error
    end

    test "return value_state by role Tp" do
      state = [
        "Alaska",
        "Michigan",
        "New Jersey",
        "American Samoa",
        "Michigan",
        "American Samoa",
        "New Jersey",
        "Delaware",
        "California",
        "Connecticut"
      ] |> Enum.sort() |> Enum.uniq()
      match = insert(:match_value_relat, value_for_business_state: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      data = BusinessTaxReturn.check_value_state(btr_tp.id)
      assert D.to_string(match.value_for_business_state) == "22"
      assert btr_tp.state                                == state
      assert btr_tp.price_state                          == nil
      assert data                                        == %{btr_tp.id => D.new("154")}
    end

    test "return value_state when state is 0 by role Tp" do
      state = []
      match = insert(:match_value_relat, value_for_business_state: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      data = BusinessTaxReturn.check_value_state(btr_tp.id)
      assert D.to_string(match.value_for_business_state) == "22"
      assert btr_tp.state                                == state
      assert btr_tp.price_state                          == nil
      assert data                                        == :error
    end

    test "return value_state by when state is 1 role Tp" do
      state = ["American Samoa"]
      match = insert(:match_value_relat, value_for_business_state: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      data = BusinessTaxReturn.check_value_state(btr_tp.id)
      assert D.to_string(match.value_for_business_state) == "22"
      assert btr_tp.state                                == state
      assert btr_tp.price_state                          == nil
      assert data                                        == %{btr_tp.id => D.new("22")}
    end

    test "return value_state by role Pro" do
      match = insert(:match_value_relat, value_for_business_state: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_state(btr_pro.id)
      assert D.to_string(match.value_for_business_state) == "22"
      assert btr_pro.state                               == nil
      assert btr_pro.price_state                         == btr_pro.price_state
      assert data                                        == :error
    end

    test "return value_tax_exemption by role Tp" do
      match = insert(:match_value_relat, value_for_business_tax_exemption: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_exemption: true, user: tp)
      data = BusinessTaxReturn.check_value_tax_exemption(btr_tp.id)
      assert D.to_string(match.value_for_business_tax_exemption) == "22"
      assert btr_tp.tax_exemption                                == true
      assert data                                                == %{btr_tp.id => D.new("22")}
    end

    test "return value_tax_exemption when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_tax_exemption: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_exemption: true, user: tp)
      data = BusinessTaxReturn.check_value_tax_exemption(btr_tp.id)
      assert D.to_string(match.value_for_business_tax_exemption) == "0"
      assert btr_tp.tax_exemption                                == true
      assert data                                                == %{btr_tp.id => D.new("0")}
    end

    test "return value_tax_exemption when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_tax_exemption: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_exemption: true, user: tp)
      data = BusinessTaxReturn.check_value_tax_exemption(btr_tp.id)
      assert D.to_string(match.value_for_business_tax_exemption) == "1"
      assert btr_tp.tax_exemption                                == true
      assert data                                                == %{btr_tp.id => D.new("1")}
    end

    test "return value_tax_exemption when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_tax_exemption: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_exemption: true, user: tp)
      data = BusinessTaxReturn.check_value_tax_exemption(btr_tp.id)
      assert match.value_for_business_tax_exemption == nil
      assert btr_tp.tax_exemption                   == true
      assert data                                   == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_tax_exemption when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_tax_exemption: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_exemption: false, user: tp)
      data = BusinessTaxReturn.check_value_tax_exemption(btr_tp.id)
      assert D.to_string(match.value_for_business_tax_exemption) == "22"
      assert btr_tp.tax_exemption                                == false
      assert data                                                == :error
    end

    test "return value_tax_exemption when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_tax_exemption: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_exemption: false, user: tp)
      data = BusinessTaxReturn.check_value_tax_exemption(btr_tp.id)
      assert match.value_for_business_tax_exemption == nil
      assert btr_tp.tax_exemption                   == false
      assert data                                   == :error
    end

    test "return value_tax_exemption by role Pro" do
      match = insert(:match_value_relat, value_for_business_tax_exemption: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_tax_exemption(btr_pro.id)
      assert D.to_string(match.value_for_business_tax_exemption) == "22"
      assert btr_pro.tax_exemption                               == nil
      assert data                                                == :error
    end

    test "return value_tax_year by role Tp" do
      tax_year = ["2012", "2015", "2011", "2012", "2017", "2011"] |> Enum.sort() |> Enum.uniq()
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      data = BusinessTaxReturn.check_value_tax_year(btr_tp.id)
      assert btr_tp.tax_year       == tax_year
      assert btr_tp.price_tax_year == nil
      assert data                  == %{btr_tp.id => D.new("4")}
    end

    test "return value_tax_year when is 0 by role Tp" do
      tax_year = []
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      data = BusinessTaxReturn.check_value_tax_year(btr_tp.id)
      assert btr_tp.tax_year == tax_year
      assert data            == %{btr_tp.id => D.new("0")}
    end

    test "return value_tax_year when is 1 by role Tp" do
      tax_year = ["2012", "2012", "2012", "2012", "2012"] |> Enum.sort() |> Enum.uniq()
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      data = BusinessTaxReturn.check_value_tax_year(btr_tp.id)
      assert btr_tp.tax_year       == tax_year
      assert btr_tp.price_tax_year == nil
      assert data                  == %{btr_tp.id => D.new("1")}
    end

    test "return value_tax_year by role Pro" do
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_tax_year(btr_pro.id)
      assert btr_pro.tax_year       == nil
      assert btr_pro.price_tax_year == btr_pro.price_tax_year
      assert data                   == :error
    end

    test "return value_total_asset_over by role Tp" do
      match = insert(:match_value_relat, value_for_business_total_asset_over: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, total_asset_over: true, user: tp)
      data = BusinessTaxReturn.check_value_total_asset_over(btr_tp.id)
      assert D.to_string(match.value_for_business_total_asset_over) == "22"
      assert btr_tp.total_asset_over                                == true
      assert data                                                   == %{btr_tp.id => D.new("22")}
    end

    test "return value_total_asset_over when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_business_total_asset_over: 0)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, total_asset_over: true, user: tp)
      data = BusinessTaxReturn.check_value_total_asset_over(btr_tp.id)
      assert D.to_string(match.value_for_business_total_asset_over) == "0"
      assert btr_tp.total_asset_over                                == true
      assert data                                                   == %{btr_tp.id => D.new("0")}
    end

    test "return value_total_asset_over when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_business_total_asset_over: 1)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, total_asset_over: true, user: tp)
      data = BusinessTaxReturn.check_value_total_asset_over(btr_tp.id)
      assert D.to_string(match.value_for_business_total_asset_over) == "1"
      assert btr_tp.total_asset_over                                == true
      assert data                                                   == %{btr_tp.id => D.new("1")}
    end

    test "return value_total_asset_over when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_total_asset_over: nil)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, total_asset_over: true, user: tp)
      data = BusinessTaxReturn.check_value_total_asset_over(btr_tp.id)
      assert match.value_for_business_total_asset_over == nil
      assert btr_tp.total_asset_over                   == true
      assert data                                      == %{btr_tp.id => D.new("0.0")}
    end

    test "return value_total_asset_over when is false by role Tp" do
      match = insert(:match_value_relat, value_for_business_total_asset_over: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, total_asset_over: false, user: tp)
      data = BusinessTaxReturn.check_value_total_asset_over(btr_tp.id)
      assert D.to_string(match.value_for_business_total_asset_over) == "22"
      assert btr_tp.total_asset_over                                == false
      assert data                                                   == :error
    end

    test "return value_total_asset_over when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_business_total_asset_over: 22)
      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, total_asset_over: nil, user: tp)
      data = BusinessTaxReturn.check_value_total_asset_over(btr_tp.id)
      assert D.to_string(match.value_for_business_total_asset_over) == "22"
      assert btr_tp.total_asset_over                                == nil
      assert data                                                   == :error
    end

    test "return value_total_asset_over by role Pro" do
      match = insert(:match_value_relat, value_for_business_total_asset_over: 22)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, user: pro)
      data = BusinessTaxReturn.check_value_total_asset_over(btr_pro.id)
      assert D.to_string(match.value_for_business_total_asset_over) == "22"
      assert btr_pro.total_asset_over                               == nil
      assert data                                                   == :error
    end
  end

  describe "#total_match" do
    test "return result by total_match where role is Tp" do
      name_entity_type = "Partnership"
      name_industry = Enum.sort(["Hospitality"])
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      name_number_employee = "1 employee"
      name_total_revenue = "$1M - $5M"

      insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      btr_pro = insert(:pro_business_tax_return, user: pro)

      insert(:pro_business_entity_type, name: name_entity_type, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_industry,  name: names_industry,  business_tax_returns: btr_pro)
      insert(:pro_business_number_employee, name: name_number_employee, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_total_revenue, name: name_total_revenue, price: 22, business_tax_returns: btr_pro)
      insert(:tp_business_entity_type, name: name_entity_type, business_tax_returns: btr_tp)
      insert(:tp_business_industry,  name: name_industry,  business_tax_returns: btr_tp)
      insert(:tp_business_number_employee, name: name_number_employee, business_tax_returns: btr_tp)
      insert(:tp_business_total_revenue, name: name_total_revenue, business_tax_returns: btr_tp)

      data = Analyzes.total_match(btr_tp.id)
      assert data == %{btr_pro.id => 120}
    end

    test "return result by total_match where role is Pro" do
      name_entity_type = "Partnership"
      name_industry = Enum.sort(["Hospitality"])
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      name_number_employee = "1 employee"
      name_total_revenue = "$1M - $5M"

      insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, user: tp)
      btr_pro = insert(:pro_business_tax_return, user: pro)

      insert(:pro_business_entity_type, name: name_entity_type, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_industry,  name: names_industry, business_tax_returns: btr_pro)
      insert(:pro_business_number_employee, name: name_number_employee, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_total_revenue, name: name_total_revenue, price: 22, business_tax_returns: btr_pro)
      insert(:tp_business_entity_type, name: name_entity_type, business_tax_returns: btr_tp)
      insert(:tp_business_industry,  name: name_industry,  business_tax_returns: btr_tp)
      insert(:tp_business_number_employee, name: name_number_employee, business_tax_returns: btr_tp)
      insert(:tp_business_total_revenue, name: name_total_revenue, business_tax_returns: btr_tp)

      data = Analyzes.total_match(btr_pro.id)
      assert data == %{btr_tp.id => 120}
    end

    test "return error when is not correct business_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_match(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "#total_price" do
    test "return result by total_price where role is Tp" do
      name_entity_type = "Partnership"
      name_number_employee = "1 employee"
      name_total_revenue = "$1M - $5M"
      state = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort()
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, tax_year: tax_year, user: tp)
      btr_pro = insert(:pro_business_tax_return, price_state: 22, price_tax_year: 22, user: pro)

      insert(:pro_business_entity_type, name: name_entity_type, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_number_employee, name: name_number_employee, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_total_revenue, name: name_total_revenue, price: 22, business_tax_returns: btr_pro)
      insert(:tp_business_entity_type, name: name_entity_type, business_tax_returns: btr_tp)
      insert(:tp_business_number_employee, name: name_number_employee, business_tax_returns: btr_tp)
      insert(:tp_business_total_revenue, name: name_total_revenue, business_tax_returns: btr_tp)

      data = Analyzes.total_price(btr_tp.id)
      assert data == %{btr_pro.id => 176}
    end

    test "return result by total_price where role is Pro" do
      name_entity_type = "Partnership"
      name_number_employee = "1 employee"
      name_total_revenue = "$1M - $5M"
      state = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort()
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, tax_year: tax_year, user: tp)
      btr_pro = insert(:pro_business_tax_return, price_state: 22, price_tax_year: 22, user: pro)

      insert(:pro_business_entity_type, name: name_entity_type, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_number_employee, name: name_number_employee, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_total_revenue, name: name_total_revenue, price: 22, business_tax_returns: btr_pro)
      insert(:tp_business_entity_type, name: name_entity_type, business_tax_returns: btr_tp)
      insert(:tp_business_number_employee, name: name_number_employee, business_tax_returns: btr_tp)
      insert(:tp_business_total_revenue, name: name_total_revenue, business_tax_returns: btr_tp)

      data = Analyzes.total_price(btr_pro.id)
      assert data == %{btr_tp.id => 132}
    end

    test "return error when is not correct business_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_price(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "total_value" do
    test "return result by total_value where role is Tp" do
      name_entity_type = "Partnership"
      name_foreign_ownership_count = "1"
      name_total_revenue = "$1M - $5M"
      name_transaction_count = "1-10"
      state = [
        "Alaska",
        "Michigan",
        "New Jersey",
        "American Samoa",
        "Michigan",
        "American Samoa",
        "New Jersey",
        "Delaware",
        "California",
        "Connecticut"
      ] |> Enum.sort() |> Enum.uniq()
      tax_year = [
        "2015", "2016", "2016", "2015","2017", "2017"
      ] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return,
        accounting_software: true,
        dispose_property: true,
        foreign_shareholder: true,
        income_over_thousand: true,
        invest_research: true,
        k1_count: 22,
        make_distribution: true,
        state: state,
        tax_exemption: true,
        tax_year: tax_year,
        total_asset_over: true,
        user: tp
      )

      insert(:tp_business_entity_type, name: name_entity_type, business_tax_returns: btr_tp)
      insert(:tp_business_foreign_ownership_count, name: name_foreign_ownership_count, business_tax_returns: btr_tp)
      insert(:tp_business_total_revenue, name: name_total_revenue, business_tax_returns: btr_tp)
      insert(:tp_business_transaction_count, name: name_transaction_count, business_tax_returns: btr_tp)

      insert(:match_value_relat,
        value_for_business_accounting_software: 22,
        value_for_business_dispose_property: 22,
        value_for_business_foreign_shareholder: 22,
        value_for_business_income_over_thousand: 22,
        value_for_business_invest_research: 22,
        value_for_business_k1_count: 22,
        value_for_business_make_distribution: 22,
        value_for_business_state: 22,
        value_for_business_tax_exemption: 22,
        value_for_business_total_asset_over: 22
      )

      data = Analyzes.total_value(btr_tp.id)
      assert data == %{btr_tp.id => D.new("1596.98")}
    end

    test "return result by total_value where role is Pro" do
      name_entity_type = "Partnership"
      name_total_revenue = "$1M - $5M"

      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, price_tax_year: 22, user: pro)

      insert(:pro_business_entity_type, name: name_entity_type, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_total_revenue, name: name_total_revenue, price: 22, business_tax_returns: btr_pro)

      insert(:match_value_relat,
        value_for_business_accounting_software: 22,
        value_for_business_dispose_property: 22,
        value_for_business_foreign_shareholder: 22,
        value_for_business_income_over_thousand: 22,
        value_for_business_invest_research: 22,
        value_for_business_k1_count: 22,
        value_for_business_make_distribution: 22,
        value_for_business_state: 22,
        value_for_business_tax_exemption: 22,
        value_for_business_total_asset_over: 22
      )

      data = Analyzes.total_value(btr_pro.id)
      assert data == %{btr_pro.id => D.new("0")}
    end

    test "return error when is not correct business_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_value(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "#total_all" do
    test "return result by total_all where role is Tp" do
      name_entity_type = "Partnership"
      name_foreign_ownership_count = "1"
      name_industry = Enum.sort(["Hospitality"])
      name_number_employee = "1 employee"
      name_total_revenue = "$1M - $5M"
      name_transaction_count = "1-10"
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      state = [
        "Alaska",
        "Michigan",
        "New Jersey",
        "American Samoa",
        "Michigan",
        "American Samoa",
        "New Jersey",
        "Delaware",
        "California",
        "Connecticut"
      ] |> Enum.sort() |> Enum.uniq()
      tax_year = [
        "2015", "2016", "2016", "2015","2017", "2017"
      ] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return,
        accounting_software: true,
        dispose_property: true,
        foreign_shareholder: true,
        income_over_thousand: true,
        invest_research: true,
        k1_count: 22,
        make_distribution: true,
        state: state,
        tax_exemption: true,
        tax_year: tax_year,
        total_asset_over: true,
        user: tp
      )

      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, price_tax_year: 22, user: pro)

      insert(:match_value_relat,
        value_for_business_accounting_software: 22,
        value_for_business_dispose_property: 22,
        value_for_business_foreign_shareholder: 22,
        value_for_business_income_over_thousand: 22,
        value_for_business_invest_research: 22,
        value_for_business_k1_count: 22,
        value_for_business_make_distribution: 22,
        value_for_business_state: 22,
        value_for_business_tax_exemption: 22,
        value_for_business_total_asset_over: 22
      )

      insert(:pro_business_entity_type, name: name_entity_type, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_industry,  name: names_industry, business_tax_returns: btr_pro)
      insert(:pro_business_number_employee, name: name_number_employee, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_total_revenue, name: name_total_revenue, price: 22, business_tax_returns: btr_pro)
      insert(:tp_business_entity_type, name: name_entity_type, business_tax_returns: btr_tp)
      insert(:tp_business_foreign_ownership_count, name: name_foreign_ownership_count, business_tax_returns: btr_tp)
      insert(:tp_business_industry,  name: name_industry,  business_tax_returns: btr_tp)
      insert(:tp_business_number_employee, name: name_number_employee, business_tax_returns: btr_tp)
      insert(:tp_business_total_revenue, name: name_total_revenue, business_tax_returns: btr_tp)
      insert(:tp_business_transaction_count, name: name_transaction_count, business_tax_returns: btr_tp)

      data = Analyzes.total_all(btr_tp.id)

      assert data == [
        %{id: btr_tp.id, sum_value: %{btr_tp.id => D.new("1596.98")}},
        %{id: btr_pro.id, sum_match: 120},
        %{id: btr_pro.id, sum_price: 264}
      ]
    end

    test "return result by total_all where role is Pro" do
      name_entity_type = "Partnership"
      name_foreign_ownership_count = "1"
      name_industry = Enum.sort(["Hospitality"])
      name_number_employee = "1 employee"
      name_total_revenue = "$1M - $5M"
      name_transaction_count = "1-10"
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      state = [
        "Alaska",
        "Michigan",
        "New Jersey",
        "American Samoa",
        "Michigan",
        "American Samoa",
        "New Jersey",
        "Delaware",
        "California",
        "Connecticut"
      ] |> Enum.sort() |> Enum.uniq()
      tax_year = [
        "2015", "2016", "2016", "2015","2017", "2017"
      ] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return,
        accounting_software: true,
        dispose_property: true,
        foreign_shareholder: true,
        income_over_thousand: true,
        invest_research: true,
        k1_count: 22,
        make_distribution: true,
        state: state,
        tax_exemption: true,
        tax_year: tax_year,
        total_asset_over: true,
        user: tp
      )

      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, price_tax_year: 22, user: pro)

      insert(:match_value_relat,
        value_for_business_accounting_software: 22,
        value_for_business_dispose_property: 22,
        value_for_business_foreign_shareholder: 22,
        value_for_business_income_over_thousand: 22,
        value_for_business_invest_research: 22,
        value_for_business_k1_count: 22,
        value_for_business_make_distribution: 22,
        value_for_business_state: 22,
        value_for_business_tax_exemption: 22,
        value_for_business_total_asset_over: 22
      )

      insert(:pro_business_entity_type, name: name_entity_type, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_industry,  name: names_industry, business_tax_returns: btr_pro)
      insert(:pro_business_number_employee, name: name_number_employee, price: 22, business_tax_returns: btr_pro)
      insert(:pro_business_total_revenue, name: name_total_revenue, price: 22, business_tax_returns: btr_pro)
      insert(:tp_business_entity_type, name: name_entity_type, business_tax_returns: btr_tp)
      insert(:tp_business_foreign_ownership_count, name: name_foreign_ownership_count, business_tax_returns: btr_tp)
      insert(:tp_business_industry,  name: name_industry,  business_tax_returns: btr_tp)
      insert(:tp_business_number_employee, name: name_number_employee, business_tax_returns: btr_tp)
      insert(:tp_business_total_revenue, name: name_total_revenue, business_tax_returns: btr_tp)
      insert(:tp_business_transaction_count, name: name_transaction_count, business_tax_returns: btr_tp)

      data = Analyzes.total_all(btr_pro.id)

      assert data == [
        %{id: btr_pro.id, sum_value: %{btr_pro.id => D.new("0")}},
        %{id: btr_tp.id, sum_match: 120},
        %{id: btr_tp.id, sum_price: 132}
      ]
    end

    test "return error when is not correct business_tax_return_id" do
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
