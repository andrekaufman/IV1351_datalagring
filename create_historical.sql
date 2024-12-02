CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER soundgooddb_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (dbname 'soundgooddb', host 'localhost');

CREATE USER MAPPING FOR postgres
SERVER soundgooddb_server
OPTIONS (user 'postgres', password 'postgres');

IMPORT FOREIGN SCHEMA public LIMIT TO (lesson, individuallesson, grouplesson, ensemblelesson, student_lesson, student, pricingscheme) FROM SERVER soundgooddb_server INTO public;

CREATE TABLE historical_lessons (
    historical_id SERIAL PRIMARY KEY,
    lesson_id INT NOT NULL,
    lesson_type VARCHAR(50),
    genre VARCHAR(50),
    instrument VARCHAR(50),
    lesson_price NUMERIC(10, 2),
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    time TIMESTAMP
);