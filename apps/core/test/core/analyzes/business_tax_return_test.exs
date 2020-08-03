defmodule Core.Analyzes.BusinessTaxReturnTest do
  use Core.DataCase

  alias Core.{
    Analyzes,
    Analyzes.BusinessTaxReturn
  }

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

    test "return price_state by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state) == state
      assert btr_tp.price_state         == nil
      assert btr_pro.state              == nil
      assert btr_pro.price_state        == 22
      assert data                       == %{btr_pro.id => 66}
    end

    test "return price_state when more one pro by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      btr_pro1 = insert(:pro_business_tax_return, price_state: 22, user: pro1)
      btr_pro2 = insert(:pro_business_tax_return, price_state: 33, user: pro2)
      btr_pro3 = insert(:pro_business_tax_return, price_state: 44, user: pro3)

      data = BusinessTaxReturn.check_price_state(btr_tp.id)

      assert format_names(btr_tp.state) == state
      assert btr_tp.price_state         == nil
      assert btr_pro1.state             == nil
      assert btr_pro2.state             == nil
      assert btr_pro3.state             == nil
      assert btr_pro1.price_state       == 22
      assert btr_pro2.price_state       == 33
      assert btr_pro3.price_state       == 44
      assert data                       == %{
        btr_pro1.id => 66,
        btr_pro2.id => 99,
        btr_pro3.id => 132
      }
    end

    test "return price_state by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_state: 22, user: pro)

      data = BusinessTaxReturn.check_price_state(btr_pro.id)

      assert format_names(btr_tp.state) == state
      assert btr_tp.price_state         == nil
      assert btr_pro.state              == nil
      assert btr_pro.price_state        == 22
      assert data                       == %{btr_tp.id => 22}
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
      assert btr_pro.state               == nil
      assert btr_pro.price_state         == 22
      assert data                        == %{
        btr_tp1.id => 66,
        btr_tp2.id => 66,
        btr_tp3.id => 66
      }
    end

    test "return price_tax_year by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_tp.id)

      assert format_names(btr_tp.tax_year) == tax_year
      assert btr_tp.price_tax_year         == nil
      assert btr_pro.tax_year              == nil
      assert btr_pro.price_tax_year        == 22
      assert data                          == %{btr_pro.id => 44}
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

      assert format_names(btr_tp.tax_year) == tax_year
      assert btr_tp.price_tax_year         == nil
      assert btr_pro1.tax_year             == nil
      assert btr_pro2.tax_year             == nil
      assert btr_pro3.tax_year             == nil
      assert btr_pro1.price_tax_year       == 22
      assert btr_pro2.price_tax_year       == 33
      assert btr_pro3.price_tax_year       == 44
      assert data                          == %{
        btr_pro1.id => 44,
        btr_pro2.id => 66,
        btr_pro3.id => 88
      }
    end

    test "return price_tax_year by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      btr_tp = insert(:tp_business_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      btr_pro = insert(:pro_business_tax_return, price_tax_year: 22, user: pro)

      data = BusinessTaxReturn.check_price_tax_year(btr_pro.id)

      assert format_names(btr_tp.tax_year) == tax_year
      assert btr_tp.price_tax_year         == nil
      assert btr_pro.tax_year              == nil
      assert btr_pro.price_tax_year        == 22
      assert data                          == %{btr_tp.id => 44}
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
      assert btr_pro.tax_year               == nil
      assert btr_pro.price_tax_year         == 22
      assert data                           == %{
        btr_tp1.id => 44,
        btr_tp2.id => 44,
        btr_tp3.id => 44
      }
    end
  end

  describe "#check_value" do
    test "check_value_accounting_software" do
    end

    test "check_value_business_entity_type" do
    end

    test "check_value_business_foreign_ownership_count" do
    end

    test "check_value_business_total_revenue" do
    end

    test "check_value_business_transaction_count" do
    end

    test "check_value_dispose_property" do
    end

    test "check_value_foreign_shareholder" do
    end

    test "check_value_income_over_thousand" do
    end

    test "check_value_invest_research" do
    end

    test "check_value_k1_count" do
    end

    test "check_value_make_distribution" do
    end

    test "check_value_state" do
    end

    test "check_value_tax_exemption" do
    end

    test "check_value_tax_year" do
    end

    test "check_value_total_asset_over" do
    end
  end

  describe "#total_match" do
    test "total_match" do
    end
  end

  describe "#total_price" do
    test "total_price" do
    end
  end

  describe "total_value" do
    test "total_value" do
    end
  end

  describe "#total_all" do
    test "total_all" do
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
