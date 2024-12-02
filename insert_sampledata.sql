--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Postgres.app)
-- Dumped by pg_dump version 17.0

-- Started on 2024-11-28 15:28:30 CET

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
-- TOC entry 3801 (class 0 OID 17126)
-- Dependencies: 235
-- Data for Name: available_time_slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.available_time_slots VALUES (1, '2024-12-01 08:00:00', '2024-12-01 09:00:00');
INSERT INTO public.available_time_slots VALUES (2, '2024-12-02 09:00:00', '2024-12-02 10:00:00');


--
-- TOC entry 3786 (class 0 OID 16984)
-- Dependencies: 220
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor VALUES (1, 'Emma Larsson', 45000.00, true, '19900101-1234', '0701234567', 'emma.larsson@example.com', '11122     ', 'Stockholm', 'Sergels Torg 1');
INSERT INTO public.instructor VALUES (2, 'Lars Svensson', 40000.00, false, '19851212-5678', '0734567890', 'lars.svensson@example.com', '22233     ', 'Gothenburg', 'Kungsportsavenyen 10');
INSERT INTO public.instructor VALUES (3, 'Nina Bergström', 47000.00, true, '19820415-3456', '0723456789', 'nina.bergstrom@example.com', '44455     ', 'Lund', 'Stora Södergatan 10');
INSERT INTO public.instructor VALUES (4, 'Olof Jonsson', 39000.00, false, '19790130-6789', '0709876543', 'olof.jonsson@example.com', '55666     ', 'Uppsala', 'Vaksalagatan 12');


