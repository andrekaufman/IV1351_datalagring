Creation of main database:

- Create database 'soundgooddb' in GUI or by entering CREATE DATABASE soundgooddb;
- Right-click on its public schema and choose PSQL Tool
- Enter \i 'path-to-create_database.sql'


Insert sample data into main database:

- In the same prompt, enter \i 'path-to-insert_sampledata.sql'


Create historical database:

- Create database 'soundgooddb_historical' in GUI or by entering CREATE DATABASE soundgooddb_historical; 
The script assumes your default postgres account has the password 'postgres'.


- Right-click on its public schema and choose PSQL Tool


- Enter \i 'path-to-create_historical.sql'

Insert sample data into historical database:

- In the same prompt, enter \i 'path-to-insert_sampledata_historical.sql'








