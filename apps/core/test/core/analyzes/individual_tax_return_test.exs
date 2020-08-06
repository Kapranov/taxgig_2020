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
      assert data                                       == %{
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
