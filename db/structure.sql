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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: health_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.health_metrics (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    height numeric(5,2),
    weight numeric(5,2),
    bmi numeric(5,2),
    hydration integer,
    muscle_mass numeric(5,2),
    caloric_intake integer,
    caloric_burn integer,
    steps integer,
    sleep_quality integer,
    resting_heart_rate integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: health_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: health_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_metrics_id_seq OWNED BY public.health_metrics.id;


--
-- Name: member_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.member_sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    training_session_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: member_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.member_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: member_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.member_sessions_id_seq OWNED BY public.member_sessions.id;


--
-- Name: room_bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_bookings (
    id bigint NOT NULL,
    room_name integer DEFAULT 0 NOT NULL,
    location text,
    booking_time timestamp(6) without time zone DEFAULT (date_trunc('hour'::text, CURRENT_TIMESTAMP) + '01:00:00'::interval) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: room_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.room_bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: room_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.room_bookings_id_seq OWNED BY public.room_bookings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: training_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_sessions (
    id bigint NOT NULL,
    name integer DEFAULT 0 NOT NULL,
    description text,
    user_id bigint NOT NULL,
    room_booking_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: training_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.training_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.training_sessions_id_seq OWNED BY public.training_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    email character varying NOT NULL,
    role integer DEFAULT 0 NOT NULL,
    date_of_birth date NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: health_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_metrics ALTER COLUMN id SET DEFAULT nextval('public.health_metrics_id_seq'::regclass);


--
-- Name: member_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_sessions ALTER COLUMN id SET DEFAULT nextval('public.member_sessions_id_seq'::regclass);


--
-- Name: room_bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_bookings ALTER COLUMN id SET DEFAULT nextval('public.room_bookings_id_seq'::regclass);


--
-- Name: training_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_sessions ALTER COLUMN id SET DEFAULT nextval('public.training_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: health_metrics health_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_metrics
    ADD CONSTRAINT health_metrics_pkey PRIMARY KEY (id);


--
-- Name: member_sessions member_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_sessions
    ADD CONSTRAINT member_sessions_pkey PRIMARY KEY (id);


--
-- Name: room_bookings room_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_bookings
    ADD CONSTRAINT room_bookings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: training_sessions training_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_sessions
    ADD CONSTRAINT training_sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_health_metrics_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_metrics_on_user_id ON public.health_metrics USING btree (user_id);


--
-- Name: index_member_sessions_on_training_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_member_sessions_on_training_session_id ON public.member_sessions USING btree (training_session_id);


--
-- Name: index_member_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_member_sessions_on_user_id ON public.member_sessions USING btree (user_id);


--
-- Name: index_training_sessions_on_room_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_sessions_on_room_booking_id ON public.training_sessions USING btree (room_booking_id);


--
-- Name: index_training_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_sessions_on_user_id ON public.training_sessions USING btree (user_id);


--
-- Name: training_sessions fk_rails_0262e2cdf0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_sessions
    ADD CONSTRAINT fk_rails_0262e2cdf0 FOREIGN KEY (room_booking_id) REFERENCES public.room_bookings(id);


--
-- Name: member_sessions fk_rails_3da5dc37d9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_sessions
    ADD CONSTRAINT fk_rails_3da5dc37d9 FOREIGN KEY (training_session_id) REFERENCES public.training_sessions(id);


--
-- Name: health_metrics fk_rails_7789235dad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_metrics
    ADD CONSTRAINT fk_rails_7789235dad FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: training_sessions fk_rails_7dfd856521; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_sessions
    ADD CONSTRAINT fk_rails_7dfd856521 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: member_sessions fk_rails_9aa185dc67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_sessions
    ADD CONSTRAINT fk_rails_9aa185dc67 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240414013126'),
('20240413153526'),
('20240413153335'),
('20240412211113'),
('20240412013014');

