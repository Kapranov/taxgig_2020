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
    content character varying(255),
    faq_category_id uuid NOT NULL,
    title character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.languages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255),
    abbr character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: press_articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.press_articles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    author character varying(255),
    preview_text character varying(255),
    title character varying(255),
    url character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    img_url character varying(255)
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
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
    admin_role boolean,
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
    pro_role boolean,
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
    content character varying(255),
    department character varying(255),
    title character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


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
-- Name: languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: press_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.press_articles
    ADD CONSTRAINT press_articles_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id, user_id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (id);


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
-- Name: faq_categories_title_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX faq_categories_title_index ON public.faq_categories USING btree (title);


--
-- Name: faqs_faq_category_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX faqs_faq_category_id_index ON public.faqs USING btree (faq_category_id);


--
-- Name: languages_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX languages_name_index ON public.languages USING btree (name);


--
-- Name: profiles_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX profiles_user_id_index ON public.profiles USING btree (user_id);


--
-- Name: subscribers_email_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX subscribers_email_index ON public.subscribers USING btree (email);


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
-- Name: faqs_faq_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_faq_category_id_fkey FOREIGN KEY (faq_category_id) REFERENCES public.faq_categories(id) ON DELETE CASCADE;


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
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20200122105003), (20200122105123), (20200122105355), (20200122105757), (20200122110042), (20200128082230), (20200128130133), (20200128161601), (20200129081948), (20200129180858), (20200206081607), (20200206155920);

