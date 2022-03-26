CREATE DATABASE INFO_430_Proj_06
USE INFO_430_Proj_06



 -----------------------------
 -- CREATE NON FK TABLES

CREATE TABLE tblREQUIREMENT
(RequirementID INT IDENTITY(1,1) PRIMARY KEY,
 RequirementName varchar(55) NOT NULL,
 RequirementDescr varchar(500) NULL)

 CREATE TABLE tblPURPOSE
(PurposeID INT IDENTITY(1,1) PRIMARY KEY,
 PurposeName varchar(55) NOT NULL,
 PurposeDescr varchar(500) NULL)

   CREATE TABLE tblPLANET
(PlanetID INT IDENTITY(1,1) PRIMARY KEY,
 PlanetName varchar(55) NOT NULL,
 PlanetfDescr varchar(500) NULL)

  CREATE TABLE tblSTAFF_TYPE
(StaffTypeID INT IDENTITY(1,1) PRIMARY KEY,
StaffTypeName varchar(50) NOT NULL,
StaffTypeDescr varchar(100) NULL)

CREATE TABLE tblLUGGAGE_TYPE
(LuggageTypeID INT IDENTITY(1,1) PRIMARY KEY,
 LuggageTypeName varchar(40) NOT NULL,
 LuggageTypeDescr varchar(200) NULL)

CREATE TABLE tblTRAVELER_TYPE
(TravelerTypeID INT IDENTITY(1,1) PRIMARY KEY,
 TravelerTypeName varchar(40) NOT NULL,
 TravelerTypeDescr varchar(200) NULL)

CREATE TABLE tblSPECIES
(SpeciesID INT IDENTITY(1,1) PRIMARY KEY,
 SpeciesName varchar(40) NOT NULL,
 SpeciesDescr varchar(200) NULL)

CREATE TABLE tblSPACECRAFT_STATUS 
(SCStatusID int IDENTITY(1,1) PRIMARY KEY,
 SCStatusName varchar(50) NOT NULL,
 SCStatusDescr varchar(500) NULL)

CREATE TABLE tblMANUFACTURER 
(MFRID int IDENTITY(1,1) PRIMARY KEY,
 MFRName varchar(50) NOT NULL,
 MFRDescr varchar(500) NULL)

CREATE TABLE tblCLASS
(ClassID int IDENTITY(1,1) PRIMARY KEY,
 ClassName varchar(50) NOT NULL,
 ClassDescr varchar(500) NULL,
 ClassLuggageLimit int NOT NULL)

CREATE TABLE tblSEAT_STATUS
(SeatStatusID int IDENTITY(1,1) PRIMARY KEY,
 SeatStatusName varchar(50) NOT NULL,
 SeatStatusDescr varchar(500) NULL)

CREATE TABLE tblREQUIREMENT_STATUS
(RequirementStatusID int IDENTITY(1,1) PRIMARY KEY,
RequirementStatusName varchar(55) NOT NULL,
RequirementStatusDescr varchar(500) NOT NULL)




------------------------------
-- CREATE TABLES WITH FKs

CREATE TABLE tblTRAVELER
(TravelerID INT IDENTITY(1,1) PRIMARY KEY,
 TravelerFname varchar(40) NOT NULL,
 TravelerLname varchar(40) NOT NULL,
 TravelerBirth DATE NOT NULL,
 TravelerTypeID INT FOREIGN KEY REFERENCES tblTRAVELER_TYPE(TravelerTypeID) NOT NULL,
 SpeciesID INT FOREIGN KEY REFERENCES tblSPECIES(SpeciesID) NOT NULL)

CREATE TABLE tblSPACECRAFT_MODEL
(SCModelID int IDENTITY(1,1) PRIMARY KEY,
 SCModelName varchar(50) NOT NULL,
 SCModelDescr varchar(500) NULL,
 MFRID int FOREIGN KEY REFERENCES tblMANUFACTURER(MFRID) NOT NULL)

CREATE TABLE tblSPACECRAFT
(SCID int IDENTITY(1,1) PRIMARY KEY,
 SCSerial varchar(50) NOT NULL,
 SCName varchar(50) NOT NULL,
 SCDescr varchar(500) NULL,
 SCModelID int FOREIGN KEY REFERENCES tblSPACECRAFT_MODEL(SCModelID) NOT NULL,
 SCStatusID int FOREIGN KEY REFERENCES tblSPACECRAFT_STATUS(SCStatusID) NOT NULL)

CREATE TABLE tblSPACEPORT
(SpaceportID INT IDENTITY(1,1) PRIMARY KEY,
 SpaceportName varchar(55) NOT NULL,
 SpaceportDescr varchar(500) NULL,
 PlanetID INT FOREIGN KEY REFERENCES tblPLANET (PlanetID) NOT NULL)

CREATE TABLE tblROUTE
(RouteID INT IDENTITY(1,1) PRIMARY KEY,
 SpaceportStartingID INT FOREIGN KEY REFERENCES tblSPACEPORT (SpaceportID) NOT NULL,
 SpaceportEndingID INT FOREIGN KEY REFERENCES tblSPACEPORT (SpaceportID) NOT NULL)

CREATE TABLE tblTRIP
(TripID INT IDENTITY(1,1) PRIMARY KEY,
TripName varchar(75) NOT NULL,
RouteID INT FOREIGN key REFERENCES tblROUTE (RouteID) NOT NULL,
DeparturingTime DATETIME NOT NULL,
ArrivalTime DATETIME NOT NULL,
SCID INT FOREIGN KEY REFERENCES tblSPACECRAFT(SCID) NOT NULL)


DROP TABLE tblSPACECRAFT_SEAT
DROP TABLE tblBOOKING
DROP TABLE tblBOOKING_REQUIREMENT
DROP TABLE tblLUGGAGE

CREATE TABLE tblSPACECRAFT_SEAT
(SCSeatID INT IDENTITY(1,1) PRIMARY KEY,
 SCID INT FOREIGN KEY REFERENCES tblSPACECRAFT(SCID) NOT NULL,
 SeatNumber INT NOT NULL,
 ClassID INT FOREIGN KEY REFERENCES tblCLASS(ClassID) NOT NULL)

CREATE TABLE tblBOOKING
(BookingID int IDENTITY(1,1) PRIMARY KEY,
 SCSeatID INT FOREIGN KEY REFERENCES tblSPACECRAFT_SEAT(SCSeatID) NOT NULL,
 TravelerID INT FOREIGN KEY REFERENCES tblTRAVELER(TravelerID) NOT NULL,
 TripID INT FOREIGN KEY REFERENCES tblTRIP(TripID) NOT NULL)

