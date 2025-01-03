--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Postgres.app)
-- Dumped by pg_dump version 17.0

-- Started on 2024-12-30 19:02:16 CET

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
-- TOC entry 240 (class 1255 OID 17602)
-- Name: enforce_instrument_availability(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.enforce_instrument_availability() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if the instrument is already rented
    IF EXISTS (
        SELECT 1
        FROM instrument_rental
        WHERE instrument_id = NEW.instrument_id
          AND end_date IS NULL
    ) THEN
        RAISE EXCEPTION 'Instrument is already rented to another student.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.enforce_instrument_availability() OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 17604)
-- Name: enforce_rental_period(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.enforce_rental_period() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if the rental period exceeds 12 months
    IF NEW.end_date IS NOT NULL AND 
       NEW.end_date > NEW.start_date + INTERVAL '12 months' THEN
        RAISE EXCEPTION 'Rental period cant exceed 12 months.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.enforce_rental_period() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 17384)
-- Name: enforce_rental_quota(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.enforce_rental_quota() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 17385)
-- Name: available_time_slots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.available_time_slots (
    timeslot_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL
);


ALTER TABLE public.available_time_slots OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17388)
-- Name: available_time_slots_timeslot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.available_time_slots_timeslot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.available_time_slots_timeslot_id_seq OWNER TO postgres;

--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 218
-- Name: available_time_slots_timeslot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.available_time_slots_timeslot_id_seq OWNED BY public.available_time_slots.timeslot_id;


--
-- TOC entry 219 (class 1259 OID 17389)
-- Name: ensemblelesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemblelesson (
    lesson_id integer NOT NULL,
    genre character varying(50) NOT NULL,
    min_amount_students integer NOT NULL,
    max_amount_students integer NOT NULL
);


ALTER TABLE public.ensemblelesson OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17392)
-- Name: lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson (
    lesson_id integer NOT NULL,
    lesson_number character varying(20) NOT NULL,
    room_id integer NOT NULL,
    capacity integer NOT NULL,
    instructor_id integer NOT NULL,
    pricing_scheme_id integer NOT NULL,
    "time" timestamp without time zone
);


ALTER TABLE public.lesson OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17395)
-- Name: student_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_lesson (
    student_id integer NOT NULL,
    lesson_id integer NOT NULL
);


ALTER TABLE public.student_lesson OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17398)
-- Name: ensemble_seat_availability; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ensemble_seat_availability AS
 SELECT l.lesson_id,
    to_char(l."time", 'Day'::text) AS day_of_week,
    e.genre,
    l."time",
    (l.capacity - COALESCE(count(sl.student_id), (0)::bigint)) AS free_seats
   FROM ((public.lesson l
     JOIN public.ensemblelesson e ON ((l.lesson_id = e.lesson_id)))
     LEFT JOIN public.student_lesson sl ON ((l.lesson_id = sl.lesson_id)))
  GROUP BY l.lesson_id, l."time", e.genre, l.capacity;


ALTER VIEW public.ensemble_seat_availability OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17403)
-- Name: grouplesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grouplesson (
    lesson_id integer NOT NULL,
    instrument_type character varying(50) NOT NULL,
    min_amount_students integer NOT NULL,
    max_amount_students integer NOT NULL,
    skill_level character varying(20) NOT NULL
);


ALTER TABLE public.grouplesson OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17406)
-- Name: individuallesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individuallesson (
    lesson_id integer NOT NULL,
    instrument_type character varying(50) NOT NULL,
    skill_level character varying(20) NOT NULL
);


ALTER TABLE public.individuallesson OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17409)
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.instructor OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17412)
-- Name: instructor_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instructor_instructor_id_seq OWNER TO postgres;

--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 226
-- Name: instructor_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_instructor_id_seq OWNED BY public.instructor.instructor_id;


--
-- TOC entry 227 (class 1259 OID 17413)
-- Name: instructor_instruments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_instruments (
    instructor_id integer NOT NULL,
    instrument_id integer NOT NULL
);


ALTER TABLE public.instructor_instruments OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17416)
-- Name: instructor_timeslot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_timeslot (
    instructor_id integer NOT NULL,
    timeslot_id integer NOT NULL
);


ALTER TABLE public.instructor_timeslot OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17419)
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    instrument_id integer NOT NULL,
    instrument_number character varying(20) NOT NULL,
    instrument_type character varying(50) NOT NULL,
    instrument_brand character varying(50),
    is_available boolean NOT NULL,
    rental_price numeric(10,2) DEFAULT 0.0 NOT NULL
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17422)
-- Name: instrument_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instrument_instrument_id_seq OWNER TO postgres;

--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 230
-- Name: instrument_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_instrument_id_seq OWNED BY public.instrument.instrument_id;


--
-- TOC entry 231 (class 1259 OID 17423)
-- Name: instrument_rental; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_rental (
    rental_id integer NOT NULL,
    student_id integer NOT NULL,
    instrument_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date
);


