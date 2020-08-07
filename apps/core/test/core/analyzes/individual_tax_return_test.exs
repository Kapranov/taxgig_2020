defmodule Core.Analyzes.IndividualTaxReturnTest do
  use Core.DataCase

  alias Core.{
    Analyzes,
    Analyzes.IndividualTaxReturn
  }

  alias Decimal, as: D

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
      assert data                                       == %{
        itr_pro1.id => match.match_for_individual_foreign_account,
        itr_pro2.id => match.match_for_individual_foreign_account,
        itr_pro3.id => match.match_for_individual_foreign_account
      }
    end

    test "return match_foreign_account when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_foreign_account: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == 0
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_pro.id => match.match_for_individual_foreign_account}
    end

    test "return match_foreign_account when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_individual_foreign_account: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == nil
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_pro.id => 0}
    end

    test "return match_foreign_account when is false by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == false
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == :error
    end

    test "return match_foreign_account when is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == nil
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == :error
    end

    test "return match_foreign_account when price is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: nil, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == nil
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{}
    end

    test "return match_foreign_account when price is 0 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 0, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 0
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{}
    end

    test "return match_foreign_account when price is 1 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 1, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_tp.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 1
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_pro.id => match.match_for_individual_foreign_account}
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

    test "return match_foreign_account when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_foreign_account: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)

      assert match.match_for_individual_foreign_account == 0
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_tp.id => match.match_for_individual_foreign_account}
    end

    test "return match_foreign_account when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_individual_foreign_account: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)

      assert match.match_for_individual_foreign_account == nil
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_tp.id => 0}
    end

    test "return match_foreign_account when is false by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: false, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == false
      assert itr_pro.price_foreign_account              == 22
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == :error
    end

    test "return match_foreign_account when price is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: nil, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == nil
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == :error
    end

    test "return match_foreign_account when price is 0 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 0, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 0
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == :error
    end

    test "return match_foreign_account when price is 1 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 1, user: pro)

      data = IndividualTaxReturn.check_match_foreign_account(itr_pro.id)

      assert match.match_for_individual_foreign_account == 20
      assert itr_pro.foreign_account                    == true
      assert itr_pro.price_foreign_account              == 1
      assert itr_tp.foreign_account                     == true
      assert itr_tp.price_foreign_account               == nil
      assert data                                       == %{itr_tp.id => match.match_for_individual_foreign_account}
    end

    test "return match_home_owner by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_pro.id => match.match_for_individual_home_owner}
    end

    test "return match_home_owner when more one pro by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 44, user: pro3)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert itr_pro1.home_owner                   == true
      assert itr_pro2.home_owner                   == true
      assert itr_pro3.home_owner                   == true
      assert itr_pro1.price_home_owner             == 22
      assert itr_pro2.price_home_owner             == 33
      assert itr_pro3.price_home_owner             == 44
      assert data                                  == %{
        itr_pro1.id => match.match_for_individual_home_owner,
        itr_pro2.id => match.match_for_individual_home_owner,
        itr_pro3.id => match.match_for_individual_home_owner
      }
    end

    test "return match_home_owner when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_home_owner: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 0
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_pro.id => match.match_for_individual_home_owner}
    end

    test "return match_home_owner when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_individual_home_owner: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == nil
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_pro.id => 0}
    end

    test "return match_home_owner when match is 1 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_home_owner: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 1
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_pro.id => match.match_for_individual_home_owner}
    end

    test "return match_home_owner when is false by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == false
      assert itr_tp.price_home_owner               == nil
      assert data                                  == :error
    end

    test "return match_home_owner when is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == nil
      assert itr_tp.price_home_owner               == nil
      assert data                                  == :error
    end

    test "return match_home_owner when price is 0 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 0, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 0
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{}
    end

    test "return match_home_owner when price is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: nil, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == nil
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{}
    end

    test "return match_home_owner when price is 1 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 1, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 1
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_pro.id => match.match_for_individual_home_owner}
    end

    test "return match_home_owner by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_tp.id => match.match_for_individual_home_owner}
    end

    test "return match_home_owner when more one tp by role Pro" do
      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, home_owner: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, home_owner: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, home_owner: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_tp1.home_owner                    == true
      assert itr_tp2.home_owner                    == true
      assert itr_tp3.home_owner                    == true
      assert itr_tp1.price_home_owner              == nil
      assert itr_tp2.price_home_owner              == nil
      assert itr_tp3.price_home_owner              == nil
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert data                                  == %{
        itr_tp1.id => match.match_for_individual_home_owner,
        itr_tp2.id => match.match_for_individual_home_owner,
        itr_tp3.id => match.match_for_individual_home_owner
      }
    end

    test "return match_home_owner when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_home_owner: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 0
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_tp.id => match.match_for_individual_home_owner}
    end

    test "return match_home_owner when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_individual_home_owner: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == nil
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_tp.id => 0}
    end

    test "return match_home_owner when match is 1 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_home_owner: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 1
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_tp.id => match.match_for_individual_home_owner}
    end

    test "return match_home_owner when is false by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: false, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == false
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == :error
    end

    test "return match_home_owner when is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: nil, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == nil
      assert itr_pro.price_home_owner              == 22
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == :error
    end

    test "return match_home_owner when price is 0 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 0, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 0
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == :error
    end

    test "return match_home_owner when price is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: nil, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_pro.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == nil
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == :error
    end

    test "return match_home_owner when price is 1 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 1, user: pro)

      data = IndividualTaxReturn.check_match_home_owner(itr_tp.id)

      assert match.match_for_individual_home_owner == 20
      assert itr_pro.home_owner                    == true
      assert itr_pro.price_home_owner              == 1
      assert itr_tp.home_owner                     == true
      assert itr_tp.price_home_owner               == nil
      assert data                                  == %{itr_pro.id => match.match_for_individual_home_owner}
    end

    test "return match_individual_employment_status by role Tp" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_pro.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_employment_status when more one pro by role Tp" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, user: pro3)
      ies_pro1 = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro1)
      ies_pro2 = insert(:pro_individual_employment_status, name: name, price: 33, individual_tax_returns: itr_pro2)
      ies_pro3 = insert(:pro_individual_employment_status, name: name, price: 44, individual_tax_returns: itr_pro3)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status  == 35
      assert format_name(ies_pro1.name)                    == name
      assert format_name(ies_pro2.name)                    == name
      assert format_name(ies_pro3.name)                    == name
      assert ies_pro1.price                                == 22
      assert ies_pro2.price                                == 33
      assert ies_pro3.price                                == 44
      assert format_name(ies_tp.name)                      == name
      assert ies_tp.price                                  == nil
      assert data                                          == %{
        itr_pro1.id => match.match_for_individual_employment_status,
        itr_pro2.id => match.match_for_individual_employment_status,
        itr_pro3.id => match.match_for_individual_employment_status
      }
    end

    test "return match_individual_employment_status when match is 0 by role Tp" do
      name = "employed"

      match = insert(:match_value_relat, match_for_individual_employment_status: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 0
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_pro.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_employment_status when match is nil by role Tp" do
      name = "employed"

      match = insert(:match_value_relat, match_for_individual_employment_status: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == nil
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_pro.id => 0}
    end

    test "return match_individual_employment_status when match is 1 by role Tp" do
      name = "employed"

      match = insert(:match_value_relat, match_for_individual_employment_status: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 1
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_pro.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_employment_status when is nil by role Tp" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: nil, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == nil
      assert ies_tp.price                                 == nil
      assert data                                         == :error
    end

    test "return match_individual_employment_status when price is nil by role Tp" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == nil
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{}
    end

    test "return match_individual_employment_status when price is 0 by role Tp" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 0
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{}
    end

    test "return match_individual_employment_status when price is 1 by role Tp" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 1
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_pro.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_employment_status by role Pro" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_tp.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_employment_status when more one tp by role Pro" do
      name = "employed"

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, user: tp3)
      ies_tp1 = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp1)
      ies_tp2 = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp2)
      ies_tp3 = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp1.name)                    == name
      assert format_name(ies_tp2.name)                    == name
      assert format_name(ies_tp3.name)                    == name
      assert ies_tp1.price                                == nil
      assert ies_tp2.price                                == nil
      assert ies_tp3.price                                == nil
      assert data                                         == %{
        itr_tp1.id => match.match_for_individual_employment_status,
        itr_tp2.id => match.match_for_individual_employment_status,
        itr_tp3.id => match.match_for_individual_employment_status
      }
    end

    test "return match_individual_employment_status when match is 0 by role Pro" do
      name = "employed"

      match = insert(:match_value_relat, match_for_individual_employment_status: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == 0
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_tp.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_employment_status when match is nil by role Pro" do
      name = "employed"

      match = insert(:match_value_relat, match_for_individual_employment_status: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == nil
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_tp.id => 0}
    end

    test "return match_individual_employment_status when match is 1 by role Pro" do
      name = "employed"

      match = insert(:match_value_relat, match_for_individual_employment_status: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == 1
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_tp.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_employment_status when is nil by role Pro" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: nil, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == nil
      assert ies_pro.price                                == 22
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == :error
    end

    test "return match_individual_employment_status when price is nil by role Pro" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == nil
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == :error
    end

    test "return match_individual_employment_status when price is 0 by role Pro" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_pro.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 0
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == :error
    end

    test "return match_individual_employment_status when price is 1 by role Pro" do
      name = "employed"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_employment_status(itr_tp.id)

      assert match.match_for_individual_employment_status == 35
      assert format_name(ies_pro.name)                    == name
      assert ies_pro.price                                == 1
      assert format_name(ies_tp.name)                     == name
      assert ies_tp.price                                 == nil
      assert data                                         == %{itr_pro.id => match.match_for_individual_employment_status}
    end

    test "return match_individual_filing_status by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_filing_status when more one pro by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, user: pro3)
      ifs_pro1 = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro1)
      ifs_pro2 = insert(:pro_individual_filing_status, name: name, price: 33, individual_tax_returns: itr_pro2)
      ifs_pro3 = insert(:pro_individual_filing_status, name: name, price: 44, individual_tax_returns: itr_pro3)

      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)

      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro1.name)               == name
      assert format_name(ifs_pro2.name)               == name
      assert format_name(ifs_pro3.name)               == name
      assert ifs_pro1.price                           == 22
      assert ifs_pro2.price                           == 33
      assert ifs_pro3.price                           == 44
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{
        itr_pro1.id => match.match_for_individual_filing_status,
        itr_pro2.id => match.match_for_individual_filing_status,
        itr_pro3.id => match.match_for_individual_filing_status
      }
    end

    test "return match_individual_filing_status when match is 0 by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat, match_for_individual_filing_status: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == 0
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_filing_status when match is nil by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat, match_for_individual_filing_status: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == nil
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_pro.id => 0}
    end

    test "return match_individual_filing_status when match is 1 by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat, match_for_individual_filing_status: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == 1
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_filing_status when is nil by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: nil, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == nil
      assert ifs_tp.price                             == nil
      assert data                                     == :error
    end

    test "return match_individual_filing_status when price is nil by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: nil, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == nil
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{}
    end

    test "return match_individual_filing_status when price is 0 by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 0, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 0
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{}
    end

    test "return match_individual_filing_status when price is 1 by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 1, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_tp.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 1
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_filing_status by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_filing_status when more one tp by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, user: tp3)
      ifs_tp1 = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp1)
      ifs_tp2 = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp2)
      ifs_tp3 = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)

      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp1.name)                == name
      assert format_name(ifs_tp2.name)                == name
      assert format_name(ifs_tp3.name)                == name
      assert ifs_tp1.price                            == nil
      assert ifs_tp2.price                            == nil
      assert ifs_tp3.price                            == nil
      assert data                                     == %{
        itr_tp1.id => match.match_for_individual_filing_status,
        itr_tp2.id => match.match_for_individual_filing_status,
        itr_tp3.id => match.match_for_individual_filing_status
      }
    end

    test "return match_individual_filing_status when match is 0 by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat, match_for_individual_filing_status: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == 0
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_filing_status when match is nil by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat, match_for_individual_filing_status: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == nil
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_tp.id => 0}
    end

    test "return match_individual_filing_status when match is 1 by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat, match_for_individual_filing_status: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == 1
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_filing_status when is nil by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: nil, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == nil
      assert ifs_pro.price                            == 22
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == :error
    end

    test "return match_individual_filing_status when price is nil by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: nil, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == nil
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == :error
    end

    test "return match_individual_filing_status when price is 0 by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 0, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 0
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == :error
    end

    test "return match_individual_filing_status when price is 1 by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 1, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_filing_status(itr_pro.id)
      assert match.match_for_individual_filing_status == 50
      assert format_name(ifs_pro.name)                == name
      assert ifs_pro.price                            == 1
      assert format_name(ifs_tp.name)                 == name
      assert ifs_tp.price                             == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_filing_status}
    end

    test "return match_individual_industry by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_tp.id)
      assert match.match_for_individual_industry == 10
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_pro.id => match.match_for_individual_industry}
    end

    test "return match_individual_industry when more one pro by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, user: pro3)
      ii_pro1 = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro1)
      ii_pro2 = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro2)
      ii_pro3 = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro3)

      data = IndividualTaxReturn.check_match_individual_industry(itr_tp.id)

      assert match.match_for_individual_industry == 10
      assert format_names(ii_pro1.name)          == names
      assert format_names(ii_pro2.name)          == names
      assert format_names(ii_pro3.name)          == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{
        itr_pro1.id => match.match_for_individual_industry,
        itr_pro2.id => match.match_for_individual_industry,
        itr_pro3.id => match.match_for_individual_industry
      }
    end

    test "return match_individual_industry when match is 0 by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_individual_industry: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_tp.id)
      assert match.match_for_individual_industry == 0
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_pro.id => match.match_for_individual_industry}
    end

    test "return match_individual_industry when match is nil by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_individual_industry: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_tp.id)
      assert match.match_for_individual_industry == nil
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_pro.id => 0}
    end

    test "return match_individual_industry when match is 1 by role Tp" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_individual_industry: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_tp.id)
      assert match.match_for_individual_industry == 1
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_pro.id => match.match_for_individual_industry}
    end

    test "return match_individual_industry name is nil by role Tp" do
      name = Enum.sort([])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_tp.id)
      assert match.match_for_individual_industry == 10
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{}
    end

    test "return match_individual_industry by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_pro.id)
      assert match.match_for_individual_industry == 10
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_tp.id => match.match_for_individual_industry}
    end

    test "return match_individual_industry when more one tp by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, user: tp3)
      ii_tp1 = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp1)
      ii_tp2 = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp2)
      ii_tp3 = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_industry(itr_pro.id)

      assert match.match_for_individual_industry == 10
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp1.name)           == name
      assert format_names(ii_tp2.name)           == name
      assert format_names(ii_tp3.name)           == name
      assert data                                == %{
        itr_tp1.id => match.match_for_individual_industry,
        itr_tp2.id => match.match_for_individual_industry,
        itr_tp3.id => match.match_for_individual_industry
      }
    end

    test "return match_individual_industry when match is 0 by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_individual_industry: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_pro.id)
      assert match.match_for_individual_industry == 0
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_tp.id => match.match_for_individual_industry}
    end

    test "return match_individual_industry when match is nil by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_individual_industry: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_pro.id)
      assert match.match_for_individual_industry == nil
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_tp.id => 0}
    end

    test "return match_individual_industry when match is 1 by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])

      match = insert(:match_value_relat, match_for_individual_industry: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_pro.id)
      assert match.match_for_individual_industry == 1
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{itr_tp.id => match.match_for_individual_industry}
    end

    test "return match_individual_industry name is nil by role Pro" do
      name = Enum.sort(["Hospitality"])
      names = Enum.sort([])

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ii_tp = insert(:tp_individual_industry, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ii_pro = insert(:pro_individual_industry, name: names, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_industry(itr_pro.id)
      assert match.match_for_individual_industry == 10
      assert format_names(ii_pro.name)           == names
      assert format_names(ii_tp.name)            == name
      assert data                                == %{}
    end

    test "return match_individual_itemized_deduction by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_individual_itemized_deduction when more one pro by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, user: pro3)
      iid_pro1 = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro1)
      iid_pro2 = insert(:pro_individual_itemized_deduction, name: name, price: 33, individual_tax_returns: itr_pro2)
      iid_pro3 = insert(:pro_individual_itemized_deduction, name: name, price: 44, individual_tax_returns: itr_pro3)

      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)

      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro1.name)                    == name
      assert format_name(iid_pro2.name)                    == name
      assert format_name(iid_pro3.name)                    == name
      assert iid_pro1.price                                == 22
      assert iid_pro2.price                                == 33
      assert iid_pro3.price                                == 44
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{
        itr_pro1.id => match.match_for_individual_itemized_deduction,
        itr_pro2.id => match.match_for_individual_itemized_deduction,
        itr_pro3.id => match.match_for_individual_itemized_deduction
      }
    end

    test "return match_individual_itemized_deduction when match is 0 by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat, match_for_individual_itemized_deduction: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == 0
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_individual_itemized_deduction when match is nil by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat, match_for_individual_itemized_deduction: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == nil
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_pro.id => 0}
    end

    test "return match_individual_itemized_deduction when match is 1 by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat, match_for_individual_itemized_deduction: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == 1
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_individual_itemized_deduction when is nil by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: nil, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == nil
      assert iid_tp.price                                  == nil
      assert data                                          == :error
    end

    test "return match_individual_itemized_deduction when price is 0 by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 0, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 0
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{}
    end

    test "return match_individual_itemized_deduction when price is nil by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: nil, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == nil
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{}
    end

    test "return match_individual_itemized_deduction when price is 1 by role Tp" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 1, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_tp.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 1
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_individual_itemized_deduction by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_individual_itemized_deduction when more one tp by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, user: tp3)
      iid_tp1 = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp1)
      iid_tp2 = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp2)
      iid_tp3 = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)

      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp1.name)                     == name
      assert format_name(iid_tp2.name)                     == name
      assert format_name(iid_tp3.name)                     == name
      assert iid_tp1.price                                 == nil
      assert iid_tp2.price                                 == nil
      assert iid_tp3.price                                 == nil
      assert data                                          == %{
        itr_tp1.id => match.match_for_individual_itemized_deduction,
        itr_tp2.id => match.match_for_individual_itemized_deduction,
        itr_tp3.id => match.match_for_individual_itemized_deduction
      }
    end

    test "return match_individual_itemized_deduction when match is 0 by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat, match_for_individual_itemized_deduction: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == 0
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_individual_itemized_deduction when match is nil by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat, match_for_individual_itemized_deduction: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == nil
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_tp.id => 0}
    end

    test "return match_individual_itemized_deduction when match is 1 by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat, match_for_individual_itemized_deduction: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == 1
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_individual_itemized_deduction when is nil by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: nil, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == nil
      assert iid_pro.price                                 == 22
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == :error
    end

    test "return match_individual_itemized_deduction when price is 0 by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 0, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 0
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == :error
    end

    test "return match_individual_itemized_deduction when price is nil by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: nil, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == nil
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == :error
    end

    test "return match_individual_itemized_deduction when price is 1 by role Pro" do
      name = "Charitable contributions"

      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 1, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_match_individual_itemized_deduction(itr_pro.id)
      assert match.match_for_individual_itemized_deduction == 20
      assert format_name(iid_pro.name)                     == name
      assert iid_pro.price                                 == 1
      assert format_name(iid_tp.name)                      == name
      assert iid_tp.price                                  == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_itemized_deduction}
    end

    test "return match_living_abroad by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_living_abroad}
    end

    test "return match_living_abroad when more one pro by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 44, user: pro3)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert itr_pro1.living_abroad                   == true
      assert itr_pro2.living_abroad                   == true
      assert itr_pro3.living_abroad                   == true
      assert itr_pro1.price_living_abroad             == 22
      assert itr_pro2.price_living_abroad             == 33
      assert itr_pro3.price_living_abroad             == 44
      assert data                                     == %{
        itr_pro1.id => match.match_for_individual_living_abroad,
        itr_pro2.id => match.match_for_individual_living_abroad,
        itr_pro3.id => match.match_for_individual_living_abroad
      }
    end

    test "return match_living_abroad when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_living_abroad: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 0
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_living_abroad}
    end

    test "return match_living_abroad when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_individual_living_abroad: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == nil
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_pro.id => 0}
    end

    test "return match_living_abroad when match is 1 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_living_abroad: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 1
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_living_abroad}
    end

    test "return match_living_abroad when is false by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == false
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == :error
    end

    test "return match_living_abroad when price is 0 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 0, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 0
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{}
    end

    test "return match_living_abroad when price is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: nil, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == nil
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{}
    end

    test "return match_living_abroad when price is 1 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 1, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_tp.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 1
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_pro.id => match.match_for_individual_living_abroad}
    end

    test "return match_living_abroad by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_living_abroad}
    end

    test "return match_living_abroad when more one tp by role Pro" do
      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, living_abroad: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, living_abroad: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, living_abroad: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_tp1.living_abroad                    == true
      assert itr_tp2.living_abroad                    == true
      assert itr_tp3.living_abroad                    == true
      assert itr_tp1.price_living_abroad              == nil
      assert itr_tp2.price_living_abroad              == nil
      assert itr_tp3.price_living_abroad              == nil
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert data                                     == %{
        itr_tp1.id => match.match_for_individual_living_abroad,
        itr_tp2.id => match.match_for_individual_living_abroad,
        itr_tp3.id => match.match_for_individual_living_abroad
      }
    end

    test "return match_living_abroad when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_living_abroad: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 0
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_living_abroad}
    end

    test "return match_living_abroad when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_individual_living_abroad: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == nil
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_tp.id => 0}
    end

    test "return match_living_abroad when match is 1 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_living_abroad: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 1
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_living_abroad}
    end

    test "return match_living_abroad when is false by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: false, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == false
      assert itr_pro.price_living_abroad              == 22
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == :error
    end

    test "return match_living_abroad when price is 0 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 0, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 0
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == :error
    end

    test "return match_living_abroad when price is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: nil, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == nil
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == :error
    end

    test "return match_living_abroad when price is 1 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 1, user: pro)

      data = IndividualTaxReturn.check_match_living_abroad(itr_pro.id)

      assert match.match_for_individual_living_abroad == 20
      assert itr_pro.living_abroad                    == true
      assert itr_pro.price_living_abroad              == 1
      assert itr_tp.living_abroad                     == true
      assert itr_tp.price_living_abroad               == nil
      assert data                                     == %{itr_tp.id => match.match_for_individual_living_abroad}
    end

    test "return match_non_resident_earning by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_pro.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_non_resident_earning when more one pro by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 44, user: pro3)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert itr_pro1.non_resident_earning                   == true
      assert itr_pro2.non_resident_earning                   == true
      assert itr_pro3.non_resident_earning                   == true
      assert itr_pro1.price_non_resident_earning             == 22
      assert itr_pro2.price_non_resident_earning             == 33
      assert itr_pro3.price_non_resident_earning             == 44
      assert data                                            == %{
        itr_pro1.id => match.match_for_individual_non_resident_earning,
        itr_pro2.id => match.match_for_individual_non_resident_earning,
        itr_pro3.id => match.match_for_individual_non_resident_earning
      }
    end

    test "return match_non_resident_earning when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_non_resident_earning: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 0
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_pro.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_non_resident_earning when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_individual_non_resident_earning: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == nil
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_pro.id => 0}
    end

    test "return match_non_resident_earning when match is 1 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_non_resident_earning: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 1
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_pro.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_non_resident_earning when is false by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == false
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == :error
    end

    test "return match_non_resident_earning when price is 0 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 0, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 0
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{}
    end

    test "return match_non_resident_earning when price is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: nil, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == nil
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{}
    end

    test "return match_non_resident_earning when price is 1 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 1, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_tp.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 1
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_pro.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_non_resident_earning by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_tp.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_non_resident_earning when more one tp by role Pro" do
      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_tp1.non_resident_earning                    == true
      assert itr_tp2.non_resident_earning                    == true
      assert itr_tp3.non_resident_earning                    == true
      assert itr_tp1.price_non_resident_earning              == nil
      assert itr_tp2.price_non_resident_earning              == nil
      assert itr_tp3.price_non_resident_earning              == nil
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert data                                            == %{
        itr_tp1.id => match.match_for_individual_non_resident_earning,
        itr_tp2.id => match.match_for_individual_non_resident_earning,
        itr_tp3.id => match.match_for_individual_non_resident_earning
      }
    end

    test "return match_non_resident_earning when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_non_resident_earning: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 0
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_tp.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_non_resident_earning when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_individual_non_resident_earning: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == nil
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_tp.id => 0}
    end

    test "return match_non_resident_earning when match is 1 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_non_resident_earning: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 1
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_tp.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_non_resident_earning when is false by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: false, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == false
      assert itr_pro.price_non_resident_earning              == 22
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == :error
    end

    test "return match_non_resident_earning when price is 0 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 0, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 0
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == :error
    end

    test "return match_non_resident_earning when price is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: nil, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == nil
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == :error
    end

    test "return match_non_resident_earning when price is 1 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 1, user: pro)

      data = IndividualTaxReturn.check_match_non_resident_earning(itr_pro.id)

      assert match.match_for_individual_non_resident_earning == 20
      assert itr_pro.non_resident_earning                    == true
      assert itr_pro.price_non_resident_earning              == 1
      assert itr_tp.non_resident_earning                     == true
      assert itr_tp.price_non_resident_earning               == nil
      assert data                                            == %{itr_tp.id => match.match_for_individual_non_resident_earning}
    end

    test "return match_own_stock_crypto by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_pro.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_own_stock_crypto when more one pro by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 44, user: pro3)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert itr_pro1.own_stock_crypto                   == true
      assert itr_pro2.own_stock_crypto                   == true
      assert itr_pro3.own_stock_crypto                   == true
      assert itr_pro1.price_own_stock_crypto             == 22
      assert itr_pro2.price_own_stock_crypto             == 33
      assert itr_pro3.price_own_stock_crypto             == 44
      assert data                                        == %{
        itr_pro1.id => match.match_for_individual_own_stock_crypto,
        itr_pro2.id => match.match_for_individual_own_stock_crypto,
        itr_pro3.id => match.match_for_individual_own_stock_crypto
      }
    end

    test "return match_own_stock_crypto when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_own_stock_crypto: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 0
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_pro.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_own_stock_crypto when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_individual_own_stock_crypto: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == nil
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_pro.id => 0}
    end

    test "return match_own_stock_crypto when match is 1 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_own_stock_crypto: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 1
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_pro.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_own_stock_crypto when is false by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == false
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == :error
    end

    test "return match_own_stock_crypto when price is 0 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 0, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 0
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{}
    end

    test "return match_own_stock_crypto when price is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: nil, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == nil
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{}
    end

    test "return match_own_stock_crypto when price is 1 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 1, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_tp.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 1
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_pro.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_own_stock_crypto by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_tp.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_own_stock_crypto when more one tp by role Pro" do
      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_tp1.own_stock_crypto                    == true
      assert itr_tp2.own_stock_crypto                    == true
      assert itr_tp3.own_stock_crypto                    == true
      assert itr_tp1.price_own_stock_crypto              == nil
      assert itr_tp2.price_own_stock_crypto              == nil
      assert itr_tp3.price_own_stock_crypto              == nil
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert data                                        == %{
        itr_tp1.id => match.match_for_individual_own_stock_crypto,
        itr_tp2.id => match.match_for_individual_own_stock_crypto,
        itr_tp3.id => match.match_for_individual_own_stock_crypto
      }
    end

    test "return match_own_stock_crypto when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_own_stock_crypto: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 0
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_tp.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_own_stock_crypto when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_individual_own_stock_crypto: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == nil
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_tp.id => 0}
    end

    test "return match_own_stock_crypto when match is 1 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_own_stock_crypto: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 1
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_tp.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_own_stock_crypto when is false by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: false, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == false
      assert itr_pro.price_own_stock_crypto              == 22
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == :error
    end

    test "return match_own_stock_crypto when price is 0 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 0, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 0
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == :error
    end

    test "return match_own_stock_crypto when price is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: nil, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == nil
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == :error
    end

    test "return match_own_stock_crypto when price is 1 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 1, user: pro)

      data = IndividualTaxReturn.check_match_own_stock_crypto(itr_pro.id)

      assert match.match_for_individual_own_stock_crypto == 20
      assert itr_pro.own_stock_crypto                    == true
      assert itr_pro.price_own_stock_crypto              == 1
      assert itr_tp.own_stock_crypto                     == true
      assert itr_tp.price_own_stock_crypto               == nil
      assert data                                        == %{itr_tp.id => match.match_for_individual_own_stock_crypto}
    end

    test "return match_rental_property_income by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_rental_property_income when more one pro by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 44, user: pro3)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert itr_pro1.rental_property_income               == true
      assert itr_pro2.rental_property_income               == true
      assert itr_pro3.rental_property_income               == true
      assert itr_pro1.price_rental_property_income         == 22
      assert itr_pro2.price_rental_property_income         == 33
      assert itr_pro3.price_rental_property_income         == 44
      assert data                                          == %{
        itr_pro1.id => match.match_for_individual_rental_prop_income,
        itr_pro2.id => match.match_for_individual_rental_prop_income,
        itr_pro3.id => match.match_for_individual_rental_prop_income
      }
    end

    test "return match_rental_property_income when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_rental_prop_income: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 0
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_rental_property_income when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_individual_rental_prop_income: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == nil
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_pro.id => 0}
    end

    test "return match_rental_property_income when match is 1 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_rental_prop_income: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 1
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_rental_property_income when is false by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == false
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == :error
    end

    test "return match_rental_property_income when price is 0 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 0, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 0
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{}
    end

    test "return match_rental_property_income when price is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: nil, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == nil
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{}
    end

    test "return match_rental_property_income when price is 1 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 1, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_tp.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 1
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_pro.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_rental_property_income by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_rental_property_income when more one tp by role Pro" do
      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, rental_property_income: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, rental_property_income: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, rental_property_income: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_tp1.rental_property_income                == true
      assert itr_tp2.rental_property_income                == true
      assert itr_tp3.rental_property_income                == true
      assert itr_tp1.price_rental_property_income          == nil
      assert itr_tp2.price_rental_property_income          == nil
      assert itr_tp3.price_rental_property_income          == nil
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert data                                          == %{
        itr_tp1.id => match.match_for_individual_rental_prop_income,
        itr_tp2.id => match.match_for_individual_rental_prop_income,
        itr_tp3.id => match.match_for_individual_rental_prop_income
      }
    end

    test "return match_rental_property_income when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_rental_prop_income: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 0
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_rental_property_income when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_individual_rental_prop_income: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == nil
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_tp.id => 0}
    end

    test "return match_rental_property_income when match is 1 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_rental_prop_income: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 1
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_rental_property_income when is false by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: false, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == false
      assert itr_pro.price_rental_property_income          == 22
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == :error
    end

    test "return match_rental_property_income when price is 0 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 0, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 0
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == :error
    end

    test "return match_rental_property_income when price is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: nil, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == nil
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == :error
    end

    test "return match_rental_property_income when price is 1 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 1, user: pro)

      data = IndividualTaxReturn.check_match_rental_property_income(itr_pro.id)

      assert match.match_for_individual_rental_prop_income == 20
      assert itr_pro.rental_property_income                == true
      assert itr_pro.price_rental_property_income          == 1
      assert itr_tp.rental_property_income                 == true
      assert itr_tp.price_rental_property_income           == nil
      assert data                                          == %{itr_tp.id => match.match_for_individual_rental_prop_income}
    end

    test "return match_stock_divident by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_pro.id => match.match_for_individual_stock_divident}
    end

    test "return match_stock_divident when more one pro by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 44, user: pro3)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert itr_pro1.stock_divident                   == true
      assert itr_pro2.stock_divident                   == true
      assert itr_pro3.stock_divident                   == true
      assert itr_pro1.price_stock_divident             == 22
      assert itr_pro2.price_stock_divident             == 33
      assert itr_pro3.price_stock_divident             == 44
      assert data                                      == %{
        itr_pro1.id => match.match_for_individual_stock_divident,
        itr_pro2.id => match.match_for_individual_stock_divident,
        itr_pro3.id => match.match_for_individual_stock_divident
      }
    end

    test "return match_stock_divident when match is 0 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_stock_divident: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 0
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_pro.id => match.match_for_individual_stock_divident}
    end

    test "return match_stock_divident when match is nil by role Tp" do
      match = insert(:match_value_relat, match_for_individual_stock_divident: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == nil
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_pro.id => 0}
    end

    test "return match_stock_divident when match is 1 by role Tp" do
      match = insert(:match_value_relat, match_for_individual_stock_divident: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 1
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_pro.id => match.match_for_individual_stock_divident}
    end

    test "return match_stock_divident when is false by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == false
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == :error
    end

    test "return match_stock_divident when price is 0 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 0, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 0
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{}
    end

    test "return match_stock_divident when price is nil by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: nil, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == nil
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{}
    end

    test "return match_stock_divident when price is 1 by role Tp" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 1, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_tp.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 1
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_pro.id => match.match_for_individual_stock_divident}
    end

    test "return match_stock_divident by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_tp.id => match.match_for_individual_stock_divident}
    end

    test "return match_stock_divident when more one tp by role Pro" do
      match = insert(:match_value_relat)

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, stock_divident: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, stock_divident: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, stock_divident: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_tp1.stock_divident                    == true
      assert itr_tp2.stock_divident                    == true
      assert itr_tp3.stock_divident                    == true
      assert itr_tp1.price_stock_divident              == nil
      assert itr_tp2.price_stock_divident              == nil
      assert itr_tp3.price_stock_divident              == nil
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert data                                          == %{
        itr_tp1.id => match.match_for_individual_stock_divident,
        itr_tp2.id => match.match_for_individual_stock_divident,
        itr_tp3.id => match.match_for_individual_stock_divident
      }
    end

    test "return match_stock_divident when match is 0 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_stock_divident: 0)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 0
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_tp.id => match.match_for_individual_stock_divident}
    end

    test "return match_stock_divident when match is nil by role Pro" do
      match = insert(:match_value_relat, match_for_individual_stock_divident: nil)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == nil
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_tp.id => 0}
    end

    test "return match_stock_divident when match is 1 by role Pro" do
      match = insert(:match_value_relat, match_for_individual_stock_divident: 1)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 1
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_tp.id => match.match_for_individual_stock_divident}
    end

    test "return match_stock_divident when is false by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: false, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == false
      assert itr_pro.price_stock_divident              == 22
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == :error
    end

    test "return match_stock_divident when price is 0 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 0, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 0
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == :error
    end

    test "return match_stock_divident when price is nil by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: nil, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == nil
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == :error
    end

    test "return match_stock_divident when price is 1 by role Pro" do
      match = insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 1, user: pro)

      data = IndividualTaxReturn.check_match_stock_divident(itr_pro.id)

      assert match.match_for_individual_stock_divident == 20
      assert itr_pro.stock_divident                    == true
      assert itr_pro.price_stock_divident              == 1
      assert itr_tp.stock_divident                     == true
      assert itr_tp.price_stock_divident               == nil
      assert data                                      == %{itr_tp.id => match.match_for_individual_stock_divident}
    end
  end

  describe "#check_price" do
    test "return price_foreign_account by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_tp.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 22
      assert data                          == %{itr_pro.id => 22}
    end

    test "return price_foreign_account when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 44, user: pro3)

      data = IndividualTaxReturn.check_price_foreign_account(itr_tp.id)

      assert itr_tp.foreign_account         == true
      assert itr_tp.price_foreign_account   == nil
      assert itr_pro1.foreign_account       == true
      assert itr_pro2.foreign_account       == true
      assert itr_pro3.foreign_account       == true
      assert itr_pro1.price_foreign_account == 22
      assert itr_pro2.price_foreign_account == 33
      assert itr_pro3.price_foreign_account == 44
      assert data                           == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_foreign_account when is false by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_tp.id)

      assert itr_tp.foreign_account        == false
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 22
      assert data                          == :error
    end

    test "return price_foreign_account when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 0, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_tp.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 0
      assert data                          == %{}
    end

    test "return price_foreign_account when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: nil, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_tp.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == nil
      assert data                          == %{}
    end

    test "return price_foreign_account when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 1, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_tp.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 1
      assert data                          == %{itr_pro.id => 1}
    end

    test "return price_foreign_account by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_pro.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 22
      assert data                          == %{itr_tp.id => 22}
    end

    test "return price_foreign_account when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, foreign_account: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, foreign_account: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, foreign_account: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_pro.id)

      assert itr_tp1.foreign_account       == true
      assert itr_tp2.foreign_account       == true
      assert itr_tp3.foreign_account       == true
      assert itr_tp1.price_foreign_account == nil
      assert itr_tp2.price_foreign_account == nil
      assert itr_tp3.price_foreign_account == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 22
      assert data                          == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_foreign_account when is false by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: false, price_foreign_account: 22, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_pro.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == false
      assert itr_pro.price_foreign_account == 22
      assert data                          == :error
    end

    test "return price_foreign_account when price is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 0, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_pro.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 0
      assert data                          == :error
    end

    test "return price_foreign_account when price is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: nil, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_pro.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == nil
      assert data                          == :error
    end

    test "return price_foreign_account when price is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, foreign_account: true, price_foreign_account: 1, user: pro)

      data = IndividualTaxReturn.check_price_foreign_account(itr_pro.id)

      assert itr_tp.foreign_account        == true
      assert itr_tp.price_foreign_account  == nil
      assert itr_pro.foreign_account       == true
      assert itr_pro.price_foreign_account == 1
      assert data                          == %{itr_tp.id => 1}
    end

    test "return price_home_owner by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_tp.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 22
      assert data                     == %{itr_pro.id => 22}
    end

    test "return price_home_owner when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 44, user: pro3)

      data = IndividualTaxReturn.check_price_home_owner(itr_tp.id)

      assert itr_tp.home_owner         == true
      assert itr_tp.price_home_owner   == nil
      assert itr_pro1.home_owner       == true
      assert itr_pro2.home_owner       == true
      assert itr_pro3.home_owner       == true
      assert itr_pro1.price_home_owner == 22
      assert itr_pro2.price_home_owner == 33
      assert itr_pro3.price_home_owner == 44
      assert data                      == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_home_owner when is false by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_tp.id)

      assert itr_tp.home_owner        == false
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 22
      assert data                     == :error
    end

    test "return price_home_owner when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 0, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_tp.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 0
      assert data                     == %{}
    end

    test "return price_home_owner when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: nil, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_tp.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == nil
      assert data                     == %{}
    end

    test "return price_home_owner when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 1, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_tp.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 1
      assert data                     == %{itr_pro.id => 1}
    end

    test "return price_home_owner by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_pro.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 22
      assert data                     == %{itr_tp.id => 22}
    end

    test "return price_home_owner when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, home_owner: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, home_owner: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, home_owner: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_pro.id)

      assert itr_tp1.home_owner       == true
      assert itr_tp2.home_owner       == true
      assert itr_tp3.home_owner       == true
      assert itr_tp1.price_home_owner == nil
      assert itr_tp2.price_home_owner == nil
      assert itr_tp3.price_home_owner == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 22
      assert data                     == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_home_owner when is false by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: false, price_home_owner: 22, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_pro.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == false
      assert itr_pro.price_home_owner == 22
      assert data                     == :error
    end

    test "return price_home_owner when price is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 0, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_pro.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 0
      assert data                     == :error
    end

    test "return price_home_owner when price is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: nil, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_pro.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == nil
      assert data                     == :error
    end

    test "return price_home_owner when price is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, home_owner: true, price_home_owner: 1, user: pro)

      data = IndividualTaxReturn.check_price_home_owner(itr_pro.id)

      assert itr_tp.home_owner        == true
      assert itr_tp.price_home_owner  == nil
      assert itr_pro.home_owner       == true
      assert itr_pro.price_home_owner == 1
      assert data                     == %{itr_tp.id => 1}
    end

    test "return price_individual_employment_status by role Tp" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_tp.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 22
      assert data                      == %{itr_pro.id => 22}
    end

    test "return price_individual_employment_status when more one pro by role Tp" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, user: pro3)
      ies_pro1 = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro1)
      ies_pro2 = insert(:pro_individual_employment_status, name: name, price: 33, individual_tax_returns: itr_pro2)
      ies_pro3 = insert(:pro_individual_employment_status, name: name, price: 44, individual_tax_returns: itr_pro3)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_tp.id)

      assert format_name(ies_tp.name)   == name
      assert ies_tp.price               == nil
      assert format_name(ies_pro1.name) == name
      assert format_name(ies_pro2.name) == name
      assert format_name(ies_pro3.name) == name
      assert ies_pro1.price             == 22
      assert ies_pro2.price             == 33
      assert ies_pro3.price             == 44
      assert data                       == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_individual_employment_status when is nil by role Tp" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: nil, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_tp.id)

      assert format_name(ies_tp.name)  == nil
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 22
      assert data                      == :error
    end

    test "return price_individual_employment_status when price is 0 by role Tp" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_tp.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 0
      assert data                      == %{}
    end

    test "return price_individual_employment_status when price is nil by role Tp" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_tp.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == nil
      assert data                      == %{}
    end

    test "return price_individual_employment_status when price is 1 by role Tp" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_tp.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 1
      assert data                      == %{itr_pro.id => 1}
    end

    test "return price_individual_employment_status by role Pro" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_pro.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 22
      assert data                      == %{itr_tp.id => 22}
    end

    test "return price_individual_employment_status when more one tp by role Pro" do
      name = "unemployed"

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, user: tp3)
      ies_tp1 = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp1)
      ies_tp2 = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp2)
      ies_tp3 = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_pro.id)

      assert format_name(ies_tp1.name) == name
      assert format_name(ies_tp2.name) == name
      assert format_name(ies_tp3.name) == name
      assert ies_tp1.price             == nil
      assert ies_tp2.price             == nil
      assert ies_tp3.price             == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 22
      assert data                      == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_individual_employment_status when is nil by role Pro" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: nil, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_pro.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == nil
      assert ies_pro.price             == 22
      assert data                      == :error
    end

    test "return price_individual_employment_status when price is 0 by role Pro" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_pro.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 0
      assert data                      == :error
    end

    test "return price_individual_employment_status when price is nil by role Pro" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_pro.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == nil
      assert data                      == :error
    end

    test "return price_individual_employment_status when price is 1 by role Pro" do
      name = "unemployed"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:pro_individual_employment_status, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_employment_status(itr_pro.id)

      assert format_name(ies_tp.name)  == name
      assert ies_tp.price              == nil
      assert format_name(ies_pro.name) == name
      assert ies_pro.price             == 1
      assert data                      == %{itr_tp.id => 1}
    end

    test "return price_individual_filing_status by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_tp.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 22
      assert data                      == %{itr_pro.id => 22}
    end

    test "return price_individual_filing_status when more one pro by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, user: pro3)
      ifs_pro1 = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro1)
      ifs_pro2 = insert(:pro_individual_filing_status, name: name, price: 33, individual_tax_returns: itr_pro2)
      ifs_pro3 = insert(:pro_individual_filing_status, name: name, price: 44, individual_tax_returns: itr_pro3)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_tp.id)

      assert format_name(ifs_tp.name)   == name
      assert ifs_tp.price               == nil
      assert format_name(ifs_pro1.name) == name
      assert format_name(ifs_pro2.name) == name
      assert format_name(ifs_pro3.name) == name
      assert ifs_pro1.price             == 22
      assert ifs_pro2.price             == 33
      assert ifs_pro3.price             == 44
      assert data                       == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_individual_filing_status when is nil by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: nil, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_tp.id)

      assert format_name(ifs_tp.name)  == nil
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 22
      assert data                      == :error
    end

    test "return price_individual_filing_status when price is 0 by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_tp.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 0
      assert data                      == %{}
    end

    test "return price_individual_filing_status when price is nil by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_tp.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == nil
      assert data                      == %{}
    end

    test "return price_individual_filing_status when price is 1 by role Tp" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_tp.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 1
      assert data                      == %{itr_pro.id => 1}
    end

    test "return price_individual_filing_status by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_pro.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 22
      assert data                      == %{itr_tp.id => 22}
    end

    test "return price_individual_filing_status when more one tp by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, user: tp3)
      ifs_tp1 = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp1)
      ifs_tp2 = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp2)
      ifs_tp3 = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_pro.id)

      assert format_name(ifs_tp1.name) == name
      assert format_name(ifs_tp2.name) == name
      assert format_name(ifs_tp3.name) == name
      assert ifs_tp1.price             == nil
      assert ifs_tp2.price             == nil
      assert ifs_tp3.price             == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 22
      assert data                      == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_individual_filing_status when is nil by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: nil, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_pro.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == nil
      assert ifs_pro.price             == 22
      assert data                      == :error
    end

    test "return price_individual_filing_status when price is 0 by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_pro.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 0
      assert data                      == :error
    end

    test "return price_individual_filing_status when price is nil by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_pro.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == nil
      assert data                      == :error
    end

    test "return price_individual_filing_status when price is 1 by role Pro" do
      name = "Qualifying widow(-er) with dependent child"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:pro_individual_filing_status, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_filing_status(itr_pro.id)

      assert format_name(ifs_tp.name)  == name
      assert ifs_tp.price              == nil
      assert format_name(ifs_pro.name) == name
      assert ifs_pro.price             == 1
      assert data                      == %{itr_tp.id => 1}
    end

    test "return price_individual_itemized_deduction by role Tp" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_tp.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 22
      assert data                      == %{itr_pro.id => 22}
    end

    test "return price_individual_itemized_deduction when more one pro by role Tp" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, user: pro3)
      iid_pro1 = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro1)
      iid_pro2 = insert(:pro_individual_itemized_deduction, name: name, price: 33, individual_tax_returns: itr_pro2)
      iid_pro3 = insert(:pro_individual_itemized_deduction, name: name, price: 44, individual_tax_returns: itr_pro3)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_tp.id)

      assert format_name(iid_tp.name)   == name
      assert iid_tp.price               == nil
      assert format_name(iid_pro1.name) == name
      assert format_name(iid_pro2.name) == name
      assert format_name(iid_pro3.name) == name
      assert iid_pro1.price             == 22
      assert iid_pro2.price             == 33
      assert iid_pro3.price             == 44
      assert data                       == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_individual_itemized_deduction when is nil by role Tp" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: nil, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_tp.id)

      assert format_name(iid_tp.name)  == nil
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 22
      assert data                      == :error
    end

    test "return price_individual_itemized_deduction when price is 0 by role Tp" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_tp.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 0
      assert data                      == %{}
    end

    test "return price_individual_itemized_deduction when price is nil by role Tp" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_tp.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == nil
      assert data                      == %{}
    end

    test "return price_individual_itemized_deduction when price is 1 by role Tp" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_tp.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 1
      assert data                      == %{itr_pro.id => 1}
    end

    test "return price_individual_itemized_deduction by role Pro" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_pro.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 22
      assert data                      == %{itr_tp.id => 22}
    end

    test "return price_individual_itemized_deduction when more one tp by role Pro" do
      name = "Charitable contributions"

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, user: tp3)
      iid_tp1 = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp1)
      iid_tp2 = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp2)
      iid_tp3 = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_pro.id)

      assert format_name(iid_tp1.name) == name
      assert format_name(iid_tp2.name) == name
      assert format_name(iid_tp3.name) == name
      assert iid_tp1.price             == nil
      assert iid_tp2.price             == nil
      assert iid_tp3.price             == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 22
      assert data                      == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_individual_itemized_deduction when is nil by role Pro" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: nil, price: 22, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_pro.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == nil
      assert iid_pro.price             == 22
      assert data                      == :error
    end

    test "return price_individual_itemized_deduction when price is 0 by role Pro" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 0, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_pro.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 0
      assert data                      == :error
    end

    test "return price_individual_itemized_deduction when price is nil by role Pro" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: nil, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_pro.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == nil
      assert data                      == :error
    end

    test "return price_individual_itemized_deduction when price is 1 by role Pro" do
      name = "Charitable contributions"

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      iid_tp = insert(:tp_individual_itemized_deduction, name: name, individual_tax_returns: itr_tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      iid_pro = insert(:pro_individual_itemized_deduction, name: name, price: 1, individual_tax_returns: itr_pro)

      data = IndividualTaxReturn.check_price_individual_itemized_deduction(itr_pro.id)

      assert format_name(iid_tp.name)  == name
      assert iid_tp.price              == nil
      assert format_name(iid_pro.name) == name
      assert iid_pro.price             == 1
      assert data                      == %{itr_tp.id => 1}
    end

    test "return price_living_abroad by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_tp.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 22
      assert data                        == %{itr_pro.id => 22}
    end

    test "return price_living_abroad when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 44, user: pro3)

      data = IndividualTaxReturn.check_price_living_abroad(itr_tp.id)

      assert itr_tp.living_abroad         == true
      assert itr_tp.price_living_abroad   == nil
      assert itr_pro1.living_abroad       == true
      assert itr_pro2.living_abroad       == true
      assert itr_pro3.living_abroad       == true
      assert itr_pro1.price_living_abroad == 22
      assert itr_pro2.price_living_abroad == 33
      assert itr_pro3.price_living_abroad == 44
      assert data                         == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_living_abroad when is false by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_tp.id)

      assert itr_tp.living_abroad        == false
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 22
      assert data                        == :error
    end

    test "return price_living_abroad when is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_tp.id)

      assert itr_tp.living_abroad        == nil
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 22
      assert data                        == :error
    end

    test "return price_living_abroad when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 0, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_tp.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 0
      assert data                        == %{}
    end

    test "return price_living_abroad when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: nil, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_tp.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == nil
      assert data                        == %{}
    end

    test "return price_living_abroad when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 1, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_tp.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 1
      assert data                        == %{itr_pro.id => 1}
    end

    test "return price_living_abroad by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_pro.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 22
      assert data                        == %{itr_tp.id => 22}
    end

    test "return price_living_abroad when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, living_abroad: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, living_abroad: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, living_abroad: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_pro.id)

      assert itr_tp1.living_abroad       == true
      assert itr_tp2.living_abroad       == true
      assert itr_tp3.living_abroad       == true
      assert itr_tp1.price_living_abroad == nil
      assert itr_tp2.price_living_abroad == nil
      assert itr_tp3.price_living_abroad == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 22
      assert data                        == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_living_abroad when is false by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: false, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_pro.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == false
      assert itr_pro.price_living_abroad == 22
      assert data                        == :error
    end

    test "return price_living_abroad when is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: nil, price_living_abroad: 22, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_pro.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == nil
      assert itr_pro.price_living_abroad == 22
      assert data                        == :error
    end

    test "return price_living_abroad when price is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 0, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_pro.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 0
      assert data                        == :error
    end

    test "return price_living_abroad when price is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: nil, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_pro.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == nil
      assert data                        == :error
    end

    test "return price_living_abroad when price is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, living_abroad: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, living_abroad: true, price_living_abroad: 1, user: pro)

      data = IndividualTaxReturn.check_price_living_abroad(itr_pro.id)

      assert itr_tp.living_abroad        == true
      assert itr_tp.price_living_abroad  == nil
      assert itr_pro.living_abroad       == true
      assert itr_pro.price_living_abroad == 1
      assert data                        == %{itr_tp.id => 1}
    end

    test "return price_non_resident_earning by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_tp.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 22
      assert data                               == %{itr_pro.id => 22}
    end

    test "return price_non_resident_earning when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 44, user: pro3)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_tp.id)

      assert itr_tp.non_resident_earning         == true
      assert itr_tp.price_non_resident_earning   == nil
      assert itr_pro1.non_resident_earning       == true
      assert itr_pro2.non_resident_earning       == true
      assert itr_pro3.non_resident_earning       == true
      assert itr_pro1.price_non_resident_earning == 22
      assert itr_pro2.price_non_resident_earning == 33
      assert itr_pro3.price_non_resident_earning == 44
      assert data                                == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_non_resident_earning when is false by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_tp.id)

      assert itr_tp.non_resident_earning        == false
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 22
      assert data                               == :error
    end

    test "return price_non_resident_earning when is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_tp.id)

      assert itr_tp.non_resident_earning        == nil
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 22
      assert data                               == :error
    end

    test "return price_non_resident_earning when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 0, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_tp.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 0
      assert data                               == %{}
    end

    test "return price_non_resident_earning when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: nil, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_tp.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == nil
      assert data                               == %{}
    end

    test "return price_non_resident_earning when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 1, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_tp.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 1
      assert data                               == %{itr_pro.id => 1}
    end

    test "return price_non_resident_earning by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_pro.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 22
      assert data                               == %{itr_tp.id => 22}
    end

    test "return price_non_resident_earning when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_pro.id)

      assert itr_tp1.non_resident_earning       == true
      assert itr_tp2.non_resident_earning       == true
      assert itr_tp3.non_resident_earning       == true
      assert itr_tp1.price_non_resident_earning == nil
      assert itr_tp2.price_non_resident_earning == nil
      assert itr_tp3.price_non_resident_earning == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 22
      assert data                               == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_non_resident_earning when is false by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: false, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_pro.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == false
      assert itr_pro.price_non_resident_earning == 22
      assert data                               == :error
    end

    test "return price_non_resident_earning when is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: nil, price_non_resident_earning: 22, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_pro.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == nil
      assert itr_pro.price_non_resident_earning == 22
      assert data                               == :error
    end

    test "return price_non_resident_earning when price is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 0, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_pro.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 0
      assert data                               == :error
    end

    test "return price_non_resident_earning when price is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: nil, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_pro.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == nil
      assert data                               == :error
    end

    test "return price_non_resident_earning when price is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, non_resident_earning: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, non_resident_earning: true, price_non_resident_earning: 1, user: pro)

      data = IndividualTaxReturn.check_price_non_resident_earning(itr_pro.id)

      assert itr_tp.non_resident_earning        == true
      assert itr_tp.price_non_resident_earning  == nil
      assert itr_pro.non_resident_earning       == true
      assert itr_pro.price_non_resident_earning == 1
      assert data                               == %{itr_tp.id => 1}
    end

    test "return price_own_stock_crypto by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_tp.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 22
      assert data                           == %{itr_pro.id => 22}
    end

    test "return price_own_stock_crypto when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 44, user: pro3)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_tp.id)

      assert itr_tp.own_stock_crypto         == true
      assert itr_tp.price_own_stock_crypto   == nil
      assert itr_pro1.own_stock_crypto       == true
      assert itr_pro2.own_stock_crypto       == true
      assert itr_pro3.own_stock_crypto       == true
      assert itr_pro1.price_own_stock_crypto == 22
      assert itr_pro2.price_own_stock_crypto == 33
      assert itr_pro3.price_own_stock_crypto == 44
      assert data                            == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_own_stock_crypto when is false by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_tp.id)

      assert itr_tp.own_stock_crypto        == false
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 22
      assert data                           == :error
    end

    test "return price_own_stock_crypto when is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_tp.id)

      assert itr_tp.own_stock_crypto        == nil
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 22
      assert data                           == :error
    end

    test "return price_own_stock_crypto when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 0, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_tp.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 0
      assert data                           == %{}
    end

    test "return price_own_stock_crypto when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: nil, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_tp.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == nil
      assert data                           == %{}
    end

    test "return price_own_stock_crypto when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 1, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_tp.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 1
      assert data                           == %{itr_pro.id => 1}
    end

    test "return price_own_stock_crypto by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_pro.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 22
      assert data                           == %{itr_tp.id => 22}
    end

    test "return price_own_stock_crypto when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_pro.id)

      assert itr_tp1.own_stock_crypto       == true
      assert itr_tp2.own_stock_crypto       == true
      assert itr_tp3.own_stock_crypto       == true
      assert itr_tp1.price_own_stock_crypto == nil
      assert itr_tp2.price_own_stock_crypto == nil
      assert itr_tp3.price_own_stock_crypto == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 22
      assert data                           == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_own_stock_crypto when is false by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: false, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_pro.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == false
      assert itr_pro.price_own_stock_crypto == 22
      assert data                           == :error
    end

    test "return price_own_stock_crypto when is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: nil, price_own_stock_crypto: 22, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_pro.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == nil
      assert itr_pro.price_own_stock_crypto == 22
      assert data                           == :error
    end

    test "return price_own_stock_crypto when price is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 0, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_pro.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 0
      assert data                           == :error
    end

    test "return price_own_stock_crypto when price is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: nil, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_pro.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == nil
      assert data                           == :error
    end

    test "return price_own_stock_crypto when price is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, own_stock_crypto: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, own_stock_crypto: true, price_own_stock_crypto: 1, user: pro)

      data = IndividualTaxReturn.check_price_own_stock_crypto(itr_pro.id)

      assert itr_tp.own_stock_crypto        == true
      assert itr_tp.price_own_stock_crypto  == nil
      assert itr_pro.own_stock_crypto       == true
      assert itr_pro.price_own_stock_crypto == 1
      assert data                           == %{itr_tp.id => 1}
    end

    test "return price_rental_property_income by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_tp.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 22
      assert data                                 == %{itr_pro.id => 22}
    end

    test "return price_rental_property_income when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 44, user: pro3)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_tp.id)

      assert itr_tp.rental_property_income         == true
      assert itr_tp.price_rental_property_income   == nil
      assert itr_pro1.rental_property_income       == true
      assert itr_pro2.rental_property_income       == true
      assert itr_pro3.rental_property_income       == true
      assert itr_pro1.price_rental_property_income == 22
      assert itr_pro2.price_rental_property_income == 33
      assert itr_pro3.price_rental_property_income == 44
      assert data                                  == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_rental_property_income when is false by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_tp.id)

      assert itr_tp.rental_property_income        == false
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 22
      assert data                                 == :error
    end

    test "return price_rental_property_income when is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_tp.id)

      assert itr_tp.rental_property_income        == nil
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 22
      assert data                                 == :error
    end

    test "return price_rental_property_income when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 0, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_tp.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 0
      assert data                                 == %{}
    end

    test "return price_rental_property_income when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: nil, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_tp.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == nil
      assert data                                 == %{}
    end

    test "return price_rental_property_income when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 1, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_tp.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 1
      assert data                                 == %{itr_pro.id => 1}
    end

    test "return price_rental_property_income by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_pro.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 22
      assert data                                 == %{itr_tp.id => 22}
    end

    test "return price_rental_property_income when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, rental_property_income: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, rental_property_income: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, rental_property_income: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_pro.id)

      assert itr_tp1.rental_property_income       == true
      assert itr_tp2.rental_property_income       == true
      assert itr_tp3.rental_property_income       == true
      assert itr_tp1.price_rental_property_income == nil
      assert itr_tp2.price_rental_property_income == nil
      assert itr_tp3.price_rental_property_income == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 22
      assert data                                 == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_rental_property_income when is false by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: false, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_pro.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == false
      assert itr_pro.price_rental_property_income == 22
      assert data                                 == :error
    end

    test "return price_rental_property_income when is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: nil, price_rental_property_income: 22, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_pro.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == nil
      assert itr_pro.price_rental_property_income == 22
      assert data                                 == :error
    end

    test "return price_rental_property_income when price is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 0, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_pro.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 0
      assert data                                 == :error
    end

    test "return price_rental_property_income when price is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: nil, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_pro.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == nil
      assert data                                 == :error
    end

    test "return price_rental_property_income when price is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, price_rental_property_income: 1, user: pro)

      data = IndividualTaxReturn.check_price_rental_property_income(itr_pro.id)

      assert itr_tp.rental_property_income        == true
      assert itr_tp.price_rental_property_income  == nil
      assert itr_pro.rental_property_income       == true
      assert itr_pro.price_rental_property_income == 1
      assert data                                 == %{itr_tp.id => 1}
    end

    test "return price_sole_proprietorship_count by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 22
      assert data                                    == %{itr_pro.id => 220}
    end

    test "return price_sole_proprietorship_count when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 44, user: pro3)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count         == 11
      assert itr_tp.price_sole_proprietorship_count   == nil
      assert itr_pro1.sole_proprietorship_count       == nil
      assert itr_pro2.sole_proprietorship_count       == nil
      assert itr_pro3.sole_proprietorship_count       == nil
      assert itr_pro1.price_sole_proprietorship_count == 22
      assert itr_pro2.price_sole_proprietorship_count == 33
      assert itr_pro3.price_sole_proprietorship_count == 44
      assert data                                     == %{
        itr_pro1.id => 220,
        itr_pro2.id => 330,
        itr_pro3.id => 440
      }
    end

    test "return price_sole_proprietorship_count when is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == nil
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 22
      assert data                                    == :error
    end

    test "return price_sole_proprietorship_count when is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 0, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 0
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 22
      assert data                                    == :error
    end

    test "return price_sole_proprietorship_count when is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 1, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 1
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 22
      assert data                                    == :error
    end

    test "return price_sole_proprietorship_count when is 2 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 2, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 2
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 22
      assert data                                    == %{itr_pro.id => 22}
    end

    test "return price_sole_proprietorship_count when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 0, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 0
      assert data                                    == %{}
    end

    test "return price_sole_proprietorship_count when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: nil, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == nil
      assert data                                    == %{}
    end

    test "return price_sole_proprietorship_count when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 1, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 1
      assert data                                    == %{}
    end

    test "return price_sole_proprietorship_count when price is 2 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 2, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_tp.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 2
      assert data                                    == %{itr_pro.id => 20}
    end

    test "return price_sole_proprietorship_count by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_pro.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 22
      assert data                                    == %{itr_tp.id => 220}
    end

    test "return price_sole_proprietorship_count when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, sole_proprietorship_count: 12, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, sole_proprietorship_count: 13, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 22, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_pro.id)

      assert itr_tp1.sole_proprietorship_count       == 11
      assert itr_tp2.sole_proprietorship_count       == 12
      assert itr_tp3.sole_proprietorship_count       == 13
      assert itr_tp1.price_sole_proprietorship_count == nil
      assert itr_tp2.price_sole_proprietorship_count == nil
      assert itr_tp3.price_sole_proprietorship_count == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 22
      assert data                                    == %{
        itr_tp1.id => 220,
        itr_tp2.id => 242,
        itr_tp3.id => 264
      }
    end

    test "return price_sole_proprietorship_count when is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: nil, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_pro.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == nil
      assert data                                    == :error
    end

    test "return price_sole_proprietorship_count when is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 0, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_pro.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 0
      assert data                                    == %{itr_tp.id => 0}
    end

    test "return price_sole_proprietorship_count when is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 1, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_pro.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 1
      assert data                                    == %{itr_tp.id => 10}
    end

    test "return price_sole_proprietorship_count when is 2 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_sole_proprietorship_count: 2, user: pro)

      data = IndividualTaxReturn.check_price_sole_proprietorship_count(itr_pro.id)

      assert itr_tp.sole_proprietorship_count        == 11
      assert itr_tp.price_sole_proprietorship_count  == nil
      assert itr_pro.sole_proprietorship_count       == nil
      assert itr_pro.price_sole_proprietorship_count == 2
      assert data                                    == %{itr_tp.id => 20}
    end

    test "return price_state by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 22, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 22
      assert data                        == %{itr_pro.id => 66}
    end

    test "return price_state when more one pro by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, price_state: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, price_state: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, price_state: 44, user: pro3)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)   == state
      assert itr_tp.price_state           == nil
      assert format_names(itr_pro1.state) == nil
      assert format_names(itr_pro2.state) == nil
      assert format_names(itr_pro3.state) == nil
      assert itr_pro1.price_state         == 22
      assert itr_pro2.price_state         == 33
      assert itr_pro3.price_state         == 44
      assert data                         == %{
        itr_pro1.id => 66,
        itr_pro2.id => 99,
        itr_pro3.id => 132
      }
    end

    test "return price_state when is nil by role Tp" do
      state = []

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 22, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 22
      assert data                        == %{itr_pro.id => 0}
    end

    test "return price_state when is 1 by role Tp" do
      state = ["Michigan", "Michigan", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 22, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 22
      assert data                        == %{itr_pro.id => 22}
    end

    test "return price_state when is 2 by role Tp" do
      state = ["Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 22, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 22
      assert data                        == %{itr_pro.id => 44}
    end

    test "return price_state when price is nil by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: nil, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == nil
      assert data                        == %{}
    end

    test "return price_state when price is 0 by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 0, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 0
      assert data                        == %{itr_pro.id => 0}
    end

    test "return price_state when price is 1 by role Tp" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 1, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_tp.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 1
      assert data                        == %{itr_pro.id => 3}
    end

    test "return price_state by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 22, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_pro.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 22
      assert data                        == %{itr_tp.id => 66}
    end

    test "return price_state when more one tp by role Pro" do
      state_for_tp1 = ["Alaska", "Michigan", "New Jersey"] |> Enum.sort() |> Enum.uniq()
      state_for_tp2 = ["American Samoa", "Michigan", "American Samoa"] |> Enum.sort() |> Enum.uniq()
      state_for_tp3 = ["New Jersey", "Delaware", "California", "Connecticut"] |> Enum.sort() |> Enum.uniq()

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, state: state_for_tp1, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, state: state_for_tp2, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, state: state_for_tp3, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 22, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_pro.id)

      assert format_names(itr_tp1.state) == state_for_tp1
      assert format_names(itr_tp2.state) == state_for_tp2
      assert format_names(itr_tp3.state) == state_for_tp3
      assert itr_tp1.price_state         == nil
      assert itr_tp2.price_state         == nil
      assert itr_tp3.price_state         == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 22
      assert data                        == %{
        itr_tp1.id => 66,
        itr_tp2.id => 44,
        itr_tp3.id => 88
      }
    end

    test "return price_state when is nil by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: nil, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_pro.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == nil
      assert data                        == :error
    end

    test "return price_state when is 0 by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 0, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_pro.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 0
      assert data                        == :error
    end

    test "return price_state when is 1 by role Pro" do
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_state: 1, user: pro)

      data = IndividualTaxReturn.check_price_state(itr_pro.id)

      assert format_names(itr_tp.state)  == state
      assert itr_tp.price_state          == nil
      assert format_names(itr_pro.state) == nil
      assert itr_pro.price_state         == 1
      assert data                        == %{itr_tp.id => 3}
    end

    test "return price_stock_divident by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_tp.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 22
      assert data                         == %{itr_pro.id => 22}
    end

    test "return price_stock_divident when more one pro by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 44, user: pro3)

      data = IndividualTaxReturn.check_price_stock_divident(itr_tp.id)

      assert itr_tp.stock_divident         == true
      assert itr_tp.price_stock_divident   == nil
      assert itr_pro1.stock_divident       == true
      assert itr_pro2.stock_divident       == true
      assert itr_pro3.stock_divident       == true
      assert itr_pro1.price_stock_divident == 22
      assert itr_pro2.price_stock_divident == 33
      assert itr_pro3.price_stock_divident == 44
      assert data                          == %{
        itr_pro1.id => 22,
        itr_pro2.id => 33,
        itr_pro3.id => 44
      }
    end

    test "return price_stock_divident when is false by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: false, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_tp.id)

      assert itr_tp.stock_divident        == false
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 22
      assert data                         == :error
    end

    test "return price_stock_divident when is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: nil, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_tp.id)

      assert itr_tp.stock_divident        == nil
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 22
      assert data                         == :error
    end

    test "return price_stock_divident when price is 0 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 0, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_tp.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 0
      assert data                         == %{}
    end

    test "return price_stock_divident when price is nil by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: nil, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_tp.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == nil
      assert data                         == %{}
    end

    test "return price_stock_divident when price is 1 by role Tp" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 1, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_tp.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 1
      assert data                         == %{itr_pro.id => 1}
    end

    test "return price_stock_divident by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_pro.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 22
      assert data                         == %{itr_tp.id => 22}
    end

    test "return price_stock_divident when more one tp by role Pro" do
      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, stock_divident: true, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, stock_divident: true, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, stock_divident: true, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_pro.id)

      assert itr_tp1.stock_divident       == true
      assert itr_tp2.stock_divident       == true
      assert itr_tp3.stock_divident       == true
      assert itr_tp1.price_stock_divident == nil
      assert itr_tp2.price_stock_divident == nil
      assert itr_tp3.price_stock_divident == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 22
      assert data                         == %{
        itr_tp1.id => 22,
        itr_tp2.id => 22,
        itr_tp3.id => 22
      }
    end

    test "return price_stock_divident when is false by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: false, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_pro.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == false
      assert itr_pro.price_stock_divident == 22
      assert data                         == :error
    end

    test "return price_stock_divident when is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: nil, price_stock_divident: 22, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_pro.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == nil
      assert itr_pro.price_stock_divident == 22
      assert data                         == :error
    end

    test "return price_stock_divident when price is 0 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 0, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_pro.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 0
      assert data                         == :error
    end

    test "return price_stock_divident when price is nil by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: nil, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_pro.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == nil
      assert data                         == :error
    end

    test "return price_stock_divident when price is 1 by role Pro" do
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, stock_divident: true, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, stock_divident: true, price_stock_divident: 1, user: pro)

      data = IndividualTaxReturn.check_price_stock_divident(itr_pro.id)

      assert itr_tp.stock_divident        == true
      assert itr_tp.price_stock_divident  == nil
      assert itr_pro.stock_divident       == true
      assert itr_pro.price_stock_divident == 1
      assert data                         == %{itr_tp.id => 1}
    end

    test "return price_tax_year by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 22, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 22
      assert data                           == %{itr_pro.id => 44}
    end

    test "return price_tax_year when more one pro by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro1 = insert(:pro_user, email: "arakawa@yahoo.com", languages: [])
      pro2 = insert(:pro_user, email: "harrison@yahoo.com", languages: [])
      pro3 = insert(:pro_user, email: "knapp@yahoo.com", languages: [])
      itr_pro1 = insert(:pro_individual_tax_return, price_tax_year: 22, user: pro1)
      itr_pro2 = insert(:pro_individual_tax_return, price_tax_year: 33, user: pro2)
      itr_pro3 = insert(:pro_individual_tax_return, price_tax_year: 44, user: pro3)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)   == tax_year
      assert itr_tp.price_tax_year           == nil
      assert format_names(itr_pro1.tax_year) == nil
      assert format_names(itr_pro2.tax_year) == nil
      assert format_names(itr_pro3.tax_year) == nil
      assert itr_pro1.price_tax_year         == 22
      assert itr_pro2.price_tax_year         == 33
      assert itr_pro3.price_tax_year         == 44
      assert data                            == %{
        itr_pro1.id => 44,
        itr_pro2.id => 66,
        itr_pro3.id => 88
      }
    end

    test "return price_tax_year when is 0 by role Tp" do
      tax_year = []

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 22, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 22
      assert data                           == :error
    end

    test "return price_tax_year when is 1 by role Tp" do
      tax_year = ["2017", "2017", "2017", "2017","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 22, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 22
      assert data                           == :error
    end

    test "return price_tax_year when is 2 by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 22, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 22
      assert data                           == %{itr_pro.id => 22}
    end

    test "return price_tax_year when price is 0 by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 0, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 0
      assert data                           == %{itr_pro.id => 0}
    end

    test "return price_tax_year when price is nil by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: nil, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == nil
      assert data                           == %{}
    end

    test "return price_tax_year when price is 1 by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 1, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 1
      assert data                           == %{itr_pro.id => 2}
    end

    test "return price_tax_year when price is 2 by role Tp" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 2, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_tp.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 2
      assert data                           == %{itr_pro.id => 4}
    end

    test "return price_tax_year by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 22, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_pro.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 22
      assert data                           == %{itr_tp.id => 44}
    end

    test "return price_tax_year when more one tp by role Pro" do
      tax_year_for_tp1 = ["2019", "2012", "2011"] |> Enum.sort() |> Enum.uniq()
      tax_year_for_tp2 = ["2018", "2017", "2014"] |> Enum.sort() |> Enum.uniq()
      tax_year_for_tp3 = ["2014", "2011", "2014", "2015"] |> Enum.sort() |> Enum.uniq()

      tp1 = insert(:tp_user, email: "arakawa@yahoo.com", languages: [])
      tp2 = insert(:tp_user, email: "harrison@yahoo.com", languages: [])
      tp3 = insert(:tp_user, email: "knapp@yahoo.com", languages: [])
      itr_tp1 = insert(:tp_individual_tax_return, tax_year: tax_year_for_tp1, user: tp1)
      itr_tp2 = insert(:tp_individual_tax_return, tax_year: tax_year_for_tp2, user: tp2)
      itr_tp3 = insert(:tp_individual_tax_return, tax_year: tax_year_for_tp3, user: tp3)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 22, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_pro.id)

      assert format_names(itr_tp1.tax_year) == tax_year_for_tp1
      assert format_names(itr_tp2.tax_year) == tax_year_for_tp2
      assert format_names(itr_tp3.tax_year) == tax_year_for_tp3
      assert itr_tp1.price_tax_year         == nil
      assert itr_tp2.price_tax_year         == nil
      assert itr_tp3.price_tax_year         == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 22
      assert data                           == %{
        itr_tp1.id => 44,
        itr_tp2.id => 44,
        itr_tp3.id => 44
      }
    end

    test "return price_tax_year when is 0 by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 0, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_pro.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 0
      assert data                           == :error
    end

    test "return price_tax_year when is nil by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: nil, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_pro.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == nil
      assert data                           == :error
    end

    test "return price_tax_year when is 1 by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 1, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_pro.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 1
      assert data                           == %{itr_tp.id => 2}
    end

    test "return price_tax_year when is 2 by role Pro" do
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 2, user: pro)

      data = IndividualTaxReturn.check_price_tax_year(itr_pro.id)

      assert format_names(itr_tp.tax_year)  == tax_year
      assert itr_tp.price_tax_year          == nil
      assert format_names(itr_pro.tax_year) == nil
      assert itr_pro.price_tax_year         == 2
      assert data                           == %{itr_tp.id => 4}
    end
  end

  describe "#check_value" do
    test "return value_foreign_account_limit by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_account_limit: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account_limit: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_account_limit(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_account_limit) == "22"
      assert itr_tp.foreign_account_limit                                  == true
      assert data                                                          == %{itr_tp.id => D.new("22")}
    end

    test "return value_foreign_account_limit when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_account_limit: 0)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account_limit: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_account_limit(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_account_limit) == "0"
      assert itr_tp.foreign_account_limit                                  == true
      assert data                                                          == %{itr_tp.id => D.new("0")}
    end

    test "return value_foreign_account_limit when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_account_limit: nil)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account_limit: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_account_limit(itr_tp.id)
      assert match.value_for_individual_foreign_account_limit == nil
      assert itr_tp.foreign_account_limit                     == true
      assert data                                             == %{itr_tp.id => D.new("0.0")}
    end

    test "return value_foreign_account_limit when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_account_limit: 1)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account_limit: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_account_limit(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_account_limit) == "1"
      assert itr_tp.foreign_account_limit                                  == true
      assert data                                                          == %{itr_tp.id => D.new("1")}
    end

    test "return value_foreign_account_limit when is false by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_account_limit: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account_limit: false, user: tp)
      data = IndividualTaxReturn.check_value_foreign_account_limit(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_account_limit) == "22"
      assert itr_tp.foreign_account_limit                                  == false
      assert data                                                          == :error
    end

    test "return value_foreign_account_limit when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_account_limit: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account_limit: nil, user: tp)
      data = IndividualTaxReturn.check_value_foreign_account_limit(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_account_limit) == "22"
      assert itr_tp.foreign_account_limit                                  == nil
      assert data                                                          == :error
    end

    test "return value_foreign_account_limit by role Pro" do
      match = insert(:match_value_relat, value_for_individual_foreign_account_limit: 0)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_account_limit: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_account_limit(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_account_limit) == "0"
      assert itr_tp.foreign_account_limit                                  == true
      assert data                                                          == %{itr_tp.id => D.new("0")}
    end

    test "return value_foreign_financial_interest by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_financial_interest) == "22"
      assert itr_tp.foreign_financial_interest                                  == true
      assert data                                                               == %{itr_tp.id => D.new("22")}
    end

    test "return value_foreign_financial_interest when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: 0)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_financial_interest) == "0"
      assert itr_tp.foreign_financial_interest                                  == true
      assert data                                                               == %{itr_tp.id => D.new("0")}
    end

    test "return value_foreign_financial_interest when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: nil)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert match.value_for_individual_foreign_financial_interest == nil
      assert itr_tp.foreign_financial_interest                     == true
      assert data                                                  == %{itr_tp.id => D.new("0.0")}
    end

    test "return value_foreign_financial_interest when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: 1)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_financial_interest) == "1"
      assert itr_tp.foreign_financial_interest                                  == true
      assert data                                                               == %{itr_tp.id => D.new("1")}
    end

    test "return value_foreign_financial_interest when is false by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: false, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_financial_interest) == "22"
      assert itr_tp.foreign_financial_interest                                  == false
      assert data                                                               == :error
    end

    test "return value_foreign_financial_interest when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: nil, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_financial_interest) == "22"
      assert itr_tp.foreign_financial_interest                                  == nil
      assert data                                                               == :error
    end

    test "return value_foreign_financial_interest by role Pro" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: 0)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_financial_interest) == "0"
      assert itr_tp.foreign_financial_interest                                  == true
      assert data                                                               == %{itr_tp.id => D.new("0")}
    end

    test "return value_home_owner by role Tp" do
      match = insert(:match_value_relat, value_for_individual_home_owner: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      data = IndividualTaxReturn.check_value_home_owner(itr_tp.id)
      assert D.to_string(match.value_for_individual_home_owner) == "22"
      assert itr_tp.home_owner                                  == true
      assert data                                               == %{itr_tp.id => D.new("22")}
    end

    test "return value_home_owner when match is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_home_owner: 0)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      data = IndividualTaxReturn.check_value_home_owner(itr_tp.id)
      assert D.to_string(match.value_for_individual_home_owner) == "0"
      assert itr_tp.home_owner                                  == true
      assert data                                               == %{itr_tp.id => D.new("0")}
    end

    test "return value_home_owner when match is nil by role Tp" do
      match = insert(:match_value_relat, value_for_individual_home_owner: nil)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      data = IndividualTaxReturn.check_value_home_owner(itr_tp.id)
      assert match.value_for_individual_home_owner == nil
      assert itr_tp.home_owner                     == true
      assert data                                  == %{itr_tp.id => D.new("0.0")}
    end

    test "return value_home_owner when match is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_home_owner: 1)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      data = IndividualTaxReturn.check_value_home_owner(itr_tp.id)
      assert D.to_string(match.value_for_individual_home_owner) == "1"
      assert itr_tp.home_owner                                  == true
      assert data                                               == %{itr_tp.id => D.new("1")}
    end

    test "return value_home_owner when is false by role Tp" do
      match = insert(:match_value_relat, value_for_individual_home_owner: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: false, user: tp)
      data = IndividualTaxReturn.check_value_home_owner(itr_tp.id)
      assert D.to_string(match.value_for_individual_home_owner) == "22"
      assert itr_tp.home_owner                                  == false
      assert data                                               == :error
    end

    test "return value_home_owner when is nil by role Tp" do
      match = insert(:match_value_relat, value_for_individual_home_owner: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: nil, user: tp)
      data = IndividualTaxReturn.check_value_home_owner(itr_tp.id)
      assert D.to_string(match.value_for_individual_home_owner) == "22"
      assert itr_tp.home_owner                                  == nil
      assert data                                               == :error
    end

    test "return value_foreign_financial_interest by role Pro" do
      match = insert(:match_value_relat, value_for_individual_foreign_financial_interest: 0)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, foreign_financial_interest: true, user: tp)
      data = IndividualTaxReturn.check_value_foreign_financial_interest(itr_tp.id)
      assert D.to_string(match.value_for_individual_foreign_financial_interest) == "0"
      assert itr_tp.foreign_financial_interest                                  == true
      assert data                                                               == %{itr_tp.id => D.new("0")}
    end

    test "return value_home_owner by role Pro" do
      match = insert(:match_value_relat, value_for_individual_home_owner: 0)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, home_owner: true, user: tp)
      data = IndividualTaxReturn.check_value_home_owner(itr_tp.id)
      assert D.to_string(match.value_for_individual_home_owner) == "0"
      assert itr_tp.home_owner                                  == true
      assert data                                               == %{itr_tp.id => D.new("0")}
    end

    test "return value_individual_employment_status by role Tp" do
      name = "self-employed"
      match = insert(:match_value_relat, value_for_individual_employment_status: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      data = IndividualTaxReturn.check_value_individual_employment_status(itr_tp.id)
      assert D.to_string(match.value_for_individual_employment_status) == "22"
      assert format_name(ies_tp.name)                                  == name
      assert ies_tp.price                                              == nil
      assert data                                                      == %{itr_tp.id => match.value_for_individual_employment_status}
    end

    test "return value_individual_employment_status when is unemployed by role Tp" do
      name = "unemployed"
      match = insert(:match_value_relat, value_for_individual_employment_status: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      data = IndividualTaxReturn.check_value_individual_employment_status(itr_tp.id)
      assert D.to_string(match.value_for_individual_employment_status) == "22"
      assert format_name(ies_tp.name)                                  == name
      assert ies_tp.price                                              == nil
      assert data                                                      == :error
    end

    test "return value_individual_employment_status when is employed by role Tp" do
      name = "employed"
      match = insert(:match_value_relat, value_for_individual_employment_status: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ies_tp = insert(:tp_individual_employment_status, name: name, individual_tax_returns: itr_tp)
      data = IndividualTaxReturn.check_value_individual_employment_status(itr_tp.id)
      assert D.to_string(match.value_for_individual_employment_status) == "22"
      assert format_name(ies_tp.name)                                  == name
      assert ies_tp.price                                              == nil
      assert data                                                      == :error
    end

    test "return value_individual_employment_status by role Pro" do
      name = "self-employed"
      match = insert(:match_value_relat, value_for_individual_employment_status: 22)
      pro = insert(:pro_user)
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ies_pro = insert(:tp_individual_employment_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_value_individual_employment_status(itr_pro.id)
      assert D.to_string(match.value_for_individual_employment_status) == "22"
      assert format_name(ies_pro.name)                                 == name
      assert ies_pro.price                                             == 22
      assert data                                                      == :error
    end

    test "return value_individual_filing_status by role Tp" do
      name = "Qualifying widow(-er) with dependent child"
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ifs_tp = insert(:tp_individual_filing_status, name: name, individual_tax_returns: itr_tp)
      data = IndividualTaxReturn.check_value_individual_filing_status(itr_tp.id)
      assert format_name(ifs_tp.name)                                  == name
      assert ifs_tp.price                                              == nil
      assert data                                                      == %{itr_tp.id => D.new("79.99")}
    end

    test "return value_individual_filing_status by role Pro" do
      name = "Qualifying widow(-er) with dependent child"
      pro = insert(:pro_user)
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      ifs_pro = insert(:tp_individual_filing_status, name: name, price: 22, individual_tax_returns: itr_pro)
      data = IndividualTaxReturn.check_value_individual_filing_status(itr_pro.id)
      assert format_name(ifs_pro.name)                                 == name
      assert ifs_pro.price                                             == 22
      assert data                                                      == :error
    end

    test "return value_individual_stock_transaction_count by role Tp" do
      name = "1-5"
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      ist_tp = insert(:tp_individual_stock_transaction_count, name: name, individual_tax_returns: itr_tp)
      data = IndividualTaxReturn.check_value_individual_stock_transaction_count(itr_tp.id)
      assert format_name(ist_tp.name)                                  == name
      assert data                                                      == %{itr_tp.id => D.new("30.0")}
    end

    test "return value_k1_count by role Tp" do
      match = insert(:match_value_relat, value_for_individual_k1_count: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, k1_count: 11, user: tp)
      data = IndividualTaxReturn.check_value_k1_count(itr_tp.id)
      assert D.to_string(match.value_for_individual_k1_count) == "22"
      assert itr_tp.k1_count                                  == 11
      assert data                                             == %{itr_tp.id => D.new("242")}
    end

    test "return value_k1_count by role Pro" do
      match = insert(:match_value_relat, value_for_individual_k1_count: 22)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      data = IndividualTaxReturn.check_value_k1_count(itr_pro.id)
      assert D.to_string(match.value_for_individual_k1_count) == "22"
      assert itr_pro.k1_count                                 == nil
      assert data                                             == :error
    end

    test "return value_rental_property_income by role Tp" do
      match = insert(:match_value_relat, value_for_individual_rental_prop_income: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, rental_property_income: true, user: tp)
      data = IndividualTaxReturn.check_value_rental_property_income(itr_tp.id)
      assert D.to_string(match.value_for_individual_rental_prop_income) == "22"
      assert itr_tp.rental_property_income                              == true
      assert data                                                       == %{itr_tp.id => D.new("22")}
    end

    test "return value_rental_property_income by role Pro" do
      match = insert(:match_value_relat, value_for_individual_rental_prop_income: 22)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, rental_property_income: true, user: pro)
      data = IndividualTaxReturn.check_value_rental_property_income(itr_pro.id)
      assert D.to_string(match.value_for_individual_rental_prop_income) == "22"
      assert itr_pro.rental_property_income                             == true
      assert data                                                       == :error
    end

    test "return value_sole_proprietorship_count by role Tp" do
      match = insert(:match_value_relat, value_for_individual_sole_prop_count: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 11, user: tp)
      data = IndividualTaxReturn.check_value_sole_proprietorship_count(itr_tp.id)
      assert D.to_string(match.value_for_individual_sole_prop_count) == "22"
      assert itr_tp.sole_proprietorship_count                        == 11
      assert data                                                    == %{itr_tp.id => D.new("22")}
    end

    test "return value_sole_proprietorship_count when is 0 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_sole_prop_count: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 0, user: tp)
      data = IndividualTaxReturn.check_value_sole_proprietorship_count(itr_tp.id)
      assert D.to_string(match.value_for_individual_sole_prop_count) == "22"
      assert itr_tp.sole_proprietorship_count                        == 0
      assert data                                                    == :error
    end

    test "return value_sole_proprietorship_count when is 1 by role Tp" do
      match = insert(:match_value_relat, value_for_individual_sole_prop_count: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, sole_proprietorship_count: 1, user: tp)
      data = IndividualTaxReturn.check_value_sole_proprietorship_count(itr_tp.id)
      assert D.to_string(match.value_for_individual_sole_prop_count) == "22"
      assert itr_tp.sole_proprietorship_count                        == 1
      assert data                                                    == %{itr_tp.id => D.new("22")}
    end

    test "return value_sole_proprietorship_count by role Pro" do
      match = insert(:match_value_relat, value_for_individual_sole_prop_count: 22)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      data = IndividualTaxReturn.check_value_sole_proprietorship_count(itr_pro.id)
      assert D.to_string(match.value_for_individual_sole_prop_count) == "22"
      assert itr_pro.sole_proprietorship_count                       == nil
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
      match = insert(:match_value_relat, value_for_individual_state: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      data = IndividualTaxReturn.check_value_state(itr_tp.id)
      assert D.to_string(match.value_for_individual_state) == "22"
      assert itr_tp.state                                  == state
      assert itr_tp.price_state                            == nil
      assert data                                          == %{itr_tp.id => D.new("154")}
    end

    test "return value_state when state is 0 by role Tp" do
      state = []
      match = insert(:match_value_relat, value_for_individual_state: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      data = IndividualTaxReturn.check_value_state(itr_tp.id)
      assert D.to_string(match.value_for_individual_state) == "22"
      assert itr_tp.state                                  == state
      assert itr_tp.price_state                            == nil
      assert data                                          == :error
    end

    test "return value_state by when state is 1 role Tp" do
      state = ["American Samoa"]
      match = insert(:match_value_relat, value_for_individual_state: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, state: state, user: tp)
      data = IndividualTaxReturn.check_value_state(itr_tp.id)
      assert D.to_string(match.value_for_individual_state) == "22"
      assert itr_tp.state                                  == state
      assert itr_tp.price_state                            == nil
      assert data                                          == %{itr_tp.id => D.new("22")}
    end

    test "return value_state by role Pro" do
      match = insert(:match_value_relat, value_for_individual_state: 22)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, user: pro)
      data = IndividualTaxReturn.check_value_state(itr_pro.id)
      assert D.to_string(match.value_for_individual_state) == "22"
      assert itr_pro.state                                 == nil
      assert itr_pro.price_state                           == itr_pro.price_state
      assert data                                          == :error
    end

    test "return value_tax_year by role Tp" do
      tax_year = ["2012", "2015", "2011", "2012", "2017", "2011"] |> Enum.sort() |> Enum.uniq()
      match = insert(:match_value_relat, value_for_individual_tax_year: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      data = IndividualTaxReturn.check_value_tax_year(itr_tp.id)
      assert D.to_string(match.value_for_individual_tax_year) == "22"
      assert itr_tp.tax_year                                  == tax_year
      assert itr_tp.price_tax_year                            == nil
      assert data                                             == %{itr_tp.id => D.new("66")}
    end

    test "return value_tax_year when is 0 by role Tp" do
      tax_year = []
      match = insert(:match_value_relat, value_for_individual_tax_year: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      data = IndividualTaxReturn.check_value_tax_year(itr_tp.id)
      assert D.to_string(match.value_for_individual_tax_year) == "22"
      assert itr_tp.tax_year                                  == tax_year
      assert data                                             == :error
    end

    test "return value_tax_year when is 1 by role Tp" do
      tax_year = ["2012", "2012", "2012", "2012", "2012"] |> Enum.sort() |> Enum.uniq()
      match = insert(:match_value_relat, value_for_individual_tax_year: 22)
      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, tax_year: tax_year, user: tp)
      data = IndividualTaxReturn.check_value_tax_year(itr_tp.id)
      assert D.to_string(match.value_for_individual_tax_year) == "22"
      assert itr_tp.tax_year                                  == tax_year
      assert itr_tp.price_tax_year                            == nil
      assert data                                             == %{itr_tp.id => D.new("0")}
    end

    test "return value_tax_year by role Pro" do
      match = insert(:match_value_relat, value_for_individual_tax_year: 22)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return, price_tax_year: 11, user: pro)
      data = IndividualTaxReturn.check_value_tax_year(itr_pro.id)
      assert D.to_string(match.value_for_individual_tax_year) == "22"
      assert itr_pro.tax_year                                 == nil
      assert itr_pro.price_tax_year                           == 11
      assert data                                             == :error
    end
  end

  describe "#total_match" do
    test "return result by total_match where role is Tp" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_industry = Enum.sort(["Hospitality"])
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      name_itemized_deduction = "Charitable contributions"

      insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        stock_divident: true,
        user: tp)
      itr_pro = insert(:pro_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        stock_divident: true,
        user: pro)

      insert(:pro_individual_employment_status, name: name_employment_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_filing_status, name: name_filing_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_industry, name: names_industry, individual_tax_returns: itr_pro)
      insert(:pro_individual_itemized_deduction, name: name_itemized_deduction, price: 22, individual_tax_returns: itr_pro)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_industry, name: name_industry, individual_tax_returns: itr_tp)
      insert(:tp_individual_itemized_deduction, name: name_itemized_deduction, individual_tax_returns: itr_tp)

      data = Analyzes.total_match(itr_tp.id)
      assert data == %{itr_pro.id => 255}
    end

    test "return result by total_match where role is Pro" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_industry = Enum.sort(["Hospitality"])
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      name_itemized_deduction = "Charitable contributions"

      insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        stock_divident: true,
        user: tp)
      itr_pro = insert(:pro_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        stock_divident: true,
        user: pro)

      insert(:pro_individual_employment_status, name: name_employment_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_filing_status, name: name_filing_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_industry, name: names_industry, individual_tax_returns: itr_pro)
      insert(:pro_individual_itemized_deduction, name: name_itemized_deduction, price: 22, individual_tax_returns: itr_pro)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_industry, name: name_industry, individual_tax_returns: itr_tp)
      insert(:tp_individual_itemized_deduction, name: name_itemized_deduction, individual_tax_returns: itr_tp)

      data = Analyzes.total_match(itr_pro.id)
      assert data == %{itr_tp.id => 255}
    end

    test "return error when is not correct individual_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_match(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "#total_price" do
    test "return result by total_price where role is Tp" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_itemized_deduction = "Charitable contributions"
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        sole_proprietorship_count: 11,
        state: state,
        stock_divident: true,
        tax_year: tax_year,
        user: tp)
      itr_pro = insert(:pro_individual_tax_return,
        foreign_account: true,
        price_foreign_account: 22,
        home_owner: true,
        price_home_owner: 22,
        living_abroad: true,
        price_living_abroad: 22,
        non_resident_earning: true,
        price_non_resident_earning: 22,
        own_stock_crypto: true,
        price_own_stock_crypto: 22,
        rental_property_income: true,
        price_rental_property_income: 22,
        price_sole_proprietorship_count: 22,
        price_state: 22,
        stock_divident: true,
        price_stock_divident: 22,
        price_tax_year: 22,
        user: pro)

      insert(:pro_individual_employment_status, name: name_employment_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_filing_status, name: name_filing_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_itemized_deduction, name: name_itemized_deduction, price: 22, individual_tax_returns: itr_pro)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_itemized_deduction, name: name_itemized_deduction, individual_tax_returns: itr_tp)

      data = Analyzes.total_price(itr_tp.id)
      assert data == %{itr_pro.id => 550}
    end

    test "return result by total_price where role is Pro" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_itemized_deduction = "Charitable contributions"
      state = ["Alaska", "Michigan", "New Jersey", "Michigan"] |> Enum.sort() |> Enum.uniq()
      tax_year = ["2015", "2016", "2016", "2015","2017", "2017"] |> Enum.sort() |> Enum.uniq()

      insert(:match_value_relat)

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        sole_proprietorship_count: 11,
        state: state,
        stock_divident: true,
        tax_year: tax_year,
        user: tp)
      itr_pro = insert(:pro_individual_tax_return,
        foreign_account: true,
        price_foreign_account: 22,
        home_owner: true,
        price_home_owner: 22,
        living_abroad: true,
        price_living_abroad: 22,
        non_resident_earning: true,
        price_non_resident_earning: 22,
        own_stock_crypto: true,
        price_own_stock_crypto: 22,
        rental_property_income: true,
        price_rental_property_income: 22,
        price_sole_proprietorship_count: 22,
        price_state: 22,
        stock_divident: true,
        price_stock_divident: 22,
        price_tax_year: 22,
        user: pro)

      insert(:pro_individual_employment_status, name: name_employment_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_filing_status, name: name_filing_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_itemized_deduction, name: name_itemized_deduction, price: 22, individual_tax_returns: itr_pro)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_itemized_deduction, name: name_itemized_deduction, individual_tax_returns: itr_tp)

      data = Analyzes.total_price(itr_pro.id)
      assert data == %{itr_tp.id => 550}
    end

    test "return error when is not correct individual_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_price(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "total_value" do
    test "return result by total_value where role is Tp" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_stock_transaction_count = "1-5"
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
      tax_year = ["2012", "2015", "2011", "2012", "2017", "2011"] |> Enum.sort() |> Enum.uniq()

      insert(:match_value_relat,
        value_for_individual_foreign_account_limit: 22,
        value_for_individual_foreign_financial_interest: 22,
        value_for_individual_home_owner: 22,
        value_for_individual_employment_status: 22,
        value_for_individual_k1_count: 22,
        value_for_individual_rental_prop_income: 22,
        value_for_individual_sole_prop_count: 22,
        value_for_individual_state: 22,
        value_for_individual_tax_year: 22
      )

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return,
        foreign_account_limit: true,
        foreign_financial_interest: true,
        home_owner: true,
        k1_count: 11,
        rental_property_income: true,
        sole_proprietorship_count: 11,
        state: state,
        tax_year: tax_year,
        user: tp)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_stock_transaction_count, name: name_stock_transaction_count, individual_tax_returns: itr_tp)

      data = Analyzes.total_value(itr_tp.id)
      assert data == %{itr_tp.id => D.new("681.99")}
    end

    test "return result by total_value where role is Pro" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_stock_transaction_count = "1-5"

      insert(:match_value_relat,
        value_for_individual_foreign_account_limit: 22,
        value_for_individual_foreign_financial_interest: 22,
        value_for_individual_home_owner: 22,
        value_for_individual_employment_status: 22,
        value_for_individual_k1_count: 22,
        value_for_individual_rental_prop_income: 22,
        value_for_individual_sole_prop_count: 22,
        value_for_individual_state: 22,
        value_for_individual_tax_year: 22
      )

      tp = insert(:tp_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return, user: tp)
      pro = insert(:pro_user, languages: [])
      itr_pro = insert(:pro_individual_tax_return,
        home_owner: true,
        rental_property_income: true,
        user: pro)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_stock_transaction_count, name: name_stock_transaction_count, individual_tax_returns: itr_tp)

      insert(:pro_individual_employment_status, name: name_employment_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_filing_status, name: name_filing_status, price: 22, individual_tax_returns: itr_pro)

      data = Analyzes.total_value(itr_pro.id)
      assert data == %{itr_pro.id => D.new("0")}
    end

    test "return error when is not correct individual_tax_return_id" do
      id = FlakeId.get()
      data = Analyzes.total_value(id)
      assert data == [field: :user_id, message: "UserId Not Found in SaleTax"]
    end
  end

  describe "#total_all" do
    test "return result by total_all where role is Tp" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_industry = Enum.sort(["Hospitality"])
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      name_itemized_deduction = "Charitable contributions"
      name_stock_transaction_count = "1-5"
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
      tax_year = ["2012", "2015", "2011", "2012", "2017", "2011"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return,
        foreign_account: true,
        foreign_account_limit: true,
        foreign_financial_interest: true,
        home_owner: true,
        k1_count: 11,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        sole_proprietorship_count: 11,
        state: state,
        stock_divident: true,
        tax_year: tax_year,
        user: tp)
      itr_pro = insert(:pro_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        price_foreign_account: 22,
        price_home_owner: 22,
        price_living_abroad: 22,
        price_non_resident_earning: 22,
        price_own_stock_crypto: 22,
        price_rental_property_income: 22,
        price_sole_proprietorship_count: 22,
        price_state: 22,
        price_stock_divident: 22,
        price_tax_year: 22,
        rental_property_income: true,
        stock_divident: true,
        user: pro)

      insert(:match_value_relat,
        value_for_individual_employment_status: 22,
        value_for_individual_foreign_account_limit: 22,
        value_for_individual_foreign_financial_interest: 22,
        value_for_individual_home_owner: 22,
        value_for_individual_k1_count: 22,
        value_for_individual_rental_prop_income: 22,
        value_for_individual_sole_prop_count: 22,
        value_for_individual_state: 22,
        value_for_individual_tax_year: 22
      )

      insert(:pro_individual_employment_status, name: name_employment_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_industry, name: names_industry, individual_tax_returns: itr_pro)
      insert(:pro_individual_filing_status, name: name_filing_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_itemized_deduction, name: name_itemized_deduction, price: 22, individual_tax_returns: itr_pro)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_industry, name: name_industry, individual_tax_returns: itr_tp)
      insert(:tp_individual_itemized_deduction, name: name_itemized_deduction, individual_tax_returns: itr_tp)
      insert(:tp_individual_stock_transaction_count, name: name_stock_transaction_count, individual_tax_returns: itr_tp)

      data = Analyzes.total_all(itr_tp.id)

      assert data == [
        %{id: itr_tp.id, sum_value: %{itr_tp.id => D.new("681.99")}},
        %{id: itr_pro.id, sum_match: 255},
        %{id: itr_pro.id, sum_price: 660}
      ]
    end

    test "return result by total_all where role is Pro" do
      name_employment_status = "employed"
      name_filing_status = "Qualifying widow(-er) with dependent child"
      name_industry = Enum.sort(["Hospitality"])
      names_industry = Enum.sort(["Telecommunications", "Hospitality", "Property Management", "Legal", "Education"])
      name_itemized_deduction = "Charitable contributions"
      name_stock_transaction_count = "1-5"
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
      tax_year = ["2012", "2015", "2011", "2012", "2017", "2011"] |> Enum.sort() |> Enum.uniq()

      tp = insert(:tp_user, languages: [])
      pro = insert(:pro_user, languages: [])
      itr_tp = insert(:tp_individual_tax_return,
        foreign_account: true,
        foreign_account_limit: true,
        foreign_financial_interest: true,
        home_owner: true,
        k1_count: 11,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        rental_property_income: true,
        sole_proprietorship_count: 11,
        state: state,
        stock_divident: true,
        tax_year: tax_year,
        user: tp)
      itr_pro = insert(:pro_individual_tax_return,
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        own_stock_crypto: true,
        price_foreign_account: 22,
        price_home_owner: 22,
        price_living_abroad: 22,
        price_non_resident_earning: 22,
        price_own_stock_crypto: 22,
        price_rental_property_income: 22,
        price_sole_proprietorship_count: 22,
        price_state: 22,
        price_stock_divident: 22,
        price_tax_year: 22,
        rental_property_income: true,
        stock_divident: true,
        user: pro)

      insert(:match_value_relat,
        value_for_individual_employment_status: 22,
        value_for_individual_foreign_account_limit: 22,
        value_for_individual_foreign_financial_interest: 22,
        value_for_individual_home_owner: 22,
        value_for_individual_k1_count: 22,
        value_for_individual_rental_prop_income: 22,
        value_for_individual_sole_prop_count: 22,
        value_for_individual_state: 22,
        value_for_individual_tax_year: 22
      )

      insert(:pro_individual_employment_status, name: name_employment_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_industry, name: names_industry, individual_tax_returns: itr_pro)
      insert(:pro_individual_filing_status, name: name_filing_status, price: 22, individual_tax_returns: itr_pro)
      insert(:pro_individual_itemized_deduction, name: name_itemized_deduction, price: 22, individual_tax_returns: itr_pro)

      insert(:tp_individual_employment_status, name: name_employment_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_filing_status, name: name_filing_status, individual_tax_returns: itr_tp)
      insert(:tp_individual_industry, name: name_industry, individual_tax_returns: itr_tp)
      insert(:tp_individual_itemized_deduction, name: name_itemized_deduction, individual_tax_returns: itr_tp)
      insert(:tp_individual_stock_transaction_count, name: name_stock_transaction_count, individual_tax_returns: itr_tp)

      data = Analyzes.total_all(itr_pro.id)

      assert data == [
        %{id: itr_pro.id, sum_value: %{itr_pro.id => D.new("0")}},
        %{id: itr_tp.id, sum_match: 255},
        %{id: itr_tp.id, sum_price: 660}
      ]
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
