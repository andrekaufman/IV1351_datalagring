--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Postgres.app)
-- Dumped by pg_dump version 17.0

-- Started on 2024-11-28 15:10:49 CET

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
-- TOC entry 239 (class 1255 OID 17108)
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
-- TOC entry 235 (class 1259 OID 17126)
-- Name: available_time_slots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.available_time_slots (
    timeslot_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL
);


ALTER TABLE public.available_time_slots OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17125)
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
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 234
-- Name: available_time_slots_timeslot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.available_time_slots_timeslot_id_seq OWNED BY public.available_time_slots.timeslot_id;


--
-- TOC entry 227 (class 1259 OID 17040)
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
-- TOC entry 224 (class 1259 OID 17002)
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
-- TOC entry 230 (class 1259 OID 17061)
-- Name: student_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_lesson (
    student_id integer NOT NULL,
    lesson_id integer NOT NULL
);


ALTER TABLE public.student_lesson OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17193)
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
-- TOC entry 226 (class 1259 OID 17030)
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
-- TOC entry 225 (class 1259 OID 17020)
-- Name: individuallesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individuallesson (
    lesson_id integer NOT NULL,
    instrument_type character varying(50) NOT NULL,
    skill_level character varying(20) NOT NULL
);


ALTER TABLE public.individuallesson OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16984)
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
-- TOC entry 219 (class 1259 OID 16983)
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
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 219
-- Name: instructor_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_instructor_id_seq OWNED BY public.instructor.instructor_id;


--
-- TOC entry 231 (class 1259 OID 17076)
-- Name: instructor_instruments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_instruments (
    instructor_id integer NOT NULL,
    instrument_id integer NOT NULL
);


ALTER TABLE public.instructor_instruments OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17132)
-- Name: instructor_timeslot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_timeslot (
    instructor_id integer NOT NULL,
    timeslot_id integer NOT NULL
);


ALTER TABLE public.instructor_timeslot OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16993)
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    instrument_id integer NOT NULL,
    instrument_number character varying(20) NOT NULL,
    instrument_type character varying(50) NOT NULL,
    instrument_brand character varying(50),
    is_available boolean NOT NULL
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16992)
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
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 221
-- Name: instrument_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_instrument_id_seq OWNED BY public.instrument.instrument_id;


--
-- TOC entry 233 (class 1259 OID 17092)
-- Name: instrument_rental; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_rental (
    rental_id integer NOT NULL,
    student_id integer NOT NULL,
    instrument_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    rental_price numeric(10,2) NOT NULL
);


ALTER TABLE public.instrument_rental OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17091)
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
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 232
-- Name: instrument_rental_rental_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_rental_rental_id_seq OWNED BY public.instrument_rental.rental_id;


--
-- TOC entry 223 (class 1259 OID 17001)
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
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 223
-- Name: lesson_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_lesson_id_seq OWNED BY public.lesson.lesson_id;


--
-- TOC entry 218 (class 1259 OID 16975)
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
-- TOC entry 217 (class 1259 OID 16974)
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
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 217
-- Name: pricingscheme_pricing_scheme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pricingscheme_pricing_scheme_id_seq OWNED BY public.pricingscheme.pricing_scheme_id;


--
-- TOC entry 229 (class 1259 OID 17051)
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
-- TOC entry 237 (class 1259 OID 17147)
-- Name: student_sibling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_sibling (
    student_id integer NOT NULL,
    sibling_id integer NOT NULL,
    CONSTRAINT student_sibling_check CHECK ((student_id < sibling_id))
);


ALTER TABLE public.student_sibling OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17050)
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
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 228
-- Name: student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_student_id_seq OWNED BY public.student.student_id;


--
-- TOC entry 3587 (class 2604 OID 17129)
-- Name: available_time_slots timeslot_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.available_time_slots ALTER COLUMN timeslot_id SET DEFAULT nextval('public.available_time_slots_timeslot_id_seq'::regclass);


--
-- TOC entry 3582 (class 2604 OID 16987)
-- Name: instructor instructor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN instructor_id SET DEFAULT nextval('public.instructor_instructor_id_seq'::regclass);


--
-- TOC entry 3583 (class 2604 OID 16996)
-- Name: instrument instrument_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument ALTER COLUMN instrument_id SET DEFAULT nextval('public.instrument_instrument_id_seq'::regclass);


--
-- TOC entry 3586 (class 2604 OID 17095)
-- Name: instrument_rental rental_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental ALTER COLUMN rental_id SET DEFAULT nextval('public.instrument_rental_rental_id_seq'::regclass);


--
-- TOC entry 3584 (class 2604 OID 17005)
-- Name: lesson lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN lesson_id SET DEFAULT nextval('public.lesson_lesson_id_seq'::regclass);


--
-- TOC entry 3581 (class 2604 OID 16978)
-- Name: pricingscheme pricing_scheme_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricingscheme ALTER COLUMN pricing_scheme_id SET DEFAULT nextval('public.pricingscheme_pricing_scheme_id_seq'::regclass);


--
-- TOC entry 3585 (class 2604 OID 17054)
-- Name: student student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN student_id SET DEFAULT nextval('public.student_student_id_seq'::regclass);


--
-- TOC entry 3624 (class 2606 OID 17131)
-- Name: available_time_slots available_time_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.available_time_slots
    ADD CONSTRAINT available_time_slots_pkey PRIMARY KEY (timeslot_id);


--
-- TOC entry 3610 (class 2606 OID 17044)
-- Name: ensemblelesson ensemblelesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemblelesson
    ADD CONSTRAINT ensemblelesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3608 (class 2606 OID 17034)