--
-- TOC entry 3784 (class 0 OID 16975)
-- Dependencies: 218
-- Data for Name: pricingscheme; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pricingscheme VALUES (1, 'P001', 'Individual', 'Beginner', 500.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (2, 'P002', 'Individual', 'Intermediate', 600.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (3, 'P003', 'Individual', 'Advanced', 700.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (4, 'P004', 'Group', 'Beginner', 400.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (5, 'P005', 'Group', 'Intermediate', 500.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (6, 'P006', 'Group', 'Advanced', 600.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (7, 'P007', 'Ensemble', 'Beginner', 300.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (8, 'P008', 'Ensemble', 'Intermediate', 400.00, '2024-11-21');
INSERT INTO public.pricingscheme VALUES (9, 'P009', 'Ensemble', 'Advanced', 500.00, '2024-11-21');


--
-- TOC entry 3790 (class 0 OID 17002)
-- Dependencies: 224
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lesson VALUES (1, 'L101', 1, 1, 1, 1, '2024-11-03 10:00:00');
INSERT INTO public.lesson VALUES (2, 'L301', 6, 10, 4, 3, '2024-11-06 16:00:00');
INSERT INTO public.lesson VALUES (3, 'L201', 4, 6, 3, 2, '2024-11-09 14:00:00');
INSERT INTO public.lesson VALUES (4, 'L202', 3, 6, 3, 2, '2024-11-14 13:00:00');
INSERT INTO public.lesson VALUES (5, 'L302', 5, 10, 4, 3, '2024-11-16 16:00:00');
INSERT INTO public.lesson VALUES (6, 'L102', 1, 1, 1, 1, '2024-11-19 10:00:00');
INSERT INTO public.lesson VALUES (7, 'L203', 3, 6, 3, 2, '2024-11-20 13:00:00');
INSERT INTO public.lesson VALUES (8, 'L204', 4, 6, 3, 2, '2024-11-25 14:00:00');
INSERT INTO public.lesson VALUES (9, 'L103', 2, 1, 2, 1, '2024-11-27 11:00:00');
INSERT INTO public.lesson VALUES (10, 'L104', 2, 1, 2, 1, '2024-11-27 11:00:00');
INSERT INTO public.lesson VALUES (11, 'L303', 5, 10, 4, 3, '2024-11-27 15:00:00');
INSERT INTO public.lesson VALUES (12, 'L304', 6, 10, 1, 3, '2024-11-29 10:00:00');
INSERT INTO public.lesson VALUES (13, 'L305', 5, 10, 2, 3, '2024-11-30 11:00:00');
INSERT INTO public.lesson VALUES (14, 'L306', 6, 10, 4, 3, '2024-11-30 15:00:00');
INSERT INTO public.lesson VALUES (15, 'L307', 5, 10, 3, 3, '2024-12-01 15:00:00');
INSERT INTO public.lesson VALUES (16, 'L308', 6, 10, 4, 3, '2024-12-03 14:00:00');


--
-- TOC entry 3793 (class 0 OID 17040)
-- Dependencies: 227
-- Data for Name: ensemblelesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ensemblelesson VALUES (14, 'Rock', 5, 10);
INSERT INTO public.ensemblelesson VALUES (5, 'Jazz', 5, 10);
INSERT INTO public.ensemblelesson VALUES (11, 'Pop', 5, 10);
INSERT INTO public.ensemblelesson VALUES (2, 'Blues', 5, 10);
INSERT INTO public.ensemblelesson VALUES (12, 'Rock', 5, 10);
INSERT INTO public.ensemblelesson VALUES (13, 'Jazz', 5, 10);
INSERT INTO public.ensemblelesson VALUES (15, 'Pop', 5, 10);
INSERT INTO public.ensemblelesson VALUES (16, 'Blues', 5, 10);


--
-- TOC entry 3792 (class 0 OID 17030)
-- Dependencies: 226
-- Data for Name: grouplesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.grouplesson VALUES (4, 'Violin', 2, 6, 'Advanced');
INSERT INTO public.grouplesson VALUES (8, 'Flute', 2, 6, 'Intermediate');
INSERT INTO public.grouplesson VALUES (7, 'Cello', 2, 6, 'Advanced');
INSERT INTO public.grouplesson VALUES (3, 'Saxophone', 2, 6, 'Intermediate');


--
-- TOC entry 3791 (class 0 OID 17020)
-- Dependencies: 225
-- Data for Name: individuallesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.individuallesson VALUES (1, 'Piano', 'Beginner');
INSERT INTO public.individuallesson VALUES (9, 'Guitar', 'Intermediate');
INSERT INTO public.individuallesson VALUES (6, 'Violin', 'Beginner');
INSERT INTO public.individuallesson VALUES (10, 'Piano', 'Intermediate');


--
-- TOC entry 3788 (class 0 OID 16993)
-- Dependencies: 222
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instrument VALUES (1, 'I001', 'Piano', 'Yamaha', true);
INSERT INTO public.instrument VALUES (2, 'I002', 'Guitar', 'Fender', true);
INSERT INTO public.instrument VALUES (3, 'I003', 'Violin', 'Stradivarius', false);
INSERT INTO public.instrument VALUES (4, 'I004', 'Flute', 'Pearl', true);


--
-- TOC entry 3797 (class 0 OID 17076)
-- Dependencies: 231
-- Data for Name: instructor_instruments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor_instruments VALUES (1, 1);
INSERT INTO public.instructor_instruments VALUES (2, 2);


--
-- TOC entry 3802 (class 0 OID 17132)
-- Dependencies: 236
-- Data for Name: instructor_timeslot; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor_timeslot VALUES (1, 1);


--
-- TOC entry 3795 (class 0 OID 17051)
-- Dependencies: 229
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student VALUES (1, 'S001', 'Erik Johansson', '0723456789', 'erik.johansson@example.com', '20000101-1111', '12345     ', 'Malmö', 'Storgatan 5', 0.00, 2, 5);
INSERT INTO public.student VALUES (2, 'S002', 'Sara Karlsson', '0765432109', 'sara.karlsson@example.com', '20020505-2222', '67890     ', 'Uppsala', 'Linnégatan 3', 10.00, 2, 8);
INSERT INTO public.student VALUES (3, 'S003', 'Anna Svensson', '0731234567', 'anna.svensson@example.com', '20030101-1234', '12400     ', 'Stockholm', 'Gamla Stan 5', 5.00, 2, 6);
INSERT INTO public.student VALUES (4, 'S004', 'Johan Eriksson', '0742345678', 'johan.eriksson@example.com', '20040202-2345', '12401     ', 'Gothenburg', 'Avenyn 10', 10.00, 2, 8);
INSERT INTO public.student VALUES (5, 'S005', 'Karin Lindström', '0753456789', 'karin.lindstrom@example.com', '20050303-3456', '12402     ', 'Uppsala', 'Vaksalagatan 12', 15.00, 2, 10);
INSERT INTO public.student VALUES (6, 'S006', 'Fredrik Olsson', '0764567890', 'fredrik.olsson@example.com', '20060404-4567', '12403     ', 'Malmö', 'Kanalgatan 7', 20.00, 2, 12);
INSERT INTO public.student VALUES (7, 'S007', 'Emelie Persson', '0775678901', 'emelie.persson@example.com', '20070505-5678', '12404     ', 'Lund', 'Stora Torget 8', 25.00, 2, 14);
INSERT INTO public.student VALUES (8, 'S008', 'Oscar Karlsson', '0786789012', 'oscar.karlsson@example.com', '20080606-6789', '12405     ', 'Västerås', 'Gågatan 11', 30.00, 2, 16);
INSERT INTO public.student VALUES (9, 'S009', 'Maria Andersson', '0797890123', 'maria.andersson@example.com', '20090707-7890', '12406     ', 'Helsingborg', 'Centralvägen 4', 35.00, 2, 18);
INSERT INTO public.student VALUES (10, 'S010', 'Erik Gustafsson', '0708901234', 'erik.gustafsson@example.com', '20100808-8901', '12407     ', 'Linköping', 'Slottsgatan 6', 40.00, 2, 20);
INSERT INTO public.student VALUES (11, 'S011', 'Eva Larsson', '0719012345', 'eva.larsson@example.com', '20110909-9012', '12408     ', 'Örebro', 'Trädgårdsgatan 14', 45.00, 2, 22);
INSERT INTO public.student VALUES (12, 'S012', 'Lars Berg', '0720123456', 'lars.berg@example.com', '20121010-0123', '12409     ', 'Jönköping', 'Hamngatan 2', 50.00, 2, 24);
INSERT INTO public.student VALUES (13, 'S013', 'Helena Norén', '0731234567', 'helena.noren@example.com', '20131111-1234', '12410     ', 'Sundsvall', 'Hantverkargatan 13', 55.00, 2, 26);
INSERT INTO public.student VALUES (14, 'S014', 'Martin Ek', '0742345678', 'martin.ek@example.com', '20141212-2345', '12411     ', 'Luleå', 'Smedjegatan 15', 60.00, 2, 28);
INSERT INTO public.student VALUES (15, 'S015', 'Sara Holm', '0753456789', 'sara.holm@example.com', '20150101-3456', '12412     ', 'Karlstad', 'Södra Vägen 9', 65.00, 2, 30);
INSERT INTO public.student VALUES (16, 'S016', 'Daniel Björk', '0764567890', 'daniel.bjork@example.com', '20160202-4567', '12413     ', 'Halmstad', 'Norra Storgatan 10', 70.00, 2, 32);
INSERT INTO public.student VALUES (17, 'S017', 'Linda Olovsson', '0775678901', 'linda.olovsson@example.com', '20170303-5678', '12414     ', 'Skellefteå', 'Kyrkogatan 5', 75.00, 2, 34);
INSERT INTO public.student VALUES (18, 'S018', 'Peter Nyström', '0786789012', 'peter.nystrom@example.com', '20180404-6789', '12415     ', 'Kalmar', 'Storgatan 3', 80.00, 2, 36);
INSERT INTO public.student VALUES (19, 'S019', 'Malin Sundberg', '0797890123', 'malin.sundberg@example.com', '20190505-7890', '12416     ', 'Borlänge', 'Stationsgatan 7', 85.00, 2, 38);
INSERT INTO public.student VALUES (20, 'S020', 'Nils Lundgren', '0708901234', 'nils.lundgren@example.com', '20200606-8901', '12417     ', 'Visby', 'Rådhusgatan 12', 90.00, 2, 40);


--
-- TOC entry 3799 (class 0 OID 17092)
-- Dependencies: 233
-- Data for Name: instrument_rental; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instrument_rental VALUES (1, 1, 3, '2024-11-01', '2024-11-30', 300.00);


--
-- TOC entry 3796 (class 0 OID 17061)
-- Dependencies: 230
-- Data for Name: student_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student_lesson VALUES (1, 1);
INSERT INTO public.student_lesson VALUES (2, 2);
INSERT INTO public.student_lesson VALUES (1, 2);
INSERT INTO public.student_lesson VALUES (3, 2);
INSERT INTO public.student_lesson VALUES (4, 2);
INSERT INTO public.student_lesson VALUES (5, 2);
INSERT INTO public.student_lesson VALUES (6, 3);
INSERT INTO public.student_lesson VALUES (4, 3);
INSERT INTO public.student_lesson VALUES (3, 3);
INSERT INTO public.student_lesson VALUES (7, 3);
INSERT INTO public.student_lesson VALUES (5, 4);
INSERT INTO public.student_lesson VALUES (2, 4);
INSERT INTO public.student_lesson VALUES (1, 4);
INSERT INTO public.student_lesson VALUES (8, 4);
INSERT INTO public.student_lesson VALUES (3, 4);
INSERT INTO public.student_lesson VALUES (9, 5);
INSERT INTO public.student_lesson VALUES (10, 5);
INSERT INTO public.student_lesson VALUES (4, 5);
INSERT INTO public.student_lesson VALUES (6, 5);
INSERT INTO public.student_lesson VALUES (3, 5);
INSERT INTO public.student_lesson VALUES (11, 5);
INSERT INTO public.student_lesson VALUES (12, 6);
INSERT INTO public.student_lesson VALUES (13, 7);
INSERT INTO public.student_lesson VALUES (10, 7);
INSERT INTO public.student_lesson VALUES (11, 7);
INSERT INTO public.student_lesson VALUES (14, 7);
INSERT INTO public.student_lesson VALUES (3, 7);
INSERT INTO public.student_lesson VALUES (4, 8);
INSERT INTO public.student_lesson VALUES (2, 8);
INSERT INTO public.student_lesson VALUES (13, 8);
INSERT INTO public.student_lesson VALUES (1, 8);
INSERT INTO public.student_lesson VALUES (16, 9);
INSERT INTO public.student_lesson VALUES (17, 10);
INSERT INTO public.student_lesson VALUES (18, 11);
INSERT INTO public.student_lesson VALUES (19, 11);
INSERT INTO public.student_lesson VALUES (20, 11);
INSERT INTO public.student_lesson VALUES (1, 11);
INSERT INTO public.student_lesson VALUES (2, 11);
INSERT INTO public.student_lesson VALUES (18, 12);
INSERT INTO public.student_lesson VALUES (15, 12);
INSERT INTO public.student_lesson VALUES (2, 12);
INSERT INTO public.student_lesson VALUES (3, 12);
INSERT INTO public.student_lesson VALUES (4, 12);
INSERT INTO public.student_lesson VALUES (5, 12);
INSERT INTO public.student_lesson VALUES (6, 12);
INSERT INTO public.student_lesson VALUES (17, 13);
INSERT INTO public.student_lesson VALUES (8, 13);
INSERT INTO public.student_lesson VALUES (9, 13);
INSERT INTO public.student_lesson VALUES (10, 13);
INSERT INTO public.student_lesson VALUES (11, 13);
INSERT INTO public.student_lesson VALUES (12, 14);
INSERT INTO public.student_lesson VALUES (13, 14);
INSERT INTO public.student_lesson VALUES (14, 14);
INSERT INTO public.student_lesson VALUES (15, 14);
INSERT INTO public.student_lesson VALUES (16, 14);
INSERT INTO public.student_lesson VALUES (11, 15);
INSERT INTO public.student_lesson VALUES (2, 15);
INSERT INTO public.student_lesson VALUES (3, 15);
INSERT INTO public.student_lesson VALUES (4, 15);
INSERT INTO public.student_lesson VALUES (7, 15);
INSERT INTO public.student_lesson VALUES (6, 15);
INSERT INTO public.student_lesson VALUES (5, 16);
INSERT INTO public.student_lesson VALUES (8, 16);
INSERT INTO public.student_lesson VALUES (10, 16);
INSERT INTO public.student_lesson VALUES (9, 16);
INSERT INTO public.student_lesson VALUES (1, 16);


--
-- TOC entry 3803 (class 0 OID 17147)
-- Dependencies: 237
-- Data for Name: student_sibling; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student_sibling VALUES (1, 2);
INSERT INTO public.student_sibling VALUES (3, 4);
INSERT INTO public.student_sibling VALUES (5, 6);
INSERT INTO public.student_sibling VALUES (5, 7);
INSERT INTO public.student_sibling VALUES (8, 9);
INSERT INTO public.student_sibling VALUES (8, 10);


--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 234
-- Name: available_time_slots_timeslot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.available_time_slots_timeslot_id_seq', 2, true);


--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 219
-- Name: instructor_instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_instructor_id_seq', 2, true);


--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 221
-- Name: instrument_instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_instrument_id_seq', 4, true);


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 232
-- Name: instrument_rental_rental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_rental_rental_id_seq', 1, true);


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 223
-- Name: lesson_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_lesson_id_seq', 64, true);


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 217
-- Name: pricingscheme_pricing_scheme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pricingscheme_pricing_scheme_id_seq', 9, true);


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 228
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_student_id_seq', 20, true);


-- Completed on 2024-11-28 15:28:30 CET

--
-- PostgreSQL database dump complete
--

