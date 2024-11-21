--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Postgres.app)
-- Dumped by pg_dump version 17.0

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

--
-- Name: enforce_rental_quota(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enforce_rental_quota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (SELECT COUNT(*) 
        FROM Instrument_Rental 
        WHERE student_id = NEW.student_id AND end_date IS NULL) >= 2 THEN
        RAISE EXCEPTION 'Rental quota exceeded. A student cannot rent more than 2 instruments.';
    END IF;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: available_time_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.available_time_slots (
    timeslot_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL
);


--
-- Name: available_time_slots_timeslot_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.available_time_slots_timeslot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: available_time_slots_timeslot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.available_time_slots_timeslot_id_seq OWNED BY public.available_time_slots.timeslot_id;


--
-- Name: ensemblelesson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ensemblelesson (
    lesson_id integer NOT NULL,
    genre character varying(50) NOT NULL,
    min_amount_students integer NOT NULL,
    max_amount_students integer NOT NULL
);


--
-- Name: grouplesson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grouplesson (
    lesson_id integer NOT NULL,
    instrument_type character varying(50) NOT NULL,
    min_amount_students integer NOT NULL,
    max_amount_students integer NOT NULL,
    skill_level character varying(20) NOT NULL
);


--
-- Name: individuallesson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.individuallesson (
    lesson_id integer NOT NULL,
    instrument_type character varying(50) NOT NULL,
    skill_level character varying(20) NOT NULL
);


--
-- Name: instructor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.instructor (
    instructor_id integer NOT NULL,
    name character varying(100) NOT NULL,
    salary numeric(10,2) NOT NULL,
    canteachensemble boolean NOT NULL,
    personal_identity_number character varying(20) NOT NULL,
    phone_number character varying(15) NOT NULL,
    email character varying(100),
    zip character(10),
    city character varying(100),
    street character varying(100)
);


--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.instructor_instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.instructor_instructor_id_seq OWNED BY public.instructor.instructor_id;


--
-- Name: instructor_instruments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.instructor_instruments (
    instructor_id integer NOT NULL,
    instrument_id integer NOT NULL
);


--
-- Name: instructor_timeslot; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.instructor_timeslot (
    instructor_id integer NOT NULL,
    timeslot_id integer NOT NULL
);


--
-- Name: instrument; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.instrument (
    instrument_id integer NOT NULL,
    instrument_number character varying(20) NOT NULL,
    instrument_type character varying(50) NOT NULL,
    instrument_brand character varying(50),
    is_available boolean NOT NULL
);


--
-- Name: instrument_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.instrument_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instrument_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.instrument_instrument_id_seq OWNED BY public.instrument.instrument_id;


--
-- Name: instrument_rental; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.instrument_rental (
    rental_id integer NOT NULL,
    student_id integer NOT NULL,
    instrument_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    rental_price numeric(10,2) NOT NULL
);


--
-- Name: instrument_rental_rental_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.instrument_rental_rental_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instrument_rental_rental_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.instrument_rental_rental_id_seq OWNED BY public.instrument_rental.rental_id;


--
-- Name: is_sibling_of; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.is_sibling_of (
    student_id_1 integer NOT NULL,
    student_id_2 integer NOT NULL
);


--
-- Name: lesson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lesson (
    lesson_id integer NOT NULL,
    lesson_number character varying(20) NOT NULL,
    room_id integer NOT NULL,
    capacity integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    date date NOT NULL,
    instructor_id integer NOT NULL,
    pricing_scheme_id integer NOT NULL
);


--
-- Name: lesson_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lesson_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lesson_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lesson_lesson_id_seq OWNED BY public.lesson.lesson_id;


--
-- Name: pricingscheme; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pricingscheme (
    pricing_scheme_id integer NOT NULL,
    pricing_id character varying(20) NOT NULL,
    lesson_type character varying(50) NOT NULL,
    skill_level_type character varying(50) NOT NULL,
    price numeric(10,2) NOT NULL,
    valid_from date NOT NULL
);


--
-- Name: pricingscheme_pricing_scheme_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pricingscheme_pricing_scheme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pricingscheme_pricing_scheme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pricingscheme_pricing_scheme_id_seq OWNED BY public.pricingscheme.pricing_scheme_id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student (
    student_id integer NOT NULL,
    student_number character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    phone_number character varying(15) NOT NULL,
    email character varying(100),
    personal_identity_number character varying(20) NOT NULL,
    zip character(10),
    city character varying(100),
    street character varying(100),
    total_discount numeric(5,2),
    rental_quota integer NOT NULL,
    number_of_lessons_taken integer
);


--
-- Name: student_lesson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_lesson (
    student_id integer NOT NULL,
    lesson_id integer NOT NULL,
    enrollment_date timestamp without time zone NOT NULL
);


--
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_student_id_seq OWNED BY public.student.student_id;


--
-- Name: available_time_slots timeslot_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_time_slots ALTER COLUMN timeslot_id SET DEFAULT nextval('public.available_time_slots_timeslot_id_seq'::regclass);


--
-- Name: instructor instructor_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor ALTER COLUMN instructor_id SET DEFAULT nextval('public.instructor_instructor_id_seq'::regclass);


--
-- Name: instrument instrument_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instrument ALTER COLUMN instrument_id SET DEFAULT nextval('public.instrument_instrument_id_seq'::regclass);


--
-- Name: instrument_rental rental_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instrument_rental ALTER COLUMN rental_id SET DEFAULT nextval('public.instrument_rental_rental_id_seq'::regclass);


--
-- Name: lesson lesson_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson ALTER COLUMN lesson_id SET DEFAULT nextval('public.lesson_lesson_id_seq'::regclass);


--
-- Name: pricingscheme pricing_scheme_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricingscheme ALTER COLUMN pricing_scheme_id SET DEFAULT nextval('public.pricingscheme_pricing_scheme_id_seq'::regclass);


--
-- Name: student student_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student ALTER COLUMN student_id SET DEFAULT nextval('public.student_student_id_seq'::regclass);


--
-- Name: available_time_slots available_time_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_time_slots
    ADD CONSTRAINT available_time_slots_pkey PRIMARY KEY (timeslot_id);


--
-- Name: ensemblelesson ensemblelesson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ensemblelesson
    ADD CONSTRAINT ensemblelesson_pkey PRIMARY KEY (lesson_id);


--
-- Name: grouplesson grouplesson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grouplesson
    ADD CONSTRAINT grouplesson_pkey PRIMARY KEY (lesson_id);


--
-- Name: individuallesson individuallesson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individuallesson
    ADD CONSTRAINT individuallesson_pkey PRIMARY KEY (lesson_id);


--
-- Name: instructor_instruments instructor_instruments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_pkey PRIMARY KEY (instructor_id, instrument_id);


--
-- Name: instructor instructor_personal_identity_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_personal_identity_number_key UNIQUE (personal_identity_number);


--
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (instructor_id);


--
-- Name: instructor_timeslot instructor_timeslot_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_pkey PRIMARY KEY (instructor_id, timeslot_id);


--
-- Name: instrument instrument_instrument_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_instrument_number_key UNIQUE (instrument_number);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (instrument_id);


--
-- Name: instrument_rental instrument_rental_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_pkey PRIMARY KEY (rental_id);


--
-- Name: is_sibling_of is_sibling_of_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.is_sibling_of
    ADD CONSTRAINT is_sibling_of_pkey PRIMARY KEY (student_id_1, student_id_2);


--
-- Name: lesson lesson_lesson_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_lesson_number_key UNIQUE (lesson_number);


--
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (lesson_id);


--
-- Name: pricingscheme pricingscheme_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricingscheme
    ADD CONSTRAINT pricingscheme_pkey PRIMARY KEY (pricing_scheme_id);


--
-- Name: pricingscheme pricingscheme_pricing_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricingscheme
    ADD CONSTRAINT pricingscheme_pricing_id_key UNIQUE (pricing_id);


--
-- Name: student_lesson student_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_pkey PRIMARY KEY (student_id, lesson_id);


--
-- Name: student student_personal_identity_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_personal_identity_number_key UNIQUE (personal_identity_number);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- Name: student student_student_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_student_number_key UNIQUE (student_number);


--
-- Name: instrument_rental rental_quota_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER rental_quota_trigger BEFORE INSERT ON public.instrument_rental FOR EACH ROW EXECUTE FUNCTION public.enforce_rental_quota();


--
-- Name: ensemblelesson ensemblelesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ensemblelesson
    ADD CONSTRAINT ensemblelesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- Name: grouplesson grouplesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grouplesson
    ADD CONSTRAINT grouplesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- Name: individuallesson individuallesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.individuallesson
    ADD CONSTRAINT individuallesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- Name: instructor_instruments instructor_instruments_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE CASCADE;


--
-- Name: instructor_instruments instructor_instruments_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(instrument_id) ON DELETE CASCADE;


--
-- Name: instructor_timeslot instructor_timeslot_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE CASCADE;


--
-- Name: instructor_timeslot instructor_timeslot_timeslot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_timeslot_id_fkey FOREIGN KEY (timeslot_id) REFERENCES public.available_time_slots(timeslot_id) ON DELETE CASCADE;


--
-- Name: instrument_rental instrument_rental_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(instrument_id) ON DELETE CASCADE;


--
-- Name: instrument_rental instrument_rental_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- Name: is_sibling_of is_sibling_of_student_id_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.is_sibling_of
    ADD CONSTRAINT is_sibling_of_student_id_1_fkey FOREIGN KEY (student_id_1) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- Name: is_sibling_of is_sibling_of_student_id_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.is_sibling_of
    ADD CONSTRAINT is_sibling_of_student_id_2_fkey FOREIGN KEY (student_id_2) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- Name: lesson lesson_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE RESTRICT;


--
-- Name: lesson lesson_pricing_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pricing_scheme_id_fkey FOREIGN KEY (pricing_scheme_id) REFERENCES public.pricingscheme(pricing_scheme_id) ON DELETE RESTRICT;


--
-- Name: student_lesson student_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- Name: student_lesson student_lesson_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