CREATE TABLE tblBOOKING_REQUIREMENT
(BookingRequirementID INT IDENTITY(1,1) PRIMARY KEY,
 BookingID INT FOREIGN KEY REFERENCES tblBOOKING (BookingID) NOT NULL,
 RequirementID INT FOREIGN KEY REFERENCES tblREQUIREMENT (RequirementID) NOT NULL,
 RequirementStatusID INT FOREIGN KEY REFERENCES tblREQUIREMENT_STATUS (RequirementStatusID) NOT NULL)

 CREATE TABLE tblTRIP_PURPOSE
(TripPurposeID INT IDENTITY(1,1) PRIMARY KEY,
 TripID INT FOREIGN KEY REFERENCES tblTRIP (TripID) NOT NULL,
 PurposeID INT FOREIGN KEY REFERENCES tblPURPOSE (PurposeID) NOT NULL)

 CREATE TABLE tblSTAFF
(StaffID INT IDENTITY(1,1) PRIMARY KEY,
StaffFName varchar(50) NOT NULL,
StaffLName varchar(50) NOT NULL,
StaffBirth DATE NOT NULL, 
StaffStart DATE NOT NULL,
StaffEnd DATE NULL,
StaffTypeID INT FOREIGN KEY REFERENCES tblSTAFF_TYPE (StaffTypeID) NOT NULL)


CREATE TABLE tblTRIP_STAFF
(TripStaffID INT IDENTITY(1,1) PRIMARY KEY,
TripID INT FOREIGN KEY REFERENCES tblTRIP (TripID) NOT NULL,
StaffID INT FOREIGN KEY REFERENCES tblSTAFF (StaffID) NOT NULL)


CREATE TABLE tblLUGGAGE
(LuggageID INT IDENTITY(1,1) PRIMARY KEY,
 Lugg_Weight DECIMAL(5,2) NOT NULL,
 BookingID INT FOREIGN KEY REFERENCES tblBOOKING(BookingID) NOT NULL,
 LuggageTypeID INT FOREIGN KEY REFERENCES tblLUGGAGE_TYPE(LuggageTypeID) NOT NULL)





---------------------------------------
-- POPULATE LOOK-UP TABLES


 INSERT INTO tblREQUIREMENT (RequirementName, RequirementDescr)
 VALUES ('COVID-19 Requirement', 'Fully vaccinated travelers can enter with proof of vaccination. Travelers who are not fully vaccinated require a negative PCR or antigen test performed within the 72 hours before traveling.'),
 ('Space Travel Certificate', 'Travelers must complete space travel info session and provide proof of Space Travel Safety Certificate to travel.'),
 ('Health & Safety Note', 'Travelers must proovide doctors note with written proof of good and stable physical health and mental stability in order to travel.')

INSERT INTO tblPURPOSE (PurposeName, PurposeDescr)
 VALUES ('Business', 'Visit other planets for the purpose of diplomacy or personal business.'),
 ('Tourism', 'Explore other planets for the purpose of tourism.'),
 ('Pleasure', 'Visit other planets for the purpose of vacation.'),
 ('Exploration', 'Visit other planets for the purpose of personal exploration.'),
 ('Science', 'Visit other planets for the purpose of discovering new things.')

INSERT INTO tblPLANET (PlanetName, PlanetfDescr)
 VALUES ('Mercury', 'The planet closest to the sun. It has an iron core that accounts for about 3/4 of its diameter. Most of the rest of the planet is made up of a rocky crust.'),
 ('Venus', 'Second planet closest to the sun. Venus is often called the sister planet of Earth'),
 ('Earth', 'Third planet away from the sun. The only planet known where life exists.'),
 ('Mars', 'Mars is known as the Red Planet. It is red because the soil looks like rusty iron.'),
 ('Jupiter', 'Fifth planet away from the sun. The planet Jupiter is the first of the gas giant planets.'),
 ('Saturn', 'Sixth planet away from the sun. The planet Jupiter is the first of the gas giant planets.'),
 ('Uranus', 'Seventh planet away from the sun. Uranus is so far from the Sun that it takes 84 years to complete an orbit of the Sun. It is the only planet that spins on its side'),
 ('Neptune', 'Eight planet away from the sun. Neptune takes a very long time—165 years—to orbit the Sun. It has made only one trip around the Sun since it was discovered.'),
 ('Pluto', 'Pluto is a dwarf planet in the Kuiper belt, a ring of bodies beyond the orbit of Neptune.')

INSERT INTO tblLUGGAGE_TYPE (LuggageTypeName, LuggageTypeDescr)
Values('Oversize-Overweight', '62in or greater, OR, 51+ LBS, flies in cargo'), 
('Checked', 'Flies in cargo'), 
('Carryon', 'Flies in cabin')

INSERT INTO tblTRAVELER_TYPE(TravelerTypeName, TravelerTypeDescr)
VALUES('Diplomat', 'A person appointed by a country or planet to conduct diplomacy with one or more other planets.'), 
('President', 'The elected head of a nation.'), 
('Civilian', 'A person not in diplomacy, armed forces, or science.'), 
('IPF Armed Forces', 'Flying on active duty.'),
('Scientist', 'Traveling for the purpose of science.'),
('Explorer', 'Traveling for the purpose of space exploration.')

INSERT INTO tblSTAFF_TYPE(StaffTypeName, StaffTypeDescr)
VALUES('Flight Attendant', 'Serves food, beverages, and supplies to customers'), 
('Cook', 'Prepares in-flight meals in the spaceship kitchen'), 
('Pilot', 'Responsible for navigation, communication with spaceports, and maneuvering the spacecraft'), 
('Co-pilot', 'Responsible for navigation and communication with spaceports'), 
('Security Officer', 'Surveys the cabin for security threats and dangerous behavior, intervening when necessary'), 
('Translator', 'Assists in translating Federation Language to local dialects'), 
('Engineer', 'Manages the engine room'), 
('Entertainer', 'Provides customers with in-flight entertainment')

INSERT INTO tblSPACECRAFT_STATUS ( SCStatusName, SCStatusDescr)
VALUES ('Active', 'A spacecraft is on active status.'),
('Under construction', 'A spacecraft is on under construction status.'),
('Retired', 'A spacecraft is on retired status.')

