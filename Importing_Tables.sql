USE hospital;

SET FOREIGN_KEY_CHECKS = 0;
Set Global local_infile =1;



-- Importing Payer Table
LOAD DATA LOCAL INFILE 'D:/DA_Project/Hospital_Analysis/payers.csv'
INTO Table Payers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Importing Organization Table
LOAD DATA LOCAL INFILE 'D:/DA_Project/Hospital_Analysis/organizations.csv' 
INTO TABLE Organization
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Importing Patients table
LOAD DATA LOCAL INFILE 'D:/DA_Project/Hospital_Analysis/patients.csv'
INTO TABLE patients
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Importing Procedures Tables
LOAD DATA LOCAL INFILE 'D:/DA_Project/Hospital_Analysis/procedures.csv'
INTO TABLE Procedures
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Importing Encounters Table
LOAD DATA LOCAL INFILE 'D:/DA_Project/Hospital_Analysis/encounters.csv'
INTO TABLE Encounters
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 



SET FOREIGN_KEY_CHECKS = 1;