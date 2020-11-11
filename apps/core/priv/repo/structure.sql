--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounting_softwares; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.accounting_softwares (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255)[] DEFAULT NULL::character varying[],
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: addons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.addons (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    addon_price integer NOT NULL,
    status character varying(255) NOT NULL,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ban_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.ban_reasons (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    reasons character varying(255) DEFAULT NULL::character varying,
    other boolean NOT NULL,
    other_description character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keeping_additional_needs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keeping_additional_needs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keeping_annual_revenues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keeping_annual_revenues (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keeping_classify_inventories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keeping_classify_inventories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keeping_industries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keeping_industries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid NOT NULL,
    name character varying(255)[] DEFAULT NULL::character varying[],
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keeping_number_employees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keeping_number_employees (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keeping_transaction_volumes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keeping_transaction_volumes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keeping_type_clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keeping_type_clients (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_keepings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.book_keepings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    active boolean DEFAULT true NOT NULL,
    account_count integer,
    balance_sheet boolean,
    deadline date,
    financial_situation text,
    inventory boolean,
    inventory_count integer,
    payroll boolean,
    price_payroll integer,
    tax_return_current boolean,
    tax_year character varying(255)[] DEFAULT NULL::character varying[],
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_entity_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_entity_types (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_foreign_account_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_foreign_account_counts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_foreign_ownership_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_foreign_ownership_counts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_industries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_industries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255)[],
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_llc_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_llc_types (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_number_employees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_number_employees (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_tax_returns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_tax_returns (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    active boolean DEFAULT true NOT NULL,
    accounting_software boolean,
    capital_asset_sale boolean,
    church_hospital boolean,
    deadline date,
    dispose_asset boolean,
    dispose_property boolean,
    educational_facility boolean,
    financial_situation text,
    foreign_account_interest boolean,
    foreign_account_value_more boolean,
    foreign_entity_interest boolean,
    foreign_partner_count integer,
    foreign_shareholder boolean,
    foreign_value boolean,
    fundraising_over boolean,
    has_contribution boolean,
    has_loan boolean,
    income_over_thousand boolean,
    invest_research boolean,
    k1_count integer,
    lobbying boolean,
    make_distribution boolean,
    none_expat boolean,
    operate_facility boolean,
    price_state integer,
    price_tax_year integer,
    property_sale boolean,
    public_charity boolean,
    rental_property_count integer,
    reported_grant boolean,
    restricted_donation boolean,
    state character varying(255)[] DEFAULT NULL::character varying[],
    tax_exemption boolean,
    tax_year character varying(255)[] DEFAULT NULL::character varying[],
    total_asset_less boolean,
    total_asset_over boolean,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_total_revenues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_total_revenues (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_transaction_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.business_transaction_counts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    business_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: deleted_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.deleted_users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    reason character varying(255) NOT NULL,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.documents (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    access_granted boolean,
    category integer,
    document_link character varying(255),
    format integer,
    name integer,
    signature_required_from_client boolean,
    signed_by_client boolean,
    signed_by_pro boolean,
    size numeric DEFAULT 0.0,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: educations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.educations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    course character varying(255) DEFAULT NULL::character varying,
    graduation date,
    university_id uuid NOT NULL,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: faq_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.faq_categories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: faqs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.faqs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    content text,
    faq_category_id uuid NOT NULL,
    title character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: individual_employment_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.individual_employment_statuses (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    individual_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: individual_filing_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.individual_filing_statuses (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    individual_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: individual_foreign_account_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.individual_foreign_account_counts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    individual_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: individual_industries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.individual_industries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    individual_tax_return_id uuid NOT NULL,
    name character varying(255)[],
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: individual_itemized_deductions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.individual_itemized_deductions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    individual_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: individual_stock_transaction_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.individual_stock_transaction_counts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    individual_tax_return_id uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: individual_tax_returns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.individual_tax_returns (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    active boolean DEFAULT true NOT NULL,
    deadline date,
    foreign_account boolean,
    foreign_account_limit boolean,
    foreign_financial_interest boolean,
    home_owner boolean,
    k1_count integer,
    k1_income boolean,
    living_abroad boolean,
    non_resident_earning boolean,
    none_expat boolean,
    own_stock_crypto boolean,
    price_foreign_account integer,
    price_home_owner integer,
    price_living_abroad integer,
    price_non_resident_earning integer,
    price_own_stock_crypto integer,
    price_rental_property_income integer,
    price_sole_proprietorship_count integer,
    price_state integer,
    price_stock_divident integer,
    price_tax_year integer,
    rental_property_count integer,
    rental_property_income boolean,
    sole_proprietorship_count integer,
    state character varying(255)[] DEFAULT NULL::character varying[],
    stock_divident boolean,
    tax_year character varying(255)[] DEFAULT NULL::character varying[],
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.languages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255),
    abbr character varying(255)
);


--
-- Name: match_value_relates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.match_value_relates (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    match_for_book_keeping_additional_need integer DEFAULT 0,
    match_for_book_keeping_annual_revenue integer DEFAULT 0,
    match_for_book_keeping_industry integer DEFAULT 0,
    match_for_book_keeping_number_employee integer DEFAULT 0,
    match_for_book_keeping_payroll integer DEFAULT 0,
    match_for_book_keeping_type_client integer DEFAULT 0,
    match_for_business_enity_type integer DEFAULT 0,
    match_for_business_industry integer DEFAULT 0,
    match_for_business_number_of_employee integer DEFAULT 0,
    match_for_business_total_revenue integer DEFAULT 0,
    match_for_individual_employment_status integer DEFAULT 0,
    match_for_individual_filing_status integer DEFAULT 0,
    match_for_individual_foreign_account integer DEFAULT 0,
    match_for_individual_home_owner integer DEFAULT 0,
    match_for_individual_industry integer DEFAULT 0,
    match_for_individual_itemized_deduction integer DEFAULT 0,
    match_for_individual_living_abroad integer DEFAULT 0,
    match_for_individual_non_resident_earning integer DEFAULT 0,
    match_for_individual_own_stock_crypto integer DEFAULT 0,
    match_for_individual_rental_prop_income integer DEFAULT 0,
    match_for_individual_stock_divident integer DEFAULT 0,
    match_for_sale_tax_count integer DEFAULT 0,
    match_for_sale_tax_frequency integer DEFAULT 0,
    match_for_sale_tax_industry integer DEFAULT 0,
    value_for_book_keeping_payroll numeric DEFAULT 0.0,
    value_for_book_keeping_tax_year numeric DEFAULT 0.0,
    value_for_business_accounting_software numeric DEFAULT 0.0,
    value_for_business_dispose_property numeric DEFAULT 0.0,
    value_for_business_foreign_shareholder numeric DEFAULT 0.0,
    value_for_business_income_over_thousand numeric DEFAULT 0.0,
    value_for_business_invest_research numeric DEFAULT 0.0,
    value_for_business_k1_count numeric DEFAULT 0.0,
    value_for_business_make_distribution numeric DEFAULT 0.0,
    value_for_business_state numeric DEFAULT 0.0,
    value_for_business_tax_exemption numeric DEFAULT 0.0,
    value_for_business_total_asset_over numeric DEFAULT 0.0,
    value_for_individual_employment_status numeric DEFAULT 0.0,
    value_for_individual_foreign_account_limit numeric DEFAULT 0.0,
    value_for_individual_foreign_financial_interest numeric DEFAULT 0.0,
    value_for_individual_home_owner numeric DEFAULT 0.0,
    value_for_individual_k1_count numeric DEFAULT 0.0,
    value_for_individual_rental_prop_income numeric DEFAULT 0.0,
    value_for_individual_sole_prop_count numeric DEFAULT 0.0,
    value_for_individual_state numeric DEFAULT 0.0,
    value_for_individual_tax_year numeric DEFAULT 0.0,
    value_for_sale_tax_count numeric DEFAULT 0.0,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.messages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    body character varying(255),
    room_id uuid NOT NULL,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.offers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    offer_price integer NOT NULL,
    status character varying(255) NOT NULL,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pictures; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.pictures (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    file jsonb,
    profile_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: platforms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.platforms (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    ban_reason_id uuid,
    client_limit_reach boolean DEFAULT false NOT NULL,
    hero_active boolean,
    hero_status boolean,
    is_banned boolean DEFAULT false NOT NULL,
    is_online boolean DEFAULT false NOT NULL,
    is_stuck boolean DEFAULT false NOT NULL,
    payment_active boolean DEFAULT false NOT NULL,
    stuck_stage character varying(255),
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: press_articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.press_articles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    author character varying(255),
    img_url character varying(255),
    preview_text character varying(255),
    title character varying(255),
    url character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pro_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.pro_ratings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    average_communication numeric NOT NULL,
    average_professionalism numeric NOT NULL,
    average_rating numeric NOT NULL,
    average_work_quality numeric NOT NULL,
    platform_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.profiles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    address character varying(255),
    banner character varying(255),
    description character varying(255),
    logo jsonb,
    us_zipcode_id uuid,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.projects (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    addon_id uuid,
    assigned_pro uuid,
    end_time date,
    instant_matched boolean NOT NULL,
    offer_id uuid,
    project_price integer,
    status character varying(255) NOT NULL,
    stripe_card_token_id uuid,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.reports (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    message_id uuid NOT NULL,
    other boolean NOT NULL,
    other_description character varying(255),
    reasons character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.rooms (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(255),
    topic character varying(120),
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sale_tax_frequencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.sale_tax_frequencies (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    price integer,
    sale_tax_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sale_tax_industries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.sale_tax_industries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255)[],
    sale_tax_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sale_taxes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.sale_taxes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    active boolean DEFAULT true NOT NULL,
    deadline date,
    financial_situation text,
    price_sale_tax_count integer,
    sale_tax_count integer,
    state character varying(255)[] DEFAULT NULL::character varying[],
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: service_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.service_links (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_keeping_id uuid,
    business_tax_return_id uuid,
    individual_tax_return_id uuid,
    sale_tax_id uuid,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: service_reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.service_reviews (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    client_comment character varying(255),
    communication integer NOT NULL,
    final_rating numeric NOT NULL,
    pro_response character varying(255),
    professionalism integer NOT NULL,
    work_quality integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.states (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    abbr character varying(255),
    name character varying(255)
);


--
-- Name: subscribers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.subscribers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255),
    pro_role boolean,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: universities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.universities (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: us_zipcodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.us_zipcodes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    city character varying(255) NOT NULL,
    state character varying(255) NOT NULL,
    zipcode integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    active boolean,
    admin boolean DEFAULT false NOT NULL,
    avatar character varying(255),
    bio character varying(255),
    birthday date,
    email character varying(255) NOT NULL,
    first_name character varying(255),
    init_setup boolean,
    last_name character varying(255),
    middle_name character varying(255),
    password_hash character varying(255) NOT NULL,
    phone character varying(255),
    role boolean DEFAULT false NOT NULL,
    provider character varying(255) DEFAULT 'localhost'::character varying NOT NULL,
    sex character varying(255),
    ssn integer,
    street character varying(255),
    zip integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_languages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.users_languages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    language_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: vacancies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.vacancies (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    content text,
    department character varying(255),
    title character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: work_experiences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.work_experiences (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    start_date date,
    end_date date,
    user_id uuid NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accounting_softwares_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.accounting_softwares
    ADD CONSTRAINT accounting_softwares_pkey PRIMARY KEY (id);


--
-- Name: addons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.addons
    ADD CONSTRAINT addons_pkey PRIMARY KEY (id);


--
-- Name: ban_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.ban_reasons
    ADD CONSTRAINT ban_reasons_pkey PRIMARY KEY (id);


--
-- Name: book_keeping_additional_needs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keeping_additional_needs
    ADD CONSTRAINT book_keeping_additional_needs_pkey PRIMARY KEY (id);


--
-- Name: book_keeping_annual_revenues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keeping_annual_revenues
    ADD CONSTRAINT book_keeping_annual_revenues_pkey PRIMARY KEY (id);


--
-- Name: book_keeping_classify_inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keeping_classify_inventories
    ADD CONSTRAINT book_keeping_classify_inventories_pkey PRIMARY KEY (id);


--
-- Name: book_keeping_industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keeping_industries
    ADD CONSTRAINT book_keeping_industries_pkey PRIMARY KEY (id);


--
-- Name: book_keeping_number_employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keeping_number_employees
    ADD CONSTRAINT book_keeping_number_employees_pkey PRIMARY KEY (id);


--
-- Name: book_keeping_transaction_volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keeping_transaction_volumes
    ADD CONSTRAINT book_keeping_transaction_volumes_pkey PRIMARY KEY (id);


--
-- Name: book_keeping_type_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keeping_type_clients
    ADD CONSTRAINT book_keeping_type_clients_pkey PRIMARY KEY (id);


--
-- Name: book_keepings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.book_keepings
    ADD CONSTRAINT book_keepings_pkey PRIMARY KEY (id);


--
-- Name: business_entity_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_entity_types
    ADD CONSTRAINT business_entity_types_pkey PRIMARY KEY (id);


--
-- Name: business_foreign_account_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_foreign_account_counts
    ADD CONSTRAINT business_foreign_account_counts_pkey PRIMARY KEY (id);


--
-- Name: business_foreign_ownership_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_foreign_ownership_counts
    ADD CONSTRAINT business_foreign_ownership_counts_pkey PRIMARY KEY (id);


--
-- Name: business_industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_industries
    ADD CONSTRAINT business_industries_pkey PRIMARY KEY (id);


--
-- Name: business_llc_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_llc_types
    ADD CONSTRAINT business_llc_types_pkey PRIMARY KEY (id);


--
-- Name: business_number_employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_number_employees
    ADD CONSTRAINT business_number_employees_pkey PRIMARY KEY (id);


--
-- Name: business_tax_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_tax_returns
    ADD CONSTRAINT business_tax_returns_pkey PRIMARY KEY (id);


--
-- Name: business_total_revenues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_total_revenues
    ADD CONSTRAINT business_total_revenues_pkey PRIMARY KEY (id);


--
-- Name: business_transaction_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.business_transaction_counts
    ADD CONSTRAINT business_transaction_counts_pkey PRIMARY KEY (id);


--
-- Name: deleted_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.deleted_users
    ADD CONSTRAINT deleted_users_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_pkey PRIMARY KEY (id);


--
-- Name: faq_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.faq_categories
    ADD CONSTRAINT faq_categories_pkey PRIMARY KEY (id);


--
-- Name: faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: individual_employment_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.individual_employment_statuses
    ADD CONSTRAINT individual_employment_statuses_pkey PRIMARY KEY (id);


--
-- Name: individual_filing_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.individual_filing_statuses
    ADD CONSTRAINT individual_filing_statuses_pkey PRIMARY KEY (id);


--
-- Name: individual_foreign_account_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.individual_foreign_account_counts
    ADD CONSTRAINT individual_foreign_account_counts_pkey PRIMARY KEY (id);


--
-- Name: individual_industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.individual_industries
    ADD CONSTRAINT individual_industries_pkey PRIMARY KEY (id);


--
-- Name: individual_itemized_deductions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.individual_itemized_deductions
    ADD CONSTRAINT individual_itemized_deductions_pkey PRIMARY KEY (id);


--
-- Name: individual_stock_transaction_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.individual_stock_transaction_counts
    ADD CONSTRAINT individual_stock_transaction_counts_pkey PRIMARY KEY (id);


--
-- Name: individual_tax_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.individual_tax_returns
    ADD CONSTRAINT individual_tax_returns_pkey PRIMARY KEY (id);


--
-- Name: languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: match_value_relates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.match_value_relates
    ADD CONSTRAINT match_value_relates_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);


--
-- Name: platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_pkey PRIMARY KEY (id);


--
-- Name: press_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.press_articles
    ADD CONSTRAINT press_articles_pkey PRIMARY KEY (id);


--
-- Name: pro_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.pro_ratings
    ADD CONSTRAINT pro_ratings_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: sale_tax_frequencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.sale_tax_frequencies
    ADD CONSTRAINT sale_tax_frequencies_pkey PRIMARY KEY (id);


--
-- Name: sale_tax_industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.sale_tax_industries
    ADD CONSTRAINT sale_tax_industries_pkey PRIMARY KEY (id);


--
-- Name: sale_taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.sale_taxes
    ADD CONSTRAINT sale_taxes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: service_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.service_links
    ADD CONSTRAINT service_links_pkey PRIMARY KEY (id);


--
-- Name: service_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_pkey PRIMARY KEY (id);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (id);


--
-- Name: universities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (id);


--
-- Name: us_zipcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.us_zipcodes
    ADD CONSTRAINT us_zipcodes_pkey PRIMARY KEY (id);


--
-- Name: users_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.users_languages
    ADD CONSTRAINT users_languages_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vacancies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.vacancies
    ADD CONSTRAINT vacancies_pkey PRIMARY KEY (id);


--
-- Name: work_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.work_experiences
    ADD CONSTRAINT work_experiences_pkey PRIMARY KEY (id);


--
-- Name: accounting_softwares_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX accounting_softwares_user_id_index ON public.accounting_softwares USING btree (user_id);


--
-- Name: addons_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX addons_user_id_index ON public.addons USING btree (user_id);


--
-- Name: book_keeping_additional_needs_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keeping_additional_needs_book_keeping_id_index ON public.book_keeping_additional_needs USING btree (book_keeping_id);


--
-- Name: book_keeping_annual_revenues_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keeping_annual_revenues_book_keeping_id_index ON public.book_keeping_annual_revenues USING btree (book_keeping_id);


--
-- Name: book_keeping_classify_inventories_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keeping_classify_inventories_book_keeping_id_index ON public.book_keeping_classify_inventories USING btree (book_keeping_id);


--
-- Name: book_keeping_industries_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keeping_industries_book_keeping_id_index ON public.book_keeping_industries USING btree (book_keeping_id);


--
-- Name: book_keeping_number_employees_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keeping_number_employees_book_keeping_id_index ON public.book_keeping_number_employees USING btree (book_keeping_id);


--
-- Name: book_keeping_transaction_volumes_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keeping_transaction_volumes_book_keeping_id_index ON public.book_keeping_transaction_volumes USING btree (book_keeping_id);


--
-- Name: book_keeping_type_clients_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keeping_type_clients_book_keeping_id_index ON public.book_keeping_type_clients USING btree (book_keeping_id);


--
-- Name: book_keepings_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX book_keepings_user_id_index ON public.book_keepings USING btree (user_id);


--
-- Name: business_entity_types_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_entity_types_business_tax_return_id_index ON public.business_entity_types USING btree (business_tax_return_id);


--
-- Name: business_foreign_account_counts_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_foreign_account_counts_business_tax_return_id_index ON public.business_foreign_account_counts USING btree (business_tax_return_id);


--
-- Name: business_foreign_ownership_counts_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_foreign_ownership_counts_business_tax_return_id_index ON public.business_foreign_ownership_counts USING btree (business_tax_return_id);


--
-- Name: business_industries_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_industries_business_tax_return_id_index ON public.business_industries USING btree (business_tax_return_id);


--
-- Name: business_llc_types_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_llc_types_business_tax_return_id_index ON public.business_llc_types USING btree (business_tax_return_id);


--
-- Name: business_number_employees_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_number_employees_business_tax_return_id_index ON public.business_number_employees USING btree (business_tax_return_id);


--
-- Name: business_tax_returns_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_tax_returns_user_id_index ON public.business_tax_returns USING btree (user_id);


--
-- Name: business_total_revenues_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_total_revenues_business_tax_return_id_index ON public.business_total_revenues USING btree (business_tax_return_id);


--
-- Name: business_transaction_counts_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX business_transaction_counts_business_tax_return_id_index ON public.business_transaction_counts USING btree (business_tax_return_id);


--
-- Name: deleted_users_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX deleted_users_user_id_index ON public.deleted_users USING btree (user_id);


--
-- Name: documents_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX documents_user_id_index ON public.documents USING btree (user_id);


--
-- Name: educations_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX educations_user_id_index ON public.educations USING btree (user_id);


--
-- Name: faq_categories_title_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX faq_categories_title_index ON public.faq_categories USING btree (title);


--
-- Name: faqs_faq_category_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX faqs_faq_category_id_index ON public.faqs USING btree (faq_category_id);


--
-- Name: individual_employment_statuses_individual_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_employment_statuses_individual_tax_return_id_index ON public.individual_employment_statuses USING btree (individual_tax_return_id);


--
-- Name: individual_filing_statuses_individual_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_filing_statuses_individual_tax_return_id_index ON public.individual_filing_statuses USING btree (individual_tax_return_id);


--
-- Name: individual_foreign_account_counts_individual_tax_return_id_inde; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_foreign_account_counts_individual_tax_return_id_inde ON public.individual_foreign_account_counts USING btree (individual_tax_return_id);


--
-- Name: individual_industries_individual_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_industries_individual_tax_return_id_index ON public.individual_industries USING btree (individual_tax_return_id);


--
-- Name: individual_itemized_deductions_individual_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_itemized_deductions_individual_tax_return_id_index ON public.individual_itemized_deductions USING btree (individual_tax_return_id);


--
-- Name: individual_stock_transaction_counts_individual_tax_return_id_in; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_stock_transaction_counts_individual_tax_return_id_in ON public.individual_stock_transaction_counts USING btree (individual_tax_return_id);


--
-- Name: individual_tax_returns_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX individual_tax_returns_user_id_index ON public.individual_tax_returns USING btree (user_id);


--
-- Name: languages_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX languages_name_index ON public.languages USING btree (name);


--
-- Name: messages_room_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX messages_room_id_index ON public.messages USING btree (room_id);


--
-- Name: messages_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX messages_user_id_index ON public.messages USING btree (user_id);


--
-- Name: offers_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX offers_user_id_index ON public.offers USING btree (user_id);


--
-- Name: pictures_profile_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pictures_profile_id_index ON public.pictures USING btree (profile_id);


--
-- Name: platforms_ban_reason_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX platforms_ban_reason_id_index ON public.platforms USING btree (ban_reason_id);


--
-- Name: platforms_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX platforms_user_id_index ON public.platforms USING btree (user_id);


--
-- Name: pro_ratings_platform_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pro_ratings_platform_id_index ON public.pro_ratings USING btree (platform_id);


--
-- Name: profiles_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX profiles_user_id_index ON public.profiles USING btree (user_id);


--
-- Name: projects_addon_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX projects_addon_id_index ON public.projects USING btree (addon_id);


--
-- Name: projects_offer_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX projects_offer_id_index ON public.projects USING btree (offer_id);


--
-- Name: projects_stripe_card_token_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX projects_stripe_card_token_id_index ON public.projects USING btree (stripe_card_token_id);


--
-- Name: projects_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX projects_user_id_index ON public.projects USING btree (user_id);


--
-- Name: reports_message_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX reports_message_id_index ON public.reports USING btree (message_id);


--
-- Name: rooms_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX rooms_user_id_index ON public.rooms USING btree (user_id);


--
-- Name: sale_tax_frequencies_sale_tax_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sale_tax_frequencies_sale_tax_id_index ON public.sale_tax_frequencies USING btree (sale_tax_id);


--
-- Name: sale_tax_industries_sale_tax_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sale_tax_industries_sale_tax_id_index ON public.sale_tax_industries USING btree (sale_tax_id);


--
-- Name: sale_taxes_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sale_taxes_user_id_index ON public.sale_taxes USING btree (user_id);


--
-- Name: service_links_book_keeping_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX service_links_book_keeping_id_index ON public.service_links USING btree (book_keeping_id);


--
-- Name: service_links_business_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX service_links_business_tax_return_id_index ON public.service_links USING btree (business_tax_return_id);


--
-- Name: service_links_individual_tax_return_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX service_links_individual_tax_return_id_index ON public.service_links USING btree (individual_tax_return_id);


--
-- Name: service_links_sale_tax_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX service_links_sale_tax_id_index ON public.service_links USING btree (sale_tax_id);


--
-- Name: subscribers_email_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX subscribers_email_index ON public.subscribers USING btree (email);


--
-- Name: universities_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX universities_name_index ON public.universities USING btree (name);


--
-- Name: universities_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX universities_user_id_index ON public.educations USING btree (university_id);


--
-- Name: user_id_language_id_unique_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX user_id_language_id_unique_index ON public.users_languages USING btree (user_id, language_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_languages_language_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_languages_language_id_index ON public.users_languages USING btree (language_id);


--
-- Name: users_languages_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_languages_user_id_index ON public.users_languages USING btree (user_id);


--
-- Name: work_experiences_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX work_experiences_user_id_index ON public.work_experiences USING btree (user_id);


--
-- Name: accounting_softwares_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounting_softwares
    ADD CONSTRAINT accounting_softwares_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: addons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addons
    ADD CONSTRAINT addons_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: book_keeping_additional_needs_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keeping_additional_needs
    ADD CONSTRAINT book_keeping_additional_needs_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: book_keeping_annual_revenues_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keeping_annual_revenues
    ADD CONSTRAINT book_keeping_annual_revenues_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: book_keeping_classify_inventories_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keeping_classify_inventories
    ADD CONSTRAINT book_keeping_classify_inventories_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: book_keeping_industries_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keeping_industries
    ADD CONSTRAINT book_keeping_industries_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: book_keeping_number_employees_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keeping_number_employees
    ADD CONSTRAINT book_keeping_number_employees_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: book_keeping_transaction_volumes_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keeping_transaction_volumes
    ADD CONSTRAINT book_keeping_transaction_volumes_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: book_keeping_type_clients_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keeping_type_clients
    ADD CONSTRAINT book_keeping_type_clients_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: book_keepings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_keepings
    ADD CONSTRAINT book_keepings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: business_entity_types_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_entity_types
    ADD CONSTRAINT business_entity_types_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: business_foreign_account_counts_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_foreign_account_counts
    ADD CONSTRAINT business_foreign_account_counts_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: business_foreign_ownership_counts_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_foreign_ownership_counts
    ADD CONSTRAINT business_foreign_ownership_counts_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: business_industries_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_industries
    ADD CONSTRAINT business_industries_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: business_llc_types_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_llc_types
    ADD CONSTRAINT business_llc_types_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: business_number_employees_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_number_employees
    ADD CONSTRAINT business_number_employees_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: business_tax_returns_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_tax_returns
    ADD CONSTRAINT business_tax_returns_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: business_total_revenues_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_total_revenues
    ADD CONSTRAINT business_total_revenues_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: business_transaction_counts_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_transaction_counts
    ADD CONSTRAINT business_transaction_counts_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: deleted_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_users
    ADD CONSTRAINT deleted_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: documents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: educations_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE;


--
-- Name: educations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: faqs_faq_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_faq_category_id_fkey FOREIGN KEY (faq_category_id) REFERENCES public.faq_categories(id) ON DELETE CASCADE;


--
-- Name: individual_employment_statuses_individual_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individual_employment_statuses
    ADD CONSTRAINT individual_employment_statuses_individual_tax_return_id_fkey FOREIGN KEY (individual_tax_return_id) REFERENCES public.individual_tax_returns(id) ON DELETE CASCADE;


--
-- Name: individual_filing_statuses_individual_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individual_filing_statuses
    ADD CONSTRAINT individual_filing_statuses_individual_tax_return_id_fkey FOREIGN KEY (individual_tax_return_id) REFERENCES public.individual_tax_returns(id) ON DELETE CASCADE;


--
-- Name: individual_foreign_account_counts_individual_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individual_foreign_account_counts
    ADD CONSTRAINT individual_foreign_account_counts_individual_tax_return_id_fkey FOREIGN KEY (individual_tax_return_id) REFERENCES public.individual_tax_returns(id) ON DELETE CASCADE;


--
-- Name: individual_industries_individual_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individual_industries
    ADD CONSTRAINT individual_industries_individual_tax_return_id_fkey FOREIGN KEY (individual_tax_return_id) REFERENCES public.individual_tax_returns(id) ON DELETE CASCADE;


--
-- Name: individual_itemized_deductions_individual_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individual_itemized_deductions
    ADD CONSTRAINT individual_itemized_deductions_individual_tax_return_id_fkey FOREIGN KEY (individual_tax_return_id) REFERENCES public.individual_tax_returns(id) ON DELETE CASCADE;


--
-- Name: individual_stock_transaction_counts_individual_tax_return_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individual_stock_transaction_counts
    ADD CONSTRAINT individual_stock_transaction_counts_individual_tax_return_id_fk FOREIGN KEY (individual_tax_return_id) REFERENCES public.individual_tax_returns(id) ON DELETE CASCADE;


--
-- Name: individual_tax_returns_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individual_tax_returns
    ADD CONSTRAINT individual_tax_returns_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: offers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: pictures_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pictures
    ADD CONSTRAINT pictures_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: platforms_ban_reason_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_ban_reason_id_fkey FOREIGN KEY (ban_reason_id) REFERENCES public.ban_reasons(id) ON DELETE SET NULL;


--
-- Name: platforms_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: pro_ratings_platform_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pro_ratings
    ADD CONSTRAINT pro_ratings_platform_id_fkey FOREIGN KEY (platform_id) REFERENCES public.platforms(id) ON DELETE CASCADE;


--
-- Name: profiles_us_zipcode_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_us_zipcode_id_fkey FOREIGN KEY (us_zipcode_id) REFERENCES public.us_zipcodes(id) ON DELETE CASCADE;


--
-- Name: profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: projects_addon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_addon_id_fkey FOREIGN KEY (addon_id) REFERENCES public.addons(id) ON DELETE SET NULL;


--
-- Name: projects_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE SET NULL;


--
-- Name: projects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reports_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: rooms_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sale_tax_frequencies_sale_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_tax_frequencies
    ADD CONSTRAINT sale_tax_frequencies_sale_tax_id_fkey FOREIGN KEY (sale_tax_id) REFERENCES public.sale_taxes(id) ON DELETE CASCADE;


--
-- Name: sale_tax_industries_sale_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_tax_industries
    ADD CONSTRAINT sale_tax_industries_sale_tax_id_fkey FOREIGN KEY (sale_tax_id) REFERENCES public.sale_taxes(id) ON DELETE CASCADE;


--
-- Name: sale_taxes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_taxes
    ADD CONSTRAINT sale_taxes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: service_links_book_keeping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_links
    ADD CONSTRAINT service_links_book_keeping_id_fkey FOREIGN KEY (book_keeping_id) REFERENCES public.book_keepings(id) ON DELETE CASCADE;


--
-- Name: service_links_business_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_links
    ADD CONSTRAINT service_links_business_tax_return_id_fkey FOREIGN KEY (business_tax_return_id) REFERENCES public.business_tax_returns(id) ON DELETE CASCADE;


--
-- Name: service_links_individual_tax_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_links
    ADD CONSTRAINT service_links_individual_tax_return_id_fkey FOREIGN KEY (individual_tax_return_id) REFERENCES public.individual_tax_returns(id) ON DELETE CASCADE;


--
-- Name: service_links_sale_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_links
    ADD CONSTRAINT service_links_sale_tax_id_fkey FOREIGN KEY (sale_tax_id) REFERENCES public.sale_taxes(id) ON DELETE CASCADE;


--
-- Name: users_languages_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_languages
    ADD CONSTRAINT users_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- Name: users_languages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_languages
    ADD CONSTRAINT users_languages_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: work_experiences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_experiences
    ADD CONSTRAINT work_experiences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20200122105003);
INSERT INTO public."schema_migrations" (version) VALUES (20200122105123);
INSERT INTO public."schema_migrations" (version) VALUES (20200122105355);
INSERT INTO public."schema_migrations" (version) VALUES (20200122105757);
INSERT INTO public."schema_migrations" (version) VALUES (20200122110042);
INSERT INTO public."schema_migrations" (version) VALUES (20200128130133);
INSERT INTO public."schema_migrations" (version) VALUES (20200128161601);
INSERT INTO public."schema_migrations" (version) VALUES (20200129081948);
INSERT INTO public."schema_migrations" (version) VALUES (20200129180858);
INSERT INTO public."schema_migrations" (version) VALUES (20200206081607);
INSERT INTO public."schema_migrations" (version) VALUES (20200206155920);
INSERT INTO public."schema_migrations" (version) VALUES (20200208193510);
INSERT INTO public."schema_migrations" (version) VALUES (20200420090128);
INSERT INTO public."schema_migrations" (version) VALUES (20200420090136);
INSERT INTO public."schema_migrations" (version) VALUES (20200423074140);
INSERT INTO public."schema_migrations" (version) VALUES (20200423172347);
INSERT INTO public."schema_migrations" (version) VALUES (20200423172354);
INSERT INTO public."schema_migrations" (version) VALUES (20200423172359);
INSERT INTO public."schema_migrations" (version) VALUES (20200423172400);
INSERT INTO public."schema_migrations" (version) VALUES (20200423172405);
INSERT INTO public."schema_migrations" (version) VALUES (20200423172411);
INSERT INTO public."schema_migrations" (version) VALUES (20200428064957);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065000);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065008);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065014);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065018);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065023);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065028);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065029);
INSERT INTO public."schema_migrations" (version) VALUES (20200428065033);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065742);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065755);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065809);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065820);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065827);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065834);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065843);
INSERT INTO public."schema_migrations" (version) VALUES (20200430065901);
INSERT INTO public."schema_migrations" (version) VALUES (20200501100525);
INSERT INTO public."schema_migrations" (version) VALUES (20200501100530);
INSERT INTO public."schema_migrations" (version) VALUES (20200501100537);
INSERT INTO public."schema_migrations" (version) VALUES (20200608091525);
INSERT INTO public."schema_migrations" (version) VALUES (20200608091900);
INSERT INTO public."schema_migrations" (version) VALUES (20200702032531);
INSERT INTO public."schema_migrations" (version) VALUES (20200702033550);
INSERT INTO public."schema_migrations" (version) VALUES (20200702033954);
INSERT INTO public."schema_migrations" (version) VALUES (20200702034915);
INSERT INTO public."schema_migrations" (version) VALUES (20201010115608);
INSERT INTO public."schema_migrations" (version) VALUES (20201011140423);
INSERT INTO public."schema_migrations" (version) VALUES (20201013141458);
INSERT INTO public."schema_migrations" (version) VALUES (20201015130716);
INSERT INTO public."schema_migrations" (version) VALUES (20201016122206);
INSERT INTO public."schema_migrations" (version) VALUES (20201016150308);
INSERT INTO public."schema_migrations" (version) VALUES (20201017093424);
INSERT INTO public."schema_migrations" (version) VALUES (20201017093710);
INSERT INTO public."schema_migrations" (version) VALUES (20201017153818);
INSERT INTO public."schema_migrations" (version) VALUES (20201019070828);
INSERT INTO public."schema_migrations" (version) VALUES (20201019081457);
