defmodule Core.Analyzes.BookKeepingTest do
  use Core.DataCase

  alias Core.{
    Analyzes,
    Analyzes.BookKeeping
  }

  describe "#check_match" do
    test "return match_payroll by role Tp" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_pro.id => match.match_for_book_keeping_payroll}
    end

    test "return match_payroll when more one pro by role Tp" do
      match = insert(:match_value_relat)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      bk_pro1 = insert(:pro_book_keeping, payroll: true, price_payroll: 22, user: pro1)
      bk_pro2 = insert(:pro_book_keeping, payroll: true, price_payroll: 33, user: pro2)
      bk_pro3 = insert(:pro_book_keeping, payroll: true, price_payroll: 44, user: pro3)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro1.payroll                      == true
      assert bk_pro1.price_payroll                == 22
      assert bk_pro2.payroll                      == true
      assert bk_pro2.price_payroll                == 33
      assert bk_pro3.payroll                      == true
      assert bk_pro3.price_payroll                == 44
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{
        bk_pro1.id => match.match_for_book_keeping_payroll,
        bk_pro2.id => match.match_for_book_keeping_payroll,
        bk_pro3.id => match.match_for_book_keeping_payroll
      }
    end

    test "return match_payroll when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_book_keeping_payroll: nil)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == nil
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_pro.id => 0}
    end

    test "return match_payroll when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_book_keeping_payroll: 0)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 0
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_pro.id => 0}
    end

    test "return match_payroll when match is 1 by role Tp" do
      match = insert(:match_value_relat, match_for_book_keeping_payroll: 1)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 1
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_pro.id => 1}
    end

    test "return match_payroll when is false by role Tp" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: false, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == false
      assert bk_tp.price_payroll                  == nil
      assert data                                 == :error
    end

    test "return match_payroll when is nil by role Tp" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == nil
      assert bk_tp.price_payroll                  == nil
      assert data                                 == :error
    end

    test "return match_payroll when price is nil by role Tp" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: nil, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == nil
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{}
    end

    test "return match_payroll when price is 0 by role Tp" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 0, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 0
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{}
    end

    test "return match_payroll when price is 1 by role Tp" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 1, user: pro)
      data = BookKeeping.check_match_payroll(bk_tp.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 1
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_pro.id => 20}
    end

    test "return match_payroll by role Pro" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_tp.id => match.match_for_book_keeping_payroll}
    end

    test "return match_payroll when more one pro by role Pro" do
      match = insert(:match_value_relat)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      bk_tp1 = insert(:tp_book_keeping, payroll: true, user: tp1)
      bk_tp2 = insert(:tp_book_keeping, payroll: true, user: tp2)
      bk_tp3 = insert(:tp_book_keeping, payroll: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:pro_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp1.payroll                       == true
      assert bk_tp1.price_payroll                 == nil
      assert bk_tp2.payroll                       == true
      assert bk_tp2.price_payroll                 == nil
      assert bk_tp3.payroll                       == true
      assert bk_tp3.price_payroll                 == nil
      assert data                                 == %{
        bk_tp1.id => match.match_for_book_keeping_payroll,
        bk_tp2.id => match.match_for_book_keeping_payroll,
        bk_tp3.id => match.match_for_book_keeping_payroll
      }
    end

    test "return match_payroll when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_book_keeping_payroll: nil)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == nil
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_tp.id => 0}
    end

    test "return match_payroll when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_book_keeping_payroll: 0)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 0
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_tp.id => 0}
    end

    test "return match_payroll when match is 1 by role Pro" do
      match = insert(:match_value_relat, match_for_book_keeping_payroll: 1)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 1
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_tp.id => 1}
    end

    test "return match_payroll when is false by role Pro" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: false, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == false
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == :error
    end

    test "return match_payroll when is nil by role Pro" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: nil, price_payroll: 22, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == nil
      assert bk_pro.price_payroll                 == 22
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == :error
    end

    test "return match_payroll when price is nil by role Pro" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: nil, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == nil
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == :error
    end

    test "return match_payroll when price is 0 by role Pro" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 0, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 0
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == :error
    end

    test "return match_payroll when price is 1 by role Pro" do
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, payroll: true, user: tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, payroll: true, price_payroll: 1, user: pro)
      data = BookKeeping.check_match_payroll(bk_pro.id)
      assert match.match_for_book_keeping_payroll == 20
      assert bk_pro.payroll                       == true
      assert bk_pro.price_payroll                 == 1
      assert bk_tp.payroll                        == true
      assert bk_tp.price_payroll                  == nil
      assert data                                 == %{bk_tp.id => 20}
    end

    test "return match_book_keeping_additional_need by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_pro.id => match.match_for_book_keeping_additional_need}
    end

    test "return match_book_keeping_additional_need when more one pro by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      bk_pro1 = insert(:pro_book_keeping, user: pro1)
      bk_pro2 = insert(:pro_book_keeping, user: pro2)
      bk_pro3 = insert(:pro_book_keeping, user: pro3)
      bkan_pro1 = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro1)
      bkan_pro2 = insert(:pro_book_keeping_additional_need, name: name, price: 33, book_keepings: bk_pro2)
      bkan_pro3 = insert(:pro_book_keeping_additional_need, name: name, price: 44, book_keepings: bk_pro3)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro1.name)                  == name
      assert format_name(bkan_pro2.name)                  == name
      assert format_name(bkan_pro3.name)                  == name
      assert bkan_pro1.price                              == 22
      assert bkan_pro2.price                              == 33
      assert bkan_pro3.price                              == 44
      assert data                                         == %{
        bk_pro1.id => match.match_for_book_keeping_additional_need,
        bk_pro2.id => match.match_for_book_keeping_additional_need,
        bk_pro3.id => match.match_for_book_keeping_additional_need
      }
    end

    test "return match_book_keeping_additional_need when match is 0 by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat, match_for_book_keeping_additional_need: 0)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 0
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_pro.id => match.match_for_book_keeping_additional_need}
    end

    test "return match_book_keeping_additional_need when match is nil by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat, match_for_book_keeping_additional_need: nil)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == nil
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_pro.id => 0}
    end

    test "return match_book_keeping_additional_need when match is 1 by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat, match_for_book_keeping_additional_need: 1)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 1
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_pro.id => 1}
    end

    test "return match_book_keeping_additional_need when name is nil by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: nil, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert bkan_tp.name                                 == nil
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == :error
    end

    test "return match_book_keeping_additional_need when name is another one by role Tp" do
      name_for_tp = "sales tax"
      name_for_pro = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name_for_tp, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name_for_pro, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name_for_tp
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name_for_pro
      assert bkan_pro.price                               == 22
      assert data                                         == %{}
    end

    test "return match_book_keeping_additional_need when price is nil by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: nil, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == nil
      assert data                                         == %{}
    end

    test "return match_book_keeping_additional_need when price is 0 by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 0, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 0
      assert data                                         == %{}
    end

    test "return match_book_keeping_additional_need when price is 1 by role Tp" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 1, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_tp.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 1
      assert data                                         == %{bk_pro.id => 20}
    end

    test "return match_book_keeping_additional_need by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_tp.id => match.match_for_book_keeping_additional_need}
    end

    test "return match_book_keeping_additional_need when more one pro by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      bk_tp1 = insert(:tp_book_keeping, user: tp1)
      bk_tp2 = insert(:tp_book_keeping, user: tp2)
      bk_tp3 = insert(:tp_book_keeping, user: tp3)
      bkan_tp1 = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp1)
      bkan_tp2 = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp2)
      bkan_tp3 = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp3)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:pro_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert bkan_pro.price                               == 22
      assert bkan_tp1.price                               == nil
      assert bkan_tp2.price                               == nil
      assert bkan_tp3.price                               == nil
      assert format_name(bkan_pro.name)                   == name
      assert format_name(bkan_tp1.name)                   == name
      assert format_name(bkan_tp2.name)                   == name
      assert format_name(bkan_tp3.name)                   == name
      assert data                                         == %{
        bk_tp1.id => match.match_for_book_keeping_additional_need,
        bk_tp2.id => match.match_for_book_keeping_additional_need,
        bk_tp3.id => match.match_for_book_keeping_additional_need
      }
    end

    test "return match_book_keeping_additional_need when match is 0 by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat, match_for_book_keeping_additional_need: 0)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 0
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_tp.id => match.match_for_book_keeping_additional_need}
    end

    test "return match_book_keeping_additional_need when match is nil by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat, match_for_book_keeping_additional_need: nil)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == nil
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_tp.id => 0}
    end

    test "return match_book_keeping_additional_need when match is 1 by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat, match_for_book_keeping_additional_need: 1)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 1
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 22
      assert data                                         == %{bk_tp.id => 1}
    end

    test "return match_book_keeping_additional_need when name is nil by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: nil, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert bkan_pro.name                                == nil
      assert bkan_pro.price                               == 22
      assert data                                         == :error
    end

    test "return match_book_keeping_additional_need when name is another one by role Pro" do
      name_for_tp = "sales tax"
      name_for_pro = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name_for_tp, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name_for_pro, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name_for_tp
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name_for_pro
      assert bkan_pro.price                               == 22
      assert data                                         == %{}
    end

    test "return match_book_keeping_additional_need when price is nil by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: nil, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == nil
      assert data                                         == :error
    end

    test "return match_book_keeping_additional_need when price is 0 by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 0, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 0
      assert data                                         == :error
    end

    test "return match_book_keeping_additional_need when price is 1 by role Pro" do
      name = "accounts payable"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkan_tp = insert(:tp_book_keeping_additional_need, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkan_pro = insert(:pro_book_keeping_additional_need, name: name, price: 1, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_additional_need(bk_pro.id)
      assert match.match_for_book_keeping_additional_need == 20
      assert format_name(bkan_tp.name)                    == name
      assert bkan_tp.price                                == nil
      assert format_name(bkan_pro.name)                   == name
      assert bkan_pro.price                               == 1
      assert data                                         == %{bk_tp.id => 20}
    end

    test "return match_book_keeping_annual_revenue by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_pro.id => match.match_for_book_keeping_annual_revenue}
    end

    test "return match_book_keeping_annual_revenue when more one pro by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      bk_pro1 = insert(:pro_book_keeping, user: pro1)
      bk_pro2 = insert(:pro_book_keeping, user: pro2)
      bk_pro3 = insert(:pro_book_keeping, user: pro3)
      bkar_pro1 = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro1)
      bkar_pro2 = insert(:pro_book_keeping_annual_revenue, name: name, price: 33, book_keepings: bk_pro2)
      bkar_pro3 = insert(:pro_book_keeping_annual_revenue, name: name, price: 44, book_keepings: bk_pro3)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue == 25
      assert format_name(bkar_tp.name)                   == name
      assert bkar_tp.price                               == nil
      assert format_name(bkar_pro1.name)                 == name
      assert format_name(bkar_pro2.name)                 == name
      assert format_name(bkar_pro3.name)                 == name
      assert bkar_pro1.price                             == 22
      assert bkar_pro2.price                             == 33
      assert bkar_pro3.price                             == 44
      assert data                                        == %{
        bk_pro1.id => match.match_for_book_keeping_annual_revenue,
        bk_pro2.id => match.match_for_book_keeping_annual_revenue,
        bk_pro3.id => match.match_for_book_keeping_annual_revenue
      }
    end

    test "return match_book_keeping_annual_revenue iwhen match is 0 by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat, match_for_book_keeping_annual_revenue: 0)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 0
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_pro.id => match.match_for_book_keeping_annual_revenue}
    end

    test "return match_book_keeping_annual_revenue iwhen match is nil by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat, match_for_book_keeping_annual_revenue: nil)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == nil
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_pro.id => 0}
    end

    test "return match_book_keeping_annual_revenue iwhen match is 1 by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat, match_for_book_keeping_annual_revenue: 1)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 1
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_pro.id => 1}
    end

    test "return match_book_keeping_annual_revenue when name is nil by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: nil, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert bkar_tp.name                                 == nil
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == :error
    end

    test "return match_book_keeping_annual_revenue when name is another one by role Tp" do
      name_for_tp = "$500K - $1M"
      name_for_pro = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name_for_tp, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name_for_pro, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name_for_tp
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name_for_pro
      assert bkar_pro.price                               == 22
      assert data                                         == %{}
    end

    test "return match_book_keeping_annual_revenue when price is nil by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: nil, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == nil
      assert data                                         == %{}
    end

    test "return match_book_keeping_annual_revenue when price is 0 by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 0, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 0
      assert data                                         == %{}
    end

    test "return match_book_keeping_annual_revenue when price is 1 by role Tp" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 1, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_tp.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 1
      assert data                                         == %{bk_pro.id => 25}
    end

    test "return match_book_keeping_annual_revenue by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_tp.id => match.match_for_book_keeping_annual_revenue}
    end

    test "return match_book_keeping_annual_revenue when more one pro by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      bk_tp1 = insert(:tp_book_keeping, user: tp1)
      bk_tp2 = insert(:tp_book_keeping, user: tp2)
      bk_tp3 = insert(:tp_book_keeping, user: tp3)
      bkar_tp1 = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp1)
      bkar_tp2 = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp2)
      bkar_tp3 = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp3)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:pro_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue == 25
      assert format_name(bkar_tp1.name)                  == name
      assert format_name(bkar_tp2.name)                  == name
      assert format_name(bkar_tp3.name)                  == name
      assert bkar_tp1.price                              == nil
      assert bkar_tp2.price                              == nil
      assert bkar_tp3.price                              == nil
      assert format_name(bkar_pro.name)                  == name
      assert bkar_pro.price                              == 22
      assert data                                        == %{
        bk_tp1.id => match.match_for_book_keeping_annual_revenue,
        bk_tp2.id => match.match_for_book_keeping_annual_revenue,
        bk_tp3.id => match.match_for_book_keeping_annual_revenue
      }
    end

    test "return match_book_keeping_annual_revenue iwhen match is 0 by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat, match_for_book_keeping_annual_revenue: 0)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 0
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_tp.id => match.match_for_book_keeping_annual_revenue}
    end

    test "return match_book_keeping_annual_revenue iwhen match is nil by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat, match_for_book_keeping_annual_revenue: nil)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == nil
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_tp.id => 0}
    end

    test "return match_book_keeping_annual_revenue iwhen match is 1 by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat, match_for_book_keeping_annual_revenue: 1)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 1
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{bk_tp.id => 1}
    end

    test "return match_book_keeping_annual_revenue when name is nil by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: nil, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert bkar_tp.name                                 == nil
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 22
      assert data                                         == %{}
    end

    test "return match_book_keeping_annual_revenue when name is another one by role Pro" do
      name_for_tp = "$500K - $1M"
      name_for_pro = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name_for_tp, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name_for_pro, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name_for_tp
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name_for_pro
      assert bkar_pro.price                               == 22
      assert data                                         == %{}
    end

    test "return match_book_keeping_annual_revenue when price is nil by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: nil, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == nil
      assert data                                         == :error
    end

    test "return match_book_keeping_annual_revenue when price is 0 by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 0, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 0
      assert data                                         == :error
    end

    test "return match_book_keeping_annual_revenue when price is 1 by role Pro" do
      name = "$5M - $10M"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkar_tp = insert(:tp_book_keeping_annual_revenue, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkar_pro = insert(:pro_book_keeping_annual_revenue, name: name, price: 1, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_annual_revenue(bk_pro.id)
      assert match.match_for_book_keeping_annual_revenue  == 25
      assert format_name(bkar_tp.name)                    == name
      assert bkar_tp.price                                == nil
      assert format_name(bkar_pro.name)                   == name
      assert bkar_pro.price                               == 1
      assert data                                         == %{bk_tp.id => 25}
    end

    test "return match_book_keeping_industry by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bki_tp = insert(:tp_book_keeping_industry, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bki_pro = insert(:pro_book_keeping_industry, name: names, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_industry(bk_tp.id)
      assert match.match_for_book_keeping_industry == 10
      assert format_names(bki_tp.name)             == name
      assert format_names(bki_pro.name)            == names
      assert data                                  == %{bk_pro.id => match.match_for_book_keeping_industry}
    end

    test "return match_book_keeping_industry when more one pro by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bki_tp = insert(:tp_book_keeping_industry, name: name, book_keepings: bk_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      bk_pro1 = insert(:pro_book_keeping, user: pro1)
      bk_pro2 = insert(:pro_book_keeping, user: pro2)
      bk_pro3 = insert(:pro_book_keeping, user: pro3)
      bki_pro1 = insert(:pro_book_keeping_industry, name: names, book_keepings: bk_pro1)
      bki_pro2 = insert(:pro_book_keeping_industry, name: names, book_keepings: bk_pro2)
      bki_pro3 = insert(:pro_book_keeping_industry, name: names, book_keepings: bk_pro3)
      data = BookKeeping.check_match_book_keeping_industry(bk_tp.id)
      assert match.match_for_book_keeping_industry == 10
      assert format_names(bki_tp.name)             == name
      assert format_names(bki_pro1.name)           == names
      assert format_names(bki_pro2.name)           == names
      assert format_names(bki_pro3.name)           == names
      assert data                                  == %{
        bk_pro1.id => match.match_for_book_keeping_industry,
        bk_pro2.id => match.match_for_book_keeping_industry,
        bk_pro3.id => match.match_for_book_keeping_industry
      }
    end

    test "return match_book_keeping_industry by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bki_tp = insert(:tp_book_keeping_industry, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bki_pro = insert(:pro_book_keeping_industry, name: names, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_industry(bk_pro.id)
      assert match.match_for_book_keeping_industry == 10
      assert format_names(bki_tp.name)             == name
      assert format_names(bki_pro.name)            == names
      assert data                                  == %{bk_tp.id => match.match_for_book_keeping_industry}
    end

    test "return match_book_keeping_industry when more one pro by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      match = insert(:match_value_relat)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      bk_tp1 = insert(:tp_book_keeping, user: tp1)
      bk_tp2 = insert(:tp_book_keeping, user: tp2)
      bk_tp3 = insert(:tp_book_keeping, user: tp3)
      bki_tp1 = insert(:tp_book_keeping_industry, name: name, book_keepings: bk_tp1)
      bki_tp2 = insert(:tp_book_keeping_industry, name: name, book_keepings: bk_tp2)
      bki_tp3 = insert(:tp_book_keeping_industry, name: name, book_keepings: bk_tp3)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:pro_book_keeping, user: pro)
      bki_pro = insert(:pro_book_keeping_industry, name: names, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_industry(bk_pro.id)
      assert match.match_for_book_keeping_industry == 10
      assert format_names(bki_tp1.name)            == name
      assert format_names(bki_tp2.name)            == name
      assert format_names(bki_tp3.name)            == name
      assert format_names(bki_pro.name)            == names
      assert data                                  == %{
        bk_tp1.id => match.match_for_book_keeping_industry,
        bk_tp2.id => match.match_for_book_keeping_industry,
        bk_tp3.id => match.match_for_book_keeping_industry
      }
    end

    test "return match_book_keeping_number_employee by role Tp" do
      name = "1 employee"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkne_tp = insert(:tp_book_keeping_number_employee, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkne_pro = insert(:pro_book_keeping_number_employee, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_number_employee(bk_tp.id)
      assert match.match_for_book_keeping_number_employee == 25
      assert format_name(bkne_tp.name)                    == name
      assert bkne_tp.price                                == nil
      assert format_name(bkne_pro.name)                   == name
      assert bkne_pro.price                               == 22
      assert data                                         == %{bk_pro.id => match.match_for_book_keeping_number_employee}
    end

    test "return match_book_keeping_number_employee when more one pro by role Tp" do
      name = "1 employee"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkne_tp = insert(:tp_book_keeping_number_employee, name: name, book_keepings: bk_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      bk_pro1 = insert(:pro_book_keeping, user: pro1)
      bk_pro2 = insert(:pro_book_keeping, user: pro2)
      bk_pro3 = insert(:pro_book_keeping, user: pro3)
      bkne_pro1 = insert(:pro_book_keeping_number_employee, name: name, price: 22, book_keepings: bk_pro1)
      bkne_pro2 = insert(:pro_book_keeping_number_employee, name: name, price: 33, book_keepings: bk_pro2)
      bkne_pro3 = insert(:pro_book_keeping_number_employee, name: name, price: 44, book_keepings: bk_pro3)
      data = BookKeeping.check_match_book_keeping_number_employee(bk_tp.id)
      assert match.match_for_book_keeping_number_employee == 25
      assert format_name(bkne_tp.name)                    == name
      assert bkne_tp.price                                == nil
      assert format_name(bkne_pro1.name)                  == name
      assert format_name(bkne_pro2.name)                  == name
      assert format_name(bkne_pro3.name)                  == name
      assert bkne_pro1.price                              == 22
      assert bkne_pro2.price                              == 33
      assert bkne_pro3.price                              == 44
      assert data                                         == %{
        bk_pro1.id => match.match_for_book_keeping_number_employee,
        bk_pro2.id => match.match_for_book_keeping_number_employee,
        bk_pro3.id => match.match_for_book_keeping_number_employee
      }
    end

    test "return match_book_keeping_number_employee by role Pro" do
      name = "1 employee"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bkne_tp = insert(:tp_book_keeping_number_employee, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bkne_pro = insert(:pro_book_keeping_number_employee, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_number_employee(bk_pro.id)
      assert match.match_for_book_keeping_number_employee == 25
      assert format_name(bkne_tp.name)                    == name
      assert bkne_tp.price                                == nil
      assert format_name(bkne_pro.name)                   == name
      assert bkne_pro.price                               == 22
      assert data                                         == %{bk_tp.id => match.match_for_book_keeping_number_employee}
    end

    test "return match_book_keeping_number_employee when more one pro by role Pro" do
      name = "1 employee"
      match = insert(:match_value_relat)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      bk_tp1 = insert(:tp_book_keeping, user: tp1)
      bk_tp2 = insert(:tp_book_keeping, user: tp2)
      bk_tp3 = insert(:tp_book_keeping, user: tp3)
      bkne_tp1 = insert(:tp_book_keeping_number_employee, name: name, book_keepings: bk_tp1)
      bkne_tp2 = insert(:tp_book_keeping_number_employee, name: name, book_keepings: bk_tp2)
      bkne_tp3 = insert(:tp_book_keeping_number_employee, name: name, book_keepings: bk_tp3)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:pro_book_keeping, user: pro)
      bkne_pro = insert(:pro_book_keeping_number_employee, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_number_employee(bk_pro.id)
      assert match.match_for_book_keeping_number_employee == 25
      assert bkne_pro.price                               == 22
      assert bkne_tp1.price                               == nil
      assert bkne_tp2.price                               == nil
      assert bkne_tp3.price                               == nil
      assert format_name(bkne_pro.name)                   == name
      assert format_name(bkne_tp1.name)                   == name
      assert format_name(bkne_tp2.name)                   == name
      assert format_name(bkne_tp3.name)                   == name
      assert data                                         == %{
        bk_tp1.id => match.match_for_book_keeping_number_employee,
        bk_tp2.id => match.match_for_book_keeping_number_employee,
        bk_tp3.id => match.match_for_book_keeping_number_employee
      }
    end

    test "return match_book_keeping_type_client by role Tp" do
      name = "Partnership"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bktc_tp = insert(:tp_book_keeping_type_client, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bktc_pro = insert(:pro_book_keeping_type_client, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_type_client(bk_tp.id)
      assert match.match_for_book_keeping_type_client == 60
      assert format_name(bktc_tp.name)                == name
      assert bktc_tp.price                            == nil
      assert format_name(bktc_pro.name)               == name
      assert bktc_pro.price                           == 22
      assert data                                     == %{bk_pro.id => match.match_for_book_keeping_type_client}
    end

    test "return match_book_keeping_type_client when more one pro by role Tp" do
      name = "Partnership"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bktc_tp = insert(:tp_book_keeping_type_client, name: name, book_keepings: bk_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      bk_pro1 = insert(:pro_book_keeping, user: pro1)
      bk_pro2 = insert(:pro_book_keeping, user: pro2)
      bk_pro3 = insert(:pro_book_keeping, user: pro3)
      bktc_pro1 = insert(:pro_book_keeping_type_client, name: name, price: 22, book_keepings: bk_pro1)
      bktc_pro2 = insert(:pro_book_keeping_type_client, name: name, price: 33, book_keepings: bk_pro2)
      bktc_pro3 = insert(:pro_book_keeping_type_client, name: name, price: 44, book_keepings: bk_pro3)
      data = BookKeeping.check_match_book_keeping_type_client(bk_tp.id)
      assert match.match_for_book_keeping_type_client == 60
      assert format_name(bktc_tp.name)                == name
      assert bktc_tp.price                            == nil
      assert format_name(bktc_pro1.name)              == name
      assert format_name(bktc_pro2.name)              == name
      assert format_name(bktc_pro3.name)              == name
      assert bktc_pro1.price                          == 22
      assert bktc_pro2.price                          == 33
      assert bktc_pro3.price                          == 44
      assert data                                     == %{
        bk_pro1.id => match.match_for_book_keeping_type_client,
        bk_pro2.id => match.match_for_book_keeping_type_client,
        bk_pro3.id => match.match_for_book_keeping_type_client
      }
    end

    test "return match_book_keeping_type_client by role Pro" do
      name = "Partnership"
      match = insert(:match_value_relat)
      tp = insert(:tp_user, languages: [])
      bk_tp = insert(:tp_book_keeping, user: tp)
      bktc_tp = insert(:tp_book_keeping_type_client, name: name, book_keepings: bk_tp)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:tp_book_keeping, user: pro)
      bktc_pro = insert(:pro_book_keeping_type_client, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_type_client(bk_pro.id)
      assert match.match_for_book_keeping_type_client == 60
      assert format_name(bktc_tp.name)                == name
      assert bktc_tp.price                            == nil
      assert format_name(bktc_pro.name)               == name
      assert bktc_pro.price                           == 22
      assert data                                     == %{bk_tp.id => match.match_for_book_keeping_type_client}
    end

    test "return match_book_keeping_type_client when more one pro by role Pro" do
      name = "Partnership"
      match = insert(:match_value_relat)
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      bk_tp1 = insert(:tp_book_keeping, user: tp1)
      bk_tp2 = insert(:tp_book_keeping, user: tp2)
      bk_tp3 = insert(:tp_book_keeping, user: tp3)
      bktc_tp1 = insert(:tp_book_keeping_type_client, name: name, book_keepings: bk_tp1)
      bktc_tp2 = insert(:tp_book_keeping_type_client, name: name, book_keepings: bk_tp2)
      bktc_tp3 = insert(:tp_book_keeping_type_client, name: name, book_keepings: bk_tp3)
      pro = insert(:pro_user, languages: [])
      bk_pro = insert(:pro_book_keeping, user: pro)
      bktc_pro = insert(:pro_book_keeping_type_client, name: name, price: 22, book_keepings: bk_pro)
      data = BookKeeping.check_match_book_keeping_type_client(bk_pro.id)
      assert match.match_for_book_keeping_type_client == 60
      assert bktc_pro.price                           == 22
      assert bktc_tp1.price                           == nil
      assert bktc_tp2.price                           == nil
      assert bktc_tp3.price                           == nil
      assert format_name(bktc_pro.name)               == name
      assert format_name(bktc_tp1.name)               == name
      assert format_name(bktc_tp2.name)               == name
      assert format_name(bktc_tp3.name)               == name
      assert data                                     == %{
        bk_tp1.id => match.match_for_book_keeping_type_client,
        bk_tp2.id => match.match_for_book_keeping_type_client,
        bk_tp3.id => match.match_for_book_keeping_type_client
      }
    end
  end

  describe "#check_price" do
    test "check_price_payroll" do
    end

    test "check_price_book_keeping_additional_need" do
    end

    test "check_price_book_keeping_annual_revenue" do
    end

    test "check_price_book_keeping_number_employee" do
    end

    test "check_price_book_keeping_transaction_volume" do
    end

    test "check_price_book_keeping_type_client" do
    end
  end

  describe "#check_value" do
    test "check_value_payroll" do
    end

    test "check_value_tax_year" do
    end

    test "check_value_book_keeping_additional_need" do
    end

    test "check_value_book_keeping_annual_revenue" do
    end

    test "check_value_book_keeping_number_employee" do
    end

    test "check_value_book_keeping_transaction_volume" do
    end

    test "check_value_book_keeping_type_client" do
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
