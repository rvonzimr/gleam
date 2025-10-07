\restrict XoOWttOloCAhXZFkEO5EHgXNNaoSn30Vi4fW36HOLQnansCzM4zbAEJpJxgPsgX

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: groceries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groceries (
    id integer NOT NULL,
    name text NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    purchased boolean DEFAULT false NOT NULL,
    list_id integer NOT NULL
);


--
-- Name: grocery_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grocery_lists (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: groceries groceries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groceries
    ADD CONSTRAINT groceries_pkey PRIMARY KEY (id);


--
-- Name: grocery_lists grocery_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grocery_lists
    ADD CONSTRAINT grocery_lists_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: groceries groceries_list_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groceries
    ADD CONSTRAINT groceries_list_id_fkey FOREIGN KEY (list_id) REFERENCES public.grocery_lists(id);


--
-- PostgreSQL database dump complete
--

\unrestrict XoOWttOloCAhXZFkEO5EHgXNNaoSn30Vi4fW36HOLQnansCzM4zbAEJpJxgPsgX


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20251007042243'),
    ('20251007061025');