INSERT INTO tblMANUFACTURER ( MFRName, MFRDescr)
VALUES ('SpaceX', 'Space Exploration Technologies Corporation.'),
('Boeing', 'The Boeing Company.'),
('McDonnell', 'McDonnell Aircraft Corporation.')

INSERT INTO tblCLASS (ClassName, ClassDescr, ClassLuggageLimit)
VALUES ('First', 'First travel class.', 70),
('Business', 'Business travel class.', 140),
('Economy', 'Economy travel class.', 210)

INSERT INTO tblSEAT_STATUS ( SeatStatusName, SeatStatusDescr)
VALUES ('Available', 'The seat is available.'),
('Unavailable', 'The seat is unoccupied but unavailable.'),
('Occupied', 'The seat is occupied.')

INSERT INTO tblREQUIREMENT_STATUS
VALUES ('Complete', 'Requirement is complete and varified.'),
('Incomplete', 'Requirement is incomplete nor varified.'),
('Pending', 'Requirement iss incomplete and/or not varified.')

INSERT INTO tblSPECIES
VALUES ('Navi', 'Tall and blue with a question tail thing'),
       ('Asogians', 'Short and stubby but lovely'),
       ('Acklay', 'Large Praying mantis'),
       ('Fizzgigs', 'very fluffy'),
       ('Human', 'humanoid species from the planet Earth'),
       ('Martian', 'humanoid species from the planet Mars'),
       ('The Thing','very rare and if you see, kick off ship!'),
       ('Horkons','large with horns')



------------------------------
-- POPULATING NON-LOOKUP TABLES