ALTER TABLE public.instrument_rental OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17426)
-- Name: instrument_rental_rental_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_rental_rental_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instrument_rental_rental_id_seq OWNER TO postgres;

--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 232
-- Name: instrument_rental_rental_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_rental_rental_id_seq OWNED BY public.instrument_rental.rental_id;


--
-- TOC entry 233 (class 1259 OID 17427)
-- Name: lesson_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 233
-- Name: lesson_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_lesson_id_seq OWNED BY public.lesson.lesson_id;


--
-- TOC entry 234 (class 1259 OID 17428)
-- Name: pricingscheme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pricingscheme (
    pricing_scheme_id integer NOT NULL,
    pricing_id character varying(20) NOT NULL,
    lesson_type character varying(50) NOT NULL,
    skill_level_type character varying(50) NOT NULL,
    price numeric(10,2) NOT NULL,
    valid_from date NOT NULL
);


ALTER TABLE public.pricingscheme OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17431)
-- Name: pricingscheme_pricing_scheme_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pricingscheme_pricing_scheme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pricingscheme_pricing_scheme_id_seq OWNER TO postgres;

--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 235
-- Name: pricingscheme_pricing_scheme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pricingscheme_pricing_scheme_id_seq OWNED BY public.pricingscheme.pricing_scheme_id;


--
-- TOC entry 236 (class 1259 OID 17432)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17435)
-- Name: student_sibling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_sibling (
    student_id integer NOT NULL,
    sibling_id integer NOT NULL,
    CONSTRAINT student_sibling_check CHECK ((student_id < sibling_id))
);


ALTER TABLE public.student_sibling OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17439)
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_student_id_seq OWNER TO postgres;

--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 238
-- Name: student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_student_id_seq OWNED BY public.student.student_id;


--
-- TOC entry 3583 (class 2604 OID 17440)
-- Name: available_time_slots timeslot_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.available_time_slots ALTER COLUMN timeslot_id SET DEFAULT nextval('public.available_time_slots_timeslot_id_seq'::regclass);


--
-- TOC entry 3585 (class 2604 OID 17441)
-- Name: instructor instructor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN instructor_id SET DEFAULT nextval('public.instructor_instructor_id_seq'::regclass);


--
-- TOC entry 3586 (class 2604 OID 17442)
-- Name: instrument instrument_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument ALTER COLUMN instrument_id SET DEFAULT nextval('public.instrument_instrument_id_seq'::regclass);


--
-- TOC entry 3588 (class 2604 OID 17443)
-- Name: instrument_rental rental_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental ALTER COLUMN rental_id SET DEFAULT nextval('public.instrument_rental_rental_id_seq'::regclass);


--
-- TOC entry 3584 (class 2604 OID 17444)
-- Name: lesson lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN lesson_id SET DEFAULT nextval('public.lesson_lesson_id_seq'::regclass);


--
-- TOC entry 3589 (class 2604 OID 17445)
-- Name: pricingscheme pricing_scheme_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricingscheme ALTER COLUMN pricing_scheme_id SET DEFAULT nextval('public.pricingscheme_pricing_scheme_id_seq'::regclass);


--
-- TOC entry 3590 (class 2604 OID 17446)
-- Name: student student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN student_id SET DEFAULT nextval('public.student_student_id_seq'::regclass);


--
-- TOC entry 3593 (class 2606 OID 17448)
-- Name: available_time_slots available_time_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.available_time_slots
    ADD CONSTRAINT available_time_slots_pkey PRIMARY KEY (timeslot_id);


--
-- TOC entry 3595 (class 2606 OID 17450)
-- Name: ensemblelesson ensemblelesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemblelesson
    ADD CONSTRAINT ensemblelesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3603 (class 2606 OID 17452)
-- Name: grouplesson grouplesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouplesson
    ADD CONSTRAINT grouplesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3605 (class 2606 OID 17454)
-- Name: individuallesson individuallesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individuallesson
    ADD CONSTRAINT individuallesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3611 (class 2606 OID 17456)
-- Name: instructor_instruments instructor_instruments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_pkey PRIMARY KEY (instructor_id, instrument_id);


--
-- TOC entry 3607 (class 2606 OID 17458)
-- Name: instructor instructor_personal_identity_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_personal_identity_number_key UNIQUE (personal_identity_number);


--
-- TOC entry 3609 (class 2606 OID 17460)
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (instructor_id);


--
-- TOC entry 3613 (class 2606 OID 17462)
-- Name: instructor_timeslot instructor_timeslot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_pkey PRIMARY KEY (instructor_id, timeslot_id);


--
-- TOC entry 3615 (class 2606 OID 17464)
-- Name: instrument instrument_instrument_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_instrument_number_key UNIQUE (instrument_number);


--
-- TOC entry 3617 (class 2606 OID 17466)
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (instrument_id);


