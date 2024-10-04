--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: All_Recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."All_Recipes" (
    id integer NOT NULL,
    name text,
    ingredients text,
    ingredients_raw_str text,
    serving_size text,
    servings integer,
    steps text,
    tags text,
    search_terms text
);


ALTER TABLE public."All_Recipes" OWNER TO postgres;

--
-- Name: All_Recipes Recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."All_Recipes"
    ADD CONSTRAINT "Recipes_pkey" PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