INSERT INTO tblSTAFF (StaffFName, StaffLName, StaffBirth, StaffStart, StaffEnd, StaffTypeID)
VALUES ('Stephanie', 'Walsh', '1953-08-25', 2013-10-25, NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Engineer')),
('Chelsea', 'Perkins', '1969-03-26', 2010-09-07, NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Co-pilot')),
('James', 'Lau', '1978-12-11', '2019-20-03', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Security Officer')),
('Opal', 'Walker', '1983-05-14', '2007-09-25', '2021-05-23', (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Translator')),
('Jason', 'Morris', '1992-03-14', '2019-05-28', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Engineer')),
('Michael', 'Lunsford', '1998-03-26', '2019-20-03', '2021-07-13', (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Entertainer')),
('Helen', 'Bartlett', '192-02-05', '2018-11-23', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Cook')),
('Allen', 'Soto', '1993-05-01', '2020-10-21', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Flight Attendant'))

INSERT INTO tblSPACECRAFT_MODEL
VALUES ('Dragon 2', 'A spacecraft designed for flights to the International Space Station (ISS).', (SELECT MFRID FROM tblMANUFACTURER WHERE MFRName = 'SpaceX')),
       ('CST-100 Starliner', 'A spacecraft designed for flights to the International Space Station (ISS) and other low-Earth orbit destinations.', (SELECT MFRID FROM tblMANUFACTURER WHERE MFRName = 'Boeing')),
       ('Mercury', 'A spacecraft designed for suborbital flights.', (SELECT MFRID FROM tblMANUFACTURER WHERE MFRName = 'McDonnell'))

INSERT INTO tblSPACECRAFT
VALUES ('C206', 'Endeavour', 'A Crew Dragon spacecraft.', (SELECT SCModelID FROM tblSPACECRAFT_MODEL WHERE SCModelName = 'Dragon 2'), (SELECT SCStatusID FROM tblSPACECRAFT_STATUS WHERE SCStatusName = 'Active')),
       ('Spacecraft 3', 'Calypso', 'A Starliner spacecraft.', (SELECT SCModelID FROM tblSPACECRAFT_MODEL WHERE SCModelName = 'CST-100 Starliner'), (SELECT SCStatusID FROM tblSPACECRAFT_STATUS WHERE SCStatusName = 'Under construction')),
       ('No. 7', 'Freedom 7', 'A Mercury spacecraft.', (SELECT SCModelID FROM tblSPACECRAFT_MODEL WHERE SCModelName = 'Mercury'), (SELECT SCStatusID FROM tblSPACECRAFT_STATUS WHERE SCStatusName = 'Retired'))

INSERT INTO tblSTAFF (StaffFName, StaffLName, StaffBirth, StaffStart, StaffEnd, StaffTypeID)
VALUES('Lenoard', 'Nimoy', '1931-03-26', '2012-08-21', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Pilot')),
      ('Bach', 'Steven', '1969-03-26', '2008-09-01', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Co-pilot')),
      ('LeStrange', 'Beatrix', '1980-11-12', '2013-05-01', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Security Officer')),
      ('Gears', 'Paul', '1979-12-05', '2007-05-27', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Translator')),
      ('Sanderson', 'Sarah', '1991-07-16', '2018-01-23', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Engineer')),
      ('Sanchez', 'Elena', '1998-12-26', '2019-10-31', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Entertainer')),
      ('Spacehouse', 'Nick', '1996-08-03', '2019-10-21', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Cook')),
      ('King', 'Victor', '1999-04-11', '2019-10-21', NULL, (select StaffTypeID from tblSTAFF_TYPE where StaffTypeName = 'Flight Attendant'))

INSERT INTO tblSPACEPORT (SpaceportName, SpaceportDescr, PlanetID)
VALUES ('Main Mercury Spaceport', 'The main Mercury Spaceport.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Mercury')),
('South Mercury Spaceport', 'The Murcury Spaceport located in the southern region of the planet.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Mercury')),
('Travel Venus', 'The main Spaceport in Venus.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Venus')),
('Venus 2.0', 'The second major spaceport in Venus.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Venus')),
('Spaceport California', 'Spaceport on Earth located in California.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Earth')),
('Spaceport Texas', 'Spaceport on Earth located in Texas.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Earth')),
('Russia SP', 'Spaceport on Earth located in Russia.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Earth')),
('China SP', 'Spaceport on Earth located in China.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Earth')),
('SpaceTravel Red', 'The main spaceport on Mars.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Mars')),
('Jupiter SP', 'The main spaceport on Jupiter.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Jupiter')),
('Main Saturn SP', 'The main spaceport on Saturn.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Saturn')),
('South Saturn SP', 'The Saturn Spaceport located in the southern region of the planet.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Saturn')),
('Travel Uranus', 'The main spaceport on Uranus.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Uranus')),
('Neptune SP', 'The main spaceport on Neptune.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Neptune')),
('SpaceTravel Pluto', 'The main spaceport on Pluto.', (SELECT PlanetID FROM tblPLANET WHERE PlanetName = 'Pluto'))

INSERT INTO tblROUTE (SpaceportStartingID, SpaceportEndingID)
VALUES ((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Venus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Venus 2.0')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Mercury Spaceport')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport California')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Spaceport Texas')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Russia SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'China SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Red')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Jupiter SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Main Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'South Saturn SP')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Travel Uranus')),
((SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'SpaceTravel Pluto'), (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = 'Neptune SP'))
GO



------------------------------
-- INSERT INTO tblTRAVELER

SELECT *
INTO NameImport
FROM Peeps.dbo.tblcustomer

GO

CREATE OR ALTER PROCEDURE insertTraveler
    @TravelerFN varchar(50),
    @TravelerLN varchar(50),
    @TravelerDOB DATE,
    @TravTypeName varchar(50),
    @Species varchar(50)
AS
    DECLARE @SpecID INT, 
        @TravTypeID INT

    SET @SpecID = (
        SELECT S.SpeciesID 
        FROM tblSpecies S 
        WHERE S.SpeciesName = @Species
    )

    SET @TravTypeID = (
        SELECT TP.TravelerTypeID 
        FROM tblTRAVELER_TYPE TP 
        WHERE TP.TravelerTypeName = @TravTypeName
    )

    INSERT INTO tblTRAVELER (TravelerFName, TravelerLName, TravelerBirth, SpeciesID, TravelerTypeID)
    VALUES (@TravelerFN, @TravelerLN, @TravelerDOB, @SpecID, @TravTypeID)
GO

CREATE OR ALTER PROCEDURE insertTravelerWrapper
    @RUN INT
--randomly find traveler fn ln dob via random pk
AS 

DECLARE @SpeciesName varchar(50)

DECLARE @TravelerFN1 varchar(50)
DECLARE @TravelerLN1 varchar(50)
DECLARE @TravelerDOB1 DATE

DECLARE @TravTypeName1 varchar(50)

WHILE @RUN > 0
BEGIN
    DECLARE @COUNT INT = (SELECT COUNT(*) from NameImport)
    DECLARE @T_ID INT = RAND() * @COUNT + 1

    DECLARE @COUNT2 INT = (SELECT COUNT(*) FROM tblSPECIES)
    DECLARE @S_ID INT = RAND() * @COUNT2 + 1

    DECLARE @COUNT3 INT = (SELECT COUNT(*) FROM tblTRAVELER_TYPE)
    DECLARE @TT_ID INT = RAND() * @COUNT3 + 1

    --deals with getting traveler info
    SET @TravelerFN1 = (SELECT NA.CustomerFname FROM NameImport NA WHERE NA.CustomerID = @T_ID)
    SET @TravelerLN1 = (SELECT NA.CustomerLname FROM NameImport NA WHERE NA.CustomerID = @T_ID)
    SET @TravelerDOB1 = (SELECT NA.DateOfBirth FROM NameImport NA WHERE NA.CustomerID = @T_ID)

    IF NOT EXISTS (
        SELECT *
        FROM tblTRAVELER
        WHERE TravelerFname = @TravelerFN1
            AND TravelerLname = @TravelerLN1
            AND TravelerBirth = @TravelerDOB1
    )
    BEGIN
    --deals with getting Species/TravelerType info
        SET @SpeciesName = (SELECT S.SpeciesName FROM tblSpecies S WHERE @S_ID = S.SpeciesID)
        SET @TravTypeName1 = (SELECT TTN.TravelerTypeName FROM tblTRAVELER_TYPE TTN WHERE @TT_ID = TTN.TravelerTypeID)

        EXEC insertTraveler
        @TravelerFN = @TravelerFN1,
        @TravelerLN = @TravelerLN1,
        @TravelerDOB = @TravelerDOB1,
        @TravTypeName = @TravTypeName1,
        @Species = @SpeciesName
    END

    SET @RUN = @RUN - 1
END
GO

EXEC insertTravelerWrapper
@RUN = 10000

GO


------------------------------
-- INSERT INTO tblTRIP

CREATE OR ALTER PROCEDURE GetRouteID
@SpaceportStart varchar(50),
@SpaceportEnd varchar(50),
@R_ID INT OUTPUT
AS
SET @R_ID = (SELECT r.RouteID 
             FROM tblROUTE r
             RIGHT JOIN tblSPACEPORT s ON s.SpaceportID = r.SpaceportEndingID
             WHERE r.SpaceportEndingID = (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = @SpaceportEnd)
             AND r.SpaceportStartingID = (SELECT SpaceportID FROM tblSPACEPORT WHERE SpaceportName = @SpaceportStart))
             

GO



CREATE OR ALTER PROCEDURE GetSpacecraftID
@SCSerial varchar(50),
@SCName varchar(50),
@SC_ID INT OUTPUT
AS
SET @SC_ID = (SELECT SCID FROM tblSPACECRAFT WHERE SCSerial = @SCSerial AND SCName = @SCName)
GO


--base
CREATE OR ALTER PROCEDURE INSERT_TRIP
@TripName varchar(50),
@SpaceportStart varchar(50),
@SpaceportEnd varchar(50),
@DTime DATETIME,
@ATime DATETIME,
@SCSerial varchar(50),
@SCName varchar(50)
AS
DECLARE @R_ID INT, @SC_ID INT

EXEC GetRouteID
@SpaceportStart = @SpaceportStart,
@SpaceportEnd = @SpaceportEnd,
@R_ID = @R_ID OUTPUT

IF @R_ID IS NULL
    BEGIN
        PRINT '@R_ID does not exist';
        THROW 50000, 'The Route does not exist.', 1;
    END

EXEC GetSpacecraftID
@SCSerial = @SCSerial,
@SCName = @SCName,
@SC_ID = @SC_ID OUTPUT

IF @SC_ID IS NULL
    BEGIN
        PRINT '@SC_ID does not exist';
        THROW 50000, 'The Spacecraft does not exist.', 1;
    END

BEGIN TRAN T1
INSERT INTO tblTRIP (TripName, RouteID, DeparturingTime, ArrivalTime, SCID)
VALUES (@TripName, @R_ID, @DTime, @ATime, @SC_ID)
IF @@ERROR <> 0
  ROLLBACK TRAN T1
ELSE
  COMMIT TRAN T1

GO

SELECT * FROM tblTRIP
GO


-- wrapper
CREATE OR ALTER PROCEDURE INSERT_TRIPS_WRAPPER
@RUN INT
AS

DECLARE @ROUTE_COUNT INT = (SELECT COUNT(*) FROM tblROUTE)
DECLARE @SC_COUNT INT = (SELECT COUNT(*) FROM tblSPACECRAFT)
DECLARE @TName varchar(100), @R_ID INT, @SC_ID INT, @PortName1 varchar(50), @PortName2 varchar(50), @DTIME DATETIME, @ATIME DATETIME, @SC_SERIAL varchar(50), @SC_Name varchar(50)

WHILE @RUN > 0
  BEGIN
  SET @R_ID = (SELECT Rand() * @ROUTE_COUNT + 1)
  SET @DTIME = (SELECT getDate() - rand () * 1000)
  SET @ATIME = (SELECT @DTIME + RAND() * 1000)
  SET @PortName1 = (SELECT SpaceportName 
                    FROM tblROUTE r 
                    RIGHT JOIN tblSPACEPORT s ON s.SpaceportID = r.SpaceportStartingID
                    WHERE r.RouteID = @R_ID)
  SET @PortName2 = (SELECT SpaceportName 
                    FROM tblROUTE r 
                    RIGHT JOIN tblSPACEPORT s ON s.SpaceportID = r.SpaceportEndingID
                    WHERE r.RouteID = @R_ID)
  SET @TName = @PortName1 + ' TO ' + @PortName2 + ' AT ' + CAST(@DTIME AS varchar)
  SET @SC_ID = (SELECT Rand() * @SC_COUNT + 1)
  SET @SC_SERIAL = (SELECT SCSerial FROM tblSPACECRAFT WHERE SCID = @SC_ID)
  SET @SC_Name = (SELECT SCName FROM tblSPACECRAFT WHERE SCID = @SC_ID)


  EXEC INSERT_TRIP
  @TripName = @TName,
  @SpaceportStart = @PortName1,
  @SpaceportEnd = @PortName2,
  @DTime = @DTIME,
  @ATime = @ATIME,
  @SCSerial = @SC_SERIAL,
  @SCName = @SC_Name

  SET @RUN = @RUN -1
  END

EXEC INSERT_TRIPS_WRAPPER
@RUN = 1000000

GO


----------------------------------
-- INSERT INTO tblSPACECRAFT_SEAT

CREATE OR ALTER PROCEDURE GetSpacecraftID
@SCSerial varchar(50),
@SCName varchar(50),
@SC_ID INT OUTPUT
AS
SET @SC_ID = (SELECT SCID FROM tblSPACECRAFT WHERE SCSerial = @SCSerial AND SCName = @SCName)
GO


CREATE OR ALTER PROCEDURE GetClassID
@ClassName varchar(50),
@C_ID INT OUTPUT
AS
SET @C_ID = (SELECT ClassID FROM tblCLASS WHERE ClassName = @ClassName)
GO

--base
CREATE OR ALTER PROCEDURE INSERT_SPACECRAFT_SEAT
@SCSerial varchar(50),
@SCName varchar(50),
@SeatNum INT,
@ClassName varchar(50)
AS
DECLARE @SC_ID INT, @C_ID INT

EXEC GetSpacecraftID
@SCSerial = @SCSerial,
@SCName = @SCName,
@SC_ID = @SC_ID OUTPUT

IF @SC_ID IS NULL
    BEGIN
        PRINT '@SC_ID does not exist.';
        THROW 50002, 'The Spacecraft does not exist.', 1;
    END

EXEC GetClassID
@ClassName = @ClassName,
@C_ID = @C_ID OUTPUT

IF @C_ID IS NULL
    BEGIN
        PRINT '@C_ID does not exist.';
        THROW 50002, 'The Class does not exist.', 1;
    END

BEGIN TRAN T1
INSERT INTO tblSPACECRAFT_SEAT (SCID, SeatNumber, ClassID)
VALUES (@SC_ID, @SeatNum, @C_ID)
IF @@ERROR <> 0
  ROLLBACK TRAN T1
ELSE 
  COMMIT TRAN T1

GO

-------------------------------
-- populate tblSPACECRAFT_SEAT

DECLARE @SPACECRAFT_COUNT INT = (SELECT COUNT(*) FROM tblSPACECRAFT)
DECLARE @CLASS_COUNT INT = (SELECT COUNT(*) FROM tblCLASS)
DECLARE @SeatNum INT = 0
DECLARE @SC_ID INT, @C_ID INT, @SCSerial varchar(50), @SCName varchar(50), @CName varchar(50)
SELECT * INTO TEMP_SC FROM tblSPACECRAFT

WHILE @SPACECRAFT_COUNT > 0
  BEGIN
  PRINT @SPACECRAFT_COUNT
  SET @SC_ID = (SELECT MAX(SCID) FROM TEMP_SC)
  SET @SCSerial = (SELECT SCSerial FROM tblSPACECRAFT WHERE SCID = @SC_ID)
  SET @SCName = (SELECT SCName FROM tblSPACECRAFT WHERE SCID = @SC_ID)
  SET @SeatNum = @SeatNum + 1
  IF @SeatNum = 36
    BEGIN
    SET @SeatNum = 0
    SET @SPACECRAFT_COUNT = @SPACECRAFT_COUNT - 1 
    DELETE FROM TEMP_SC WHERE SCID = @SC_ID
    END
  ELSE
    BEGIN
    IF @SeatNum < 10
      SET @CName = 'First'
    ELSE 
      IF @SeatNum > 9 AND @SeatNum < 20
        SET @CName = 'Business'
      ELSE
        IF @SeatNum > 19 AND @SeatNum < 36
          SET @CName = 'Economy'
    EXEC INSERT_SPACECRAFT_SEAT
    @SCSerial = @SCSerial,
    @SCName = @SCName,
    @SeatNum = @SeatNum,
    @ClassName = @CName
    END
  END

DROP TABLE TEMP_SC
GO


------------------------------
-- INSERT INTO tblBOOKING

CREATE OR ALTER PROCEDURE GetSCSeatID
@SC_Name varchar(50),
@SeatNum INT,
@SCS_ID INT OUTPUT
AS
SET @SCS_ID = (SELECT SCSeatID 
               FROM tblSPACECRAFT_SEAT ss
               JOIN tblSPACECRAFT s ON s.SCID = ss.SCID
               WHERE s.SCName = @SC_Name
               AND ss.SeatNumber = @SeatNum)
GO

CREATE OR ALTER PROCEDURE GetTravelerID
@TravelerFName varchar(50),
@TravelerLName varchar(50),
@TravelerBDate DATE,
@T_ID INT OUTPUT
AS
SET @T_ID = (SELECT TravelerID 
             FROM tblTRAVELER 
             WHERE TravelerFname = @TravelerFName
             AND TravelerLname = @TravelerLName
             AND TravelerBirth = @TravelerBDate)
GO

CREATE OR ALTER PROCEDURE GetTripID
@TripName varchar(100),
@T_ID INT OUTPUT
AS
SET @T_ID = (SELECT TripID FROM tblTRIP WHERE TripName = @TripName)
GO

--base

CREATE OR ALTER PROCEDURE INSERT_BOOKING
@SC_Name varchar(50),
@SeatNum INT,
@TravelerFName varchar(50),
@TravelerLName varchar(50),
@TravelerBDate varchar(50),
@TripName varchar(100)
AS
DECLARE @SCS_ID INT, @T_ID INT, @TR_ID INT

EXEC GetSCSeatID
@SC_Name = @SC_Name,
@SeatNum = @SeatNum,
@SCS_ID = @SCS_ID OUTPUT

IF @SCS_ID IS NULL
    BEGIN
        PRINT '@SCS_ID does not exist.';
        THROW 50002, 'The SeatClass does not exist.', 1;
    END

EXEC GetTravelerID
@TravelerFName = @TravelerFName,
@TravelerLName = @TravelerLName,
@TravelerBDate = @TravelerBDate,
@T_ID = @T_ID OUTPUT

IF @T_ID IS NULL
    BEGIN
        PRINT '@T_ID does not exist.';
        THROW 50002, 'The Traveler does not exist.', 1;
    END

EXEC GetTripID
@TripName = @TripName,
@T_ID = @TR_ID OUTPUT

IF @TR_ID IS NULL
    BEGIN
        PRINT '@TR_ID does not exist.';
        THROW 50002, 'The Trip does not exist.', 1;
    END

BEGIN TRAN T1
INSERT INTO tblBOOKING (SCSeatID, TravelerID, TripID)
VALUES (@SCS_ID, @T_ID, @TR_ID)
IF @@ERROR <> 0
  ROLLBACK TRAN T1
ELSE
  COMMIT TRAN T1

GO

SELECT * FROM tblBOOKING
GO
-- wrapper

CREATE OR ALTER PROCEDURE INSERT_BOOKING_WRAPPER
@RUN INT
AS
DECLARE @SCS_COUNT INT = (SELECT COUNT(*) FROM tblSPACECRAFT_SEAT)
DECLARE @TRAVELER_COUNT INT = (SELECT COUNT(*) FROM tblTRAVELER)
DECLARE @TRIP_COUNT INT = (SELECT COUNT(*) FROM tblTRIP)
DECLARE @SCS_ID INT, @T_ID INT, @TR_ID INT, @SC_Name varchar(50), @SeatNum INT, @TFName varchar(50), @TLName varchar(50), @TBD DATE, @TripName varchar(50)

WHILE @RUN > 0
  BEGIN
  SET @SCS_ID = (RAND() * @SCS_COUNT + 1)
  SET @T_ID = (RAND() * @TRAVELER_COUNT + 1)
  SET @TR_ID = (RAND() * @TRIP_COUNT + 1)
  SET @SC_Name = (SELECT s.SCName 
                  FROM tblSPACECRAFT s 
                  JOIN tblSPACECRAFT_SEAT ss ON ss.SCID = s.SCID
                  WHERE ss.SCSeatID = @SCS_ID)
  SET @SeatNum = (SELECT ss.SeatNumber
                  FROM tblSPACECRAFT s 
                  JOIN tblSPACECRAFT_SEAT ss ON ss.SCID = s.SCID
                  WHERE ss.SCSeatID = @SCS_ID)
  SET @TFName = (SELECT TravelerFName FROM tblTRAVELER WHERE TravelerID = @T_ID)
  SET @TLName = (SELECT TravelerLName FROM tblTRAVELER WHERE TravelerID = @T_ID)
  SET @TBD = (SELECT TravelerBirth FROM tblTRAVELER WHERE TravelerID = @T_ID)
  SET @TripName = (SELECT TripName FROM tblTRIP WHERE TripID = @TR_ID)


  EXEC INSERT_BOOKING
  @SC_Name = @SC_Name,
  @SeatNum = @SeatNum,
  @TravelerFName = @TFName,
  @TravelerLName = @TLName,
  @TravelerBDate = @TBD,
  @TripName = @TripName

  SET @RUN = @RUN - 1
  END


EXEC INSERT_BOOKING_WRAPPER
@RUN = 10000
GO



--------------------------------------
-- INSERT INTO tblBOOKING_REQUIREMENT

CREATE OR ALTER PROCEDURE GetBookingID
    @TravelerFName varchar(50),
    @TravelerLName varchar(50),
    @TravelerBirth date,
    @TripName varchar(50),
    @SpacecraftName varchar(50),
    @SeatNum INT,
    @BookingID int OUTPUT
AS
    SET @BookingID = (
        SELECT b.BookingID
        FROM tblBOOKING b 
        JOIN tblTRAVELER t ON t.TravelerID = b.TravelerID
        JOIN tblSPACECRAFT_SEAT st ON st.SCSeatID = b.SCSeatID
        JOIN tblTRIP tr ON tr.TripID = b.TripID
        JOIN tblSPACECRAFT s ON s.SCID = st.SCID
        WHERE t.TravelerFname = @TravelerFName
        AND t.TravelerLname = @TravelerLName
        AND t.TravelerBirth = @TravelerBirth
        AND tr.TripName = @TripName
        AND s.SCName = @SpacecraftName
        AND st.SeatNumber = @SeatNum
    )
GO

CREATE OR ALTER PROCEDURE GetRequirementID
    @RequirementName varchar(50),
    @RequirementID int OUTPUT
AS
    SET @RequirementID = (
        SELECT RequirementID
        FROM tblREQUIREMENT
        WHERE RequirementName = @RequirementName
    )
GO

CREATE OR ALTER PROCEDURE GetRequirementStatusID
    @RequirementStatusName varchar(50),
    @RequirementStatusID int OUTPUT
AS
    SET @RequirementStatusID = (
        SELECT RequirementStatusID
        FROM tblREQUIREMENT_STATUS
        WHERE RequirementStatusName = @RequirementStatusName
    )
GO

-- Base.
CREATE OR ALTER PROCEDURE Insert_BOOKING_REQUIREMENT
    @TravelerFName varchar(50),
    @TravelerLName varchar(50),
    @TravelerBirth varchar(50),
    @TripName varchar(50),
    @SpacecraftName varchar(50),
    @SeatNum INT,
    @RequirementName varchar(50),
    @RequirementStatusName varchar(50)
AS
    DECLARE @BookingID int,
        @RequirementID int,
        @RequirementStatusID int



    EXEC GetBookingID
    @TravelerFName = @TravelerFName,
    @TravelerLName = @TravelerLName,
    @TravelerBirth = @TravelerBirth,
    @TripName = @TripName,
    @SpacecraftName = @SpacecraftName,
    @SeatNum = @SeatNum,
    @BookingID = @BookingID OUTPUT
    
    IF @BookingID IS NULL
    BEGIN
        PRINT 'The Booking does not exist.';
        THROW 50000, '@BookingID does not exist.', 1;
    END

    EXEC GetRequirementID
        @RequirementName,
        @RequirementID OUTPUT
    
    IF @RequirementID IS NULL
    BEGIN
        PRINT 'The requirement ' + @RequirementName + ', does not exist.';
        THROW 50001, 'The requirement does not exist.', 1;
    END

    EXEC GetRequirementStatusID
        @RequirementStatusName,
        @RequirementStatusID OUTPUT

    IF @RequirementStatusID IS NULL
    BEGIN
        PRINT 'The requirement status, ' + @RequirementStatusName + ', does not exist.';
        THROW 50002, 'The requirement status does not exist.', 1;
    END

    IF EXISTS (
        SELECT bk.BookingRequirementID 
        FROM tblBOOKING b
        JOIN tblBOOKING_REQUIREMENT bk ON bk.BookingID = b.BookingID
        WHERE bk.BookingID = @BookingID 
            AND bk.RequirementID = @RequirementID
    )
    BEGIN
        BEGIN TRAN T1
            UPDATE tblBOOKING_REQUIREMENT
            SET RequirementStatusID = @RequirementStatusID
            WHERE BookingID = @BookingID 
                AND RequirementID = @RequirementID
        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
    END
    ELSE
    BEGIN
        BEGIN TRAN T2
            INSERT INTO tblBOOKING_REQUIREMENT
            VALUES(@BookingID, @RequirementID, @RequirementStatusID)
        IF @@ERROR <> 0
            ROLLBACK TRAN T2
        ELSE
            COMMIT TRAN T2
    END
GO


-- Wrapper.
CREATE OR ALTER PROCEDURE PopulateBOOKING_REQUIREMENT
    @Run int
AS
    WHILE @Run > 0
    BEGIN
        DECLARE @TravelerID int = (SELECT COUNT(*) FROM tblTRAVELER) * RAND() + 1,
            @TravelerFName varchar(50),
            @TravelerLName varchar(50),
            @TravelerBirth varchar(50),
            @RequirementID int = (SELECT COUNT(*) FROM tblREQUIREMENT) * RAND() + 1,
            @RequirementName varchar(50),
            @RequirementStatusID int = (SELECT COUNT(*) FROM tblREQUIREMENT_STATUS) * -LOG(1 - RAND()) / 2.9 + 1,
            @RequirementStatusName varchar(50),
            @TripName varchar(50),
            @BookingID INT = (SELECT COUNT(*) FROM tblBOOKING) * RAND() + 1,
            @SC_ID INT = (SELECT COUNT(*) FROM tblSPACECRAFT_SEAT) * RAND() + 1,
            @SC_Name varchar(50),
            @SeatNum INT

        SELECT @TravelerFName = t.TravelerFName,
           @TravelerLName = t.TravelerLName, 
           @TravelerBirth = t.TravelerBirth
        FROM tblTRAVELER t 
        JOIN tblBOOKING b ON b.TravelerID = t.TravelerID
        WHERE b.BookingID = @BookingID

        SELECT @TripName = tr.TripName
        FROM tblTRIP tr 
        JOIN tblBOOKING b ON b.TripID = tr.TripID
        WHERE b.BookingID = @BookingID

        SELECT @RequirementName = RequirementName
        FROM tblREQUIREMENT
        WHERE RequirementID = @RequirementID

        SELECT @RequirementStatusName = RequirementStatusName
        FROM tblREQUIREMENT_STATUS
        WHERE RequirementStatusID = @RequirementStatusID

        SELECT @SC_Name = s.SCName
        FROM tblSPACECRAFT_SEAT sc
        JOIN tblSPACECRAFT s ON s.SCID = sc.SCID
        JOIN tblBOOKING b ON b.SCSeatID = sc.SCSeatID
        WHERE b.BookingID = @BookingID

        SELECT @SeatNum = sc.SeatNumber
        FROM tblSPACECRAFT_SEAT sc
        JOIN tblBOOKING b ON b.SCSeatID = sc.SCSeatID
        WHERE b.BookingID = @BookingID
        

        EXEC Insert_BOOKING_REQUIREMENT
        @TravelerFName = @TravelerFName,
        @TravelerLName = @TravelerLName,
        @TravelerBirth = @TravelerBirth,
        @TripName = @TripName,
        @SpacecraftName = @SC_Name,
        @SeatNum = @SeatNum,
        @RequirementName = @RequirementName,
        @RequirementStatusName = @RequirementStatusName

        SET @Run = @Run - 1 
    END
GO

EXEC PopulateBOOKING_REQUIREMENT
    10000



------------------------------
-- INSERT INTO tblLUGGAGE

DECLARE @BOOKING_COUNT INT = (SELECT COUNT(*) FROM tblBOOKING)

WHILE @BOOKING_COUNT > 0
  BEGIN
    DECLARE @BookingID INT = RAND() * @BOOKING_COUNT + 1
    DECLARE @RandWeight DECIMAL(5,2) = ROUND((RAND() * 46 + 1), 2)
    DECLARE @LuggTypeID INT = ROUND(RAND()*(1-6)+6 , 0)

    INSERT INTO tblLUGGAGE (Lugg_Weight, BookingID, LuggageTypeID)
    VALUES (@RandWeight, @BookingID, @LuggTypeID)

    SET @BOOKING_COUNT = @BOOKING_COUNT - 1
  END


GO



-------------------------------
-- INSERT INTO tblTRIP_PURPOSE

CREATE OR ALTER PROCEDURE GetPurposeID
@PurposeName varchar(55),
@P_ID INT OUTPUT
AS
SET @P_ID = (SELECT PurposeID
             FROM tblPURPOSE 
             WHERE PurposeName = @PurposeName)
GO


-- base

CREATE OR ALTER PROCEDURE INSERT_TRIP_PURPOSE
@TripName varchar(55),
@PurposeName varchar(55)
AS
DECLARE @T_ID INT, @P_ID INT

EXEC GetTripID
@TripName = @TripName,
@T_ID = @T_ID OUTPUT

IF @T_ID IS NULL
    BEGIN
        PRINT 'Looks like TripID might be null. Try again.'
        RAISERROR ('@T_ID is null.', 11, 1)
        RETURN
    END

EXEC GetPurposeID
@PurposeName = @PurposeName,
@P_ID = @P_ID OUTPUT

IF @P_ID IS NULL
    BEGIN
        PRINT 'Looks like PurposeID might be null. Try again.'
        RAISERROR ('@P_ID is null.', 11, 1)
        RETURN
    END

BEGIN TRAN T1
INSERT INTO tblTRIP_PURPOSE (TripID, PurposeID)
VALUES (@T_ID, @P_ID)

IF @@ERROR <> 0
    BEGIN
        Print 'Something does not look right'
        Rollback TRAN T1
    END
ELSE
    COMMIT TRAN T1


GO


-- wrapper

CREATE OR ALTER PROCEDURE Wrapper_INSERT_TripPurpose
@RUN INT
AS
DECLARE @TRIP_COUNT INT = (SELECT COUNT(*) FROM tblTRIP)
DECLARE @PURPOSE_COUNT INT = (SELECT COUNT(*) FROM tblPURPOSE)
DECLARE @T_ID INT, @TName varchar(55), @PName varchar(55), @P_ID INT


WHILE @RUN > 0
    BEGIN

    SET @P_ID = (RAND() * @PURPOSE_COUNT + 1)
    SET @PName = (SELECT PurposeName FROM tblPURPOSE WHERE PurposeID = @P_ID)
    SET @T_ID = (RAND() * @TRIP_COUNT + 1)
    SET @TName = (SELECT TripName FROM tblTRIP WHERE TripID = @T_ID)



    EXEC [dbo].[INSERT_TRIP_PURPOSE]
    @TripName = @TName,
    @PurposeName = @PName


    SET @Run = @Run - 1
    END


EXEC Wrapper_INSERT_TripPurpose
@RUN = 10000

GO



------------------------------
-- INSERT INTO tblTRIP_STAFF

CREATE OR ALTER PROCEDURE GetStaffID
@StaffFName varchar(50),
@StaffLName varchar(50),
@StaffBirth DATE, 
@S_ID INT OUTPUT
AS
SET @S_ID = (SELECT StaffID 
             FROM tblSTAFF 
             WHERE StaffFName = @StaffFName
             AND StaffLName = @StaffLName
             AND StaffBirth = @StaffBirth)

GO

CREATE OR ALTER PROCEDURE INSERT_TRIP_STAFF
@StaffFName varchar(50),
@StaffLName varchar(50),
@StaffBirth DATE,
@TripName varchar(50)
AS
DECLARE @T_ID INT, @S_ID INT

EXEC GetTripID
@TripName = @TripName,
@T_ID = @T_ID OUTPUT

IF @T_ID IS NULL
    BEGIN
        PRINT 'Looks like TripID might be null. Try again.'
        RAISERROR ('@T_ID is null.', 11, 1)
        RETURN
    END

EXEC GetStaffID
@StaffFName = @StaffFName,
@StaffLName = @StaffLName,
@StaffBirth = @StaffBirth,
@S_ID = @S_ID OUTPUT

IF @S_ID IS NULL
    BEGIN
        PRINT 'Looks like StaffID might be null. Try again.'
        RAISERROR ('@S_ID is null.', 11, 1)
        RETURN
    END

BEGIN TRAN T1
INSERT INTO tblTRIP_STAFF (TripID, StaffID)
VALUES (@T_ID, @S_ID)
IF @@ERROR <> 0
    ROLLBACK TRAN T1
ELSE
    COMMIT TRAN T1


--wrapper

SELECT *
INTO TEMP_TRIP1
FROM tblTRIP

DECLARE @TRIP_COUNT INT = (SELECT COUNT(*) FROM TEMP_TRIP)
DECLARE @STAFF_COUNT INT = (SELECT COUNT(*) FROM tblSTAFF)
DECLARE @Staff_ID INT, @SFName varchar(50), @SLName varchar(50), @SBirth DATE, @Trip_Name varchar(50), @Trip_ID INT

WHILE @TRIP_COUNT > 0
    BEGIN
    SET @Staff_ID = (RAND() * @STAFF_COUNT + 1)
    SET @SFName = (SELECT StaffFName FROM tblSTAFF WHERE StaffID = @Staff_ID)
    SET @SLName = (SELECT StaffLName FROM tblSTAFF WHERE StaffID = @Staff_ID)
    SET @SBirth = (SELECT StaffBirth FROM tblSTAFF WHERE StaffID = @Staff_ID)
    SET @Trip_ID = (SELECT MAX(TripID) FROM TEMP_TRIP1)
    SET @Trip_Name = (SELECT TripName FROM tblTRIP WHERE TripID = @Trip_ID)



    EXEC INSERT_TRIP_STAFF
    @StaffFName = @SFName,
    @StaffLName = @SLName,
    @StaffBirth = @SBirth,
    @TripName = @Trip_Name

    DELETE FROM TEMP_TRIP1 WHERE TripID = @Trip_ID
    SET @TRIP_COUNT = @TRIP_COUNT - 1
    END

DROP TABLE TEMP_TRIP1


SELECT COUNT(*) FROM tblTRIP_PURPOSE 
SELECT * FROM tblTRIP_PURPOSE 



------------------------------
--backups

BACKUP DATABASE INFO_430_Proj_06 TO DISK = 'C:\SQL\INFO_430_Proj_06.BAK'

BACKUP DATABASE INFO_430_Proj_06 TO DISK = 'C:\SQL\INFO_430_Proj_06.BAK' WITH DIFFERENTIAL

BACKUP DATABASE INFO_430_Proj_06 TO DISK = 'C:\SQL\INFO_430_Proj_06.BAK' WITH DIFFERENTIAL

