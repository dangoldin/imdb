# IMDB Stats

This repo contains a series of queries and scripts to analyze IMDB data. The data was initially pulled via [http://imdbpy.sourceforge.net/](IMDbPY) and then loaded into both [MySQL](https://www.mysql.com/) and [MonetDB](https://www.monetdb.org/Home). The queries contain ways to migrate from one to the other as well as the R scripts necessary to load and visualize the resulting CSV files.

## Setup
- mysql-schema-updates.sql: By default the MySQL schema used by IMDbPy isn't properly indexed. This adds a few indices to make querying easier.
- monetdb-schema.sql: The schema in MonetDB for the subset of tables that will be used for the analysis.
- mysql-to-monetdb-migration.sql: The queries used to export data from MySQL as well as load them into MonetDB. Took a little bit of time to figure out how to deal with escaping and null values.

## Analysis
- analysis.sql: A variety of queries to help QA and understand the data.
- analysis-monetdb-to-csv-exports.sql: The actual queries used to generate CSV files that are fed into the analyze.R script.
- analyze.R: The R script to load the CSV files, manipulate them, and generate the visualizations.