-- Name: grouplesson grouplesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouplesson
    ADD CONSTRAINT grouplesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3606 (class 2606 OID 17024)
-- Name: individuallesson individuallesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individuallesson
    ADD CONSTRAINT individuallesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3620 (class 2606 OID 17080)
-- Name: instructor_instruments instructor_instruments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_pkey PRIMARY KEY (instructor_id, instrument_id);


--
-- TOC entry 3594 (class 2606 OID 16991)
-- Name: instructor instructor_personal_identity_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_personal_identity_number_key UNIQUE (personal_identity_number);


--
-- TOC entry 3596 (class 2606 OID 16989)
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (instructor_id);


--
-- TOC entry 3626 (class 2606 OID 17136)
-- Name: instructor_timeslot instructor_timeslot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_pkey PRIMARY KEY (instructor_id, timeslot_id);


--
-- TOC entry 3598 (class 2606 OID 17000)
-- Name: instrument instrument_instrument_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_instrument_number_key UNIQUE (instrument_number);


--
-- TOC entry 3600 (class 2606 OID 16998)
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (instrument_id);


--
-- TOC entry 3622 (class 2606 OID 17097)
-- Name: instrument_rental instrument_rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_pkey PRIMARY KEY (rental_id);


--
-- TOC entry 3602 (class 2606 OID 17009)
-- Name: lesson lesson_lesson_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_lesson_number_key UNIQUE (lesson_number);


--
-- TOC entry 3604 (class 2606 OID 17007)
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3590 (class 2606 OID 16980)
-- Name: pricingscheme pricingscheme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricingscheme
    ADD CONSTRAINT pricingscheme_pkey PRIMARY KEY (pricing_scheme_id);


--
-- TOC entry 3592 (class 2606 OID 16982)
-- Name: pricingscheme pricingscheme_pricing_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricingscheme
    ADD CONSTRAINT pricingscheme_pricing_id_key UNIQUE (pricing_id);


--
-- TOC entry 3618 (class 2606 OID 17065)
-- Name: student_lesson student_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_pkey PRIMARY KEY (student_id, lesson_id);


--
-- TOC entry 3612 (class 2606 OID 17060)
-- Name: student student_personal_identity_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_personal_identity_number_key UNIQUE (personal_identity_number);


--
-- TOC entry 3614 (class 2606 OID 17056)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- TOC entry 3628 (class 2606 OID 17152)
-- Name: student_sibling student_sibling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_sibling
    ADD CONSTRAINT student_sibling_pkey PRIMARY KEY (student_id, sibling_id);


--
-- TOC entry 3616 (class 2606 OID 17058)
-- Name: student student_student_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_student_number_key UNIQUE (student_number);


--
-- TOC entry 3644 (class 2620 OID 17109)
-- Name: instrument_rental rental_quota_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER rental_quota_trigger BEFORE INSERT ON public.instrument_rental FOR EACH ROW EXECUTE FUNCTION public.enforce_rental_quota();


--
-- TOC entry 3633 (class 2606 OID 17045)
-- Name: ensemblelesson ensemblelesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemblelesson
    ADD CONSTRAINT ensemblelesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3632 (class 2606 OID 17035)
-- Name: grouplesson grouplesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouplesson
    ADD CONSTRAINT grouplesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3631 (class 2606 OID 17025)
-- Name: individuallesson individuallesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individuallesson
    ADD CONSTRAINT individuallesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3636 (class 2606 OID 17081)
-- Name: instructor_instruments instructor_instruments_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE CASCADE;


--
-- TOC entry 3637 (class 2606 OID 17086)
-- Name: instructor_instruments instructor_instruments_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instruments
    ADD CONSTRAINT instructor_instruments_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(instrument_id) ON DELETE CASCADE;


--
-- TOC entry 3640 (class 2606 OID 17137)
-- Name: instructor_timeslot instructor_timeslot_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE CASCADE;


--
-- TOC entry 3641 (class 2606 OID 17142)
-- Name: instructor_timeslot instructor_timeslot_timeslot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_timeslot
    ADD CONSTRAINT instructor_timeslot_timeslot_id_fkey FOREIGN KEY (timeslot_id) REFERENCES public.available_time_slots(timeslot_id) ON DELETE CASCADE;


--
-- TOC entry 3638 (class 2606 OID 17103)
-- Name: instrument_rental instrument_rental_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(instrument_id) ON DELETE CASCADE;


--
-- TOC entry 3639 (class 2606 OID 17098)
-- Name: instrument_rental instrument_rental_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- TOC entry 3629 (class 2606 OID 17010)
-- Name: lesson lesson_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id) ON DELETE RESTRICT;


--
-- TOC entry 3630 (class 2606 OID 17015)
-- Name: lesson lesson_pricing_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pricing_scheme_id_fkey FOREIGN KEY (pricing_scheme_id) REFERENCES public.pricingscheme(pricing_scheme_id) ON DELETE RESTRICT;


--
-- TOC entry 3634 (class 2606 OID 17071)
-- Name: student_lesson student_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3635 (class 2606 OID 17066)
-- Name: student_lesson student_lesson_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- TOC entry 3642 (class 2606 OID 17158)
-- Name: student_sibling student_sibling_sibling_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_sibling
    ADD CONSTRAINT student_sibling_sibling_id_fkey FOREIGN KEY (sibling_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- TOC entry 3643 (class 2606 OID 17153)
-- Name: student_sibling student_sibling_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_sibling
    ADD CONSTRAINT student_sibling_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


-- Completed on 2024-11-28 15:10:49 CET

--
-- PostgreSQL database dump complete
--