--
-- TOC entry 3619 (class 2606 OID 17468)
-- Name: instrument_rental instrument_rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_pkey PRIMARY KEY (rental_id);


--
-- TOC entry 3597 (class 2606 OID 17470)
-- Name: lesson lesson_lesson_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_lesson_number_key UNIQUE (lesson_number);


--
-- TOC entry 3599 (class 2606 OID 17472)
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3621 (class 2606 OID 17474)
-- Name: pricingscheme pricingscheme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricingscheme
    ADD CONSTRAINT pricingscheme_pkey PRIMARY KEY (pricing_scheme_id);


--
-- TOC entry 3623 (class 2606 OID 17476)
-- Name: pricingscheme pricingscheme_pricing_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricingscheme
    ADD CONSTRAINT pricingscheme_pricing_id_key UNIQUE (pricing_id);


--
-- TOC entry 3601 (class 2606 OID 17478)
-- Name: student_lesson student_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_pkey PRIMARY KEY (student_id, lesson_id);


--
-- TOC entry 3625 (class 2606 OID 17480)
-- Name: student student_personal_identity_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_personal_identity_number_key UNIQUE (personal_identity_number);


--
-- TOC entry 3627 (class 2606 OID 17482)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- TOC entry 3631 (class 2606 OID 17484)
-- Name: student_sibling student_sibling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_sibling
    ADD CONSTRAINT student_sibling_pkey PRIMARY KEY (student_id, sibling_id);


--
-- TOC entry 3629 (class 2606 OID 17486)
-- Name: student student_student_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_student_number_key UNIQUE (student_number);


--
-- TOC entry 3647 (class 2620 OID 17603)
-- Name: instrument_rental prevent_simultaneous_rentals; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER prevent_simultaneous_rentals BEFORE INSERT ON public.instrument_rental FOR EACH ROW EXECUTE FUNCTION public.enforce_instrument_availability();


--
-- TOC entry 3648 (class 2620 OID 17605)
-- Name: instrument_rental rental_period_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER rental_period_trigger BEFORE INSERT OR UPDATE ON public.instrument_rental FOR EACH ROW EXECUTE FUNCTION public.enforce_rental_period();


--
-- TOC entry 3649 (class 2620 OID 17487)
-- Name: instrument_rental rental_quota_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER rental_quota_trigger BEFORE INSERT ON public.instrument_rental FOR EACH ROW EXECUTE FUNCTION public.enforce_rental_quota();


--
-- TOC entry 3632 (class 2606 OID 17488)
-- Name: ensemblelesson ensemblelesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemblelesson
    ADD CONSTRAINT ensemblelesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3637 (class 2606 OID 17493)
-- Name: grouplesson grouplesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouplesson
    ADD CONSTRAINT grouplesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3638 (class 2606 OID 17498)
-- Name: individuallesson individuallesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individuallesson
    ADD CONSTRAINT individuallesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3639 (class 2606 OID 17503)
-- Name: instructor_instruments instructor_instruments_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE CASCADE;


--
-- TOC entry 3640 (class 2606 OID 17508)
-- Name: instructor_instruments instructor_instruments_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(instrument_id) ON DELETE CASCADE;


--
-- TOC entry 3641 (class 2606 OID 17513)
-- Name: instructor_timeslot instructor_timeslot_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE CASCADE;


--
-- TOC entry 3642 (class 2606 OID 17518)
-- Name: instructor_timeslot instructor_timeslot_timeslot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_timeslot_id_fkey FOREIGN KEY (timeslot_id) REFERENCES public.available_time_slots(timeslot_id) ON DELETE CASCADE;


--
-- TOC entry 3643 (class 2606 OID 17523)
-- Name: instrument_rental instrument_rental_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(instrument_id) ON DELETE CASCADE;


--
-- TOC entry 3644 (class 2606 OID 17528)
-- Name: instrument_rental instrument_rental_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- TOC entry 3633 (class 2606 OID 17533)
-- Name: lesson lesson_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE RESTRICT;


--
-- TOC entry 3634 (class 2606 OID 17538)
-- Name: lesson lesson_pricing_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pricing_scheme_id_fkey FOREIGN KEY (pricing_scheme_id) REFERENCES public.pricingscheme(pricing_scheme_id) ON DELETE RESTRICT;


--
-- TOC entry 3635 (class 2606 OID 17543)
-- Name: student_lesson student_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3636 (class 2606 OID 17548)
-- Name: student_lesson student_lesson_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- TOC entry 3645 (class 2606 OID 17553)
-- Name: student_sibling student_sibling_sibling_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_sibling
    ADD CONSTRAINT student_sibling_sibling_id_fkey FOREIGN KEY (sibling_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- TOC entry 3646 (class 2606 OID 17558)
-- Name: student_sibling student_sibling_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_sibling
    ADD CONSTRAINT student_sibling_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


-- Completed on 2024-12-30 19:02:16 CET

--
-- PostgreSQL database dump complete
--

