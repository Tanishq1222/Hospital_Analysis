Create Database hospital;
USE hospital;

Create Table Payers(
Id Varchar(40) Primary Key,
Name Varchar(80),
Address Varchar(200),
City varchar(25),
State_Headquartered varchar(50),
Zip INT,
Phone varchar(30)
);

Create Table Organization(
Id Varchar(40) Primary Key,
Name Varchar(50),
Address Varchar(200),
City varchar(50),
State Varchar(50),
Zip INT,
Lat Double,
Lon Double);

Create Table Procedures(
Start TimeStamp,
Stop TimeStamp,
Patient Varchar(50),
Encounter Varchar(50),
Code INT,
Description Varchar(250),
Base_cost INT,
ReasonCode INT,
ReasonDescription Varchar(200)
);

Create Table Encounters(
Id Varchar(50) Primary Key,
Start TimeStamp ,
Stop TimeStamp ,
Patient Varchar(50) ,
Organization Varchar(50) ,
Payer Varchar(50) ,
EncounterClass Varchar(25),
Code INT,
Description Varchar(250),
Base_Encounter_cost Float,
Total_Claim_Cost Float,
Payer_Coverage Float,
ReasonCode INT,
ReasonDescription Varchar(200)
);

Create Table Patients(
	Id Char(40) Primary Key,
    Birthdate Date,
    Deathdate Date,
    Prefix Varchar(10),
    First Varchar(100),
    Last Varchar(100),
    Suffix Varchar(10),
    Maiden Varchar(100),
    Marital Char(1),
    Race Varchar(50),
    Ethnicity Varchar(50),
    Gender Char(1),
    Birthplace Varchar(255),
    Address Varchar(255),
    City Varchar(100),
    State Varchar(100),
    Country Varchar(100),
    ZIP Varchar(10),
    LAT DOUBLE,
    LON DOUBLE
);


-- Foreign Key
ALTER TABLE Encounters
ADD Constraint fk_encounters_payers Foreign Key (Payer) References payers(id),
ADD Constraint fk_encounters_patients Foreign Key (Patient) References patients(id),
ADD Constraint fk_encounters_organization Foreign Key (Organization) References Organization(id);

ALTER TABLE Procedures
ADD Constraint fk_procedures_patients Foreign Key (Patient) References Patients(id),
ADD Constraint fk_procedures_encounters Foreign Key (Encounter) References Encounters(id)

