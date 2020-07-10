# OLD_DB_URL="ecto://kapranov:nicmos6922@localhost/taxgig" mix run counter.exs

old_db_url = System.get_env("OLD_DB_URL") || raise("Missing OLD_DB_URL!")

defmodule TestRepo do
  use Ecto.Repo,
  otp_app: :core,
  adapter: Ecto.Adapters.Postgres,
  read_only: true
end

defmodule TestFaqCategory do
  use Ecto.Schema

  schema "faq_categories" do
    field :title, :string
  end
end

TestRepo.start_link(url: old_db_url, ssl: false)

IO.inspect count: TestRepo.aggregate(TestFaqCategory, :count)
IO.inspect count: TestRepo.aggregate("accounting_softwares", :count)
IO.inspect count: TestRepo.aggregate("book_keeping_additional_needs", :count)
IO.inspect count: TestRepo.aggregate("book_keeping_annual_revenues", :count)
IO.inspect count: TestRepo.aggregate("book_keeping_classify_inventories", :count)
IO.inspect count: TestRepo.aggregate("book_keeping_industries", :count)
IO.inspect count: TestRepo.aggregate("book_keeping_number_employees", :count)
IO.inspect count: TestRepo.aggregate("book_keeping_transaction_volumes", :count)
IO.inspect count: TestRepo.aggregate("book_keeping_type_clients", :count)
IO.inspect count: TestRepo.aggregate("book_keepings", :count)
IO.inspect count: TestRepo.aggregate("business_entity_types", :count)
IO.inspect count: TestRepo.aggregate("business_foreign_account_counts", :count)
IO.inspect count: TestRepo.aggregate("business_foreign_ownership_counts", :count)
IO.inspect count: TestRepo.aggregate("business_industries", :count)
IO.inspect count: TestRepo.aggregate("business_llc_types", :count)
IO.inspect count: TestRepo.aggregate("business_number_employees", :count)
IO.inspect count: TestRepo.aggregate("business_tax_returns", :count)
IO.inspect count: TestRepo.aggregate("business_total_revenues", :count)
IO.inspect count: TestRepo.aggregate("business_transaction_counts", :count)
IO.inspect count: TestRepo.aggregate("educations", :count)
IO.inspect count: TestRepo.aggregate("faq_categories", :count)
IO.inspect count: TestRepo.aggregate("faqs", :count)
IO.inspect count: TestRepo.aggregate("individual_employment_statuses", :count)
IO.inspect count: TestRepo.aggregate("individual_filing_statuses", :count)
IO.inspect count: TestRepo.aggregate("individual_foreign_account_counts", :count)
IO.inspect count: TestRepo.aggregate("individual_industries", :count)
IO.inspect count: TestRepo.aggregate("individual_itemized_deductions", :count)
IO.inspect count: TestRepo.aggregate("individual_stock_transaction_counts", :count)
IO.inspect count: TestRepo.aggregate("individual_tax_returns", :count)
IO.inspect count: TestRepo.aggregate("languages", :count)
IO.inspect count: TestRepo.aggregate("match_value_relates", :count)
IO.inspect count: TestRepo.aggregate("messages", :count)
IO.inspect count: TestRepo.aggregate("pictures", :count)
IO.inspect count: TestRepo.aggregate("press_articles", :count)
IO.inspect count: TestRepo.aggregate("profiles", :count)
IO.inspect count: TestRepo.aggregate("rooms", :count)
IO.inspect count: TestRepo.aggregate("sale_tax_frequencies", :count)
IO.inspect count: TestRepo.aggregate("sale_tax_industries", :count)
IO.inspect count: TestRepo.aggregate("sale_taxes", :count)
IO.inspect count: TestRepo.aggregate("schema_migrations", :count)
IO.inspect count: TestRepo.aggregate("states", :count)
IO.inspect count: TestRepo.aggregate("subscribers", :count)
IO.inspect count: TestRepo.aggregate("universities", :count)
IO.inspect count: TestRepo.aggregate("us_zipcodes", :count)
IO.inspect count: TestRepo.aggregate("users", :count)
IO.inspect count: TestRepo.aggregate("users_languages", :count)
IO.inspect count: TestRepo.aggregate("vacancies", :count)
IO.inspect count: TestRepo.aggregate("work_experiences", :count)
