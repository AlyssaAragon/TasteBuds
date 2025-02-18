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
-- Name: diet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diet (
    dietid integer NOT NULL,
    dietname character varying(100) NOT NULL
);


ALTER TABLE public.diet OWNER TO postgres;

--
-- Name: diet_dietid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diet_dietid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diet_dietid_seq OWNER TO postgres;

--
-- Name: diet_dietid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diet_dietid_seq OWNED BY public.diet.dietid;


--
-- Name: recipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe (
    recipeid integer NOT NULL,
    title character varying(255) NOT NULL,
    ingredients text,
    instructions text,
    image_name character varying(255),
    cleaned_ingredients text
);


ALTER TABLE public.recipe OWNER TO postgres;

--
-- Name: recipe_diet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe_diet (
    recipedietid integer NOT NULL,
    recipeid integer,
    dietid integer
);


ALTER TABLE public.recipe_diet OWNER TO postgres;

--
-- Name: recipe_diet_recipedietid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_diet_recipedietid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_diet_recipedietid_seq OWNER TO postgres;

--
-- Name: recipe_diet_recipedietid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_diet_recipedietid_seq OWNED BY public.recipe_diet.recipedietid;


--
-- Name: recipe_recipeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_recipeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_recipeid_seq OWNER TO postgres;

--
-- Name: recipe_recipeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_recipeid_seq OWNED BY public.recipe.recipeid;


--
-- Name: saved_recipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_recipe (
    savedid integer NOT NULL,
    userid integer,
    recipeid integer
);


ALTER TABLE public.saved_recipe OWNER TO postgres;

--
-- Name: saved_recipe_savedid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.saved_recipe_savedid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.saved_recipe_savedid_seq OWNER TO postgres;

--
-- Name: saved_recipe_savedid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.saved_recipe_savedid_seq OWNED BY public.saved_recipe.savedid;


--
-- Name: user_diet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_diet (
    userdietid integer NOT NULL,
    userid integer,
    dietid integer
);


ALTER TABLE public.user_diet OWNER TO postgres;

--
-- Name: user_diet_userdietid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_diet_userdietid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_diet_userdietid_seq OWNER TO postgres;

--
-- Name: user_diet_userdietid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_diet_userdietid_seq OWNED BY public.user_diet.userdietid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    firstlastname character varying(100) NOT NULL,
    password text NOT NULL,
    partnerid integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_userid_seq OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- Name: diet dietid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diet ALTER COLUMN dietid SET DEFAULT nextval('public.diet_dietid_seq'::regclass);


--
-- Name: recipe recipeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe ALTER COLUMN recipeid SET DEFAULT nextval('public.recipe_recipeid_seq'::regclass);


--
-- Name: recipe_diet recipedietid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_diet ALTER COLUMN recipedietid SET DEFAULT nextval('public.recipe_diet_recipedietid_seq'::regclass);


--
-- Name: saved_recipe savedid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_recipe ALTER COLUMN savedid SET DEFAULT nextval('public.saved_recipe_savedid_seq'::regclass);


--
-- Name: user_diet userdietid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_diet ALTER COLUMN userdietid SET DEFAULT nextval('public.user_diet_userdietid_seq'::regclass);


--
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- Name: diet diet_dietname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diet
    ADD CONSTRAINT diet_dietname_key UNIQUE (dietname);


--
-- Name: diet diet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diet
    ADD CONSTRAINT diet_pkey PRIMARY KEY (dietid);


--
-- Name: recipe_diet recipe_diet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_diet
    ADD CONSTRAINT recipe_diet_pkey PRIMARY KEY (recipedietid);


--
-- Name: recipe recipe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe
    ADD CONSTRAINT recipe_pkey PRIMARY KEY (recipeid);


--
-- Name: saved_recipe saved_recipe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_recipe
    ADD CONSTRAINT saved_recipe_pkey PRIMARY KEY (savedid);


--
-- Name: user_diet user_diet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_diet
    ADD CONSTRAINT user_diet_pkey PRIMARY KEY (userdietid);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: recipe_diet recipe_diet_dietid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_diet
    ADD CONSTRAINT recipe_diet_dietid_fkey FOREIGN KEY (dietid) REFERENCES public.diet(dietid) ON DELETE CASCADE;


--
-- Name: recipe_diet recipe_diet_recipeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_diet
    ADD CONSTRAINT recipe_diet_recipeid_fkey FOREIGN KEY (recipeid) REFERENCES public.recipe(recipeid) ON DELETE CASCADE;


--
-- Name: saved_recipe saved_recipe_recipeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_recipe
    ADD CONSTRAINT saved_recipe_recipeid_fkey FOREIGN KEY (recipeid) REFERENCES public.recipe(recipeid) ON DELETE CASCADE;


--
-- Name: saved_recipe saved_recipe_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_recipe
    ADD CONSTRAINT saved_recipe_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- Name: user_diet user_diet_dietid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_diet
    ADD CONSTRAINT user_diet_dietid_fkey FOREIGN KEY (dietid) REFERENCES public.diet(dietid) ON DELETE CASCADE;


--
-- Name: user_diet user_diet_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_diet
    ADD CONSTRAINT user_diet_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- Name: users users_partnerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_partnerid_fkey FOREIGN KEY (partnerid) REFERENCES public.users(userid) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

