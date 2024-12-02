Creation of main database:

- Create database 'soundgooddb_historical' in GUI or by entering CREATE DATABASE soundgooddb;
- Right-click on its public schema and choose PSQL Tool
- Enter \i 'path-to-create_database.sql'


Insert sample data into main database:

- In the same prompt, enter \i 'path-to-insert_sampledata.sql'


Create historical database:

- Create database 'soundgooddb_historical' in GUI or by entering CREATE DATABASE soundgooddb_historical;

- Right-click on its public schema and choose Query Tool

- Enable postgres_fdw extension: CREATE EXTENSION IF NOT EXISTS postgres_fdw;

- Create a foreign server to access the main database:
CREATE SERVER soundgooddb_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (dbname 'soundgooddb', host 'localhost');

- Create a user mapping:
CREATE USER MAPPING FOR postgres
SERVER soundgooddb_server
OPTIONS (user 'postgres', password 'postgres');

- Import relevant foreign schemas from main database
IMPORT FOREIGN SCHEMA public LIMIT TO (lesson, individuallesson, grouplesson, ensemblelesson, student_lesson, student, pricingscheme) FROM SERVER soundgooddb_server INTO public;


- Enter PSQL tool and enter \i 'path-to-insert_sampledata_historical.sql'








