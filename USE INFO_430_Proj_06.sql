USE INFO_430_Proj_06
GO

--STORED PROCEDURES--
---------------------

-- #1) INSERT INTO tblTRIP

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

-- #2) INSERT INTO tblSPACECRAFT_SEAT

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

-- #3) INSERT INTO tblBOOKING

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

-- #4) INSERT INTO tblBOOKING_REQUIREMENT

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

-- #5) INSERT INTO tblTRIP_PURPOSE

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

-- #6) INSERT INTO tblTRIPSTAFF

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

-- base
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
GO

-- #7) INSERT INTO tblLUGGAGE

CREATE PROCEDURE GetLuggageTypeID
@LuggageTypeName varchar(50),
@LT_ID INT OUTPUT
AS
SET @LT_ID = (SELECT LuggageTypeID FROM tblLUGGAGE_TYPE WHERE LuggageTypeName = @LuggageTypeName)
GO

-- base
CREATE PROCEDURE INSERT_LUGGAGE
@Weight DECIMAL(5,2),
@TravelerFName varchar(50),
@TravelerLName varchar(50),
@TravelerBirth date,
@TripName varchar(50),
@SpacecraftName varchar(50),
@SeatNum INT,
@LuggageTypeName varchar(50)
AS
DECLARE @B_ID INT, @LT_ID INT

EXEC GetBookingID
    @TravelerFName = @TravelerFName,
    @TravelerLName = @TravelerLName,
    @TravelerBirth = @TravelerBirth,
    @TripName = @TripName,
    @SpacecraftName = @SpacecraftName,
    @SeatNum = @SeatNum,
    @BookingID = @B_ID OUTPUT

IF @B_ID IS NULL
    BEGIN
        PRINT 'Looks like BookingID might be null. Try again.'
        RAISERROR ('@B_ID is null.', 11, 1)
        RETURN
    END

EXEC GetLuggageTypeID
@LuggageTypeName = @LuggageTypeName,
@LT_ID = @LT_ID OUTPUT

IF @LT_ID IS NULL
    BEGIN
        PRINT 'Looks like LuggageTypeID might be null. Try again.'
        RAISERROR ('@LT_ID is null.', 11, 1)
        RETURN
    END

BEGIN TRAN T1
INSERT INTO tblLUGGAGE (Lugg_Weight, BookingID, LuggageTypeID)
VALUES (@Weight, @B_ID, @LT_ID)
IF @@ERROR <> 0
    BEGIN
        PRINT 'Issue... try again'
        ROLLBACK TRAN T1
    END
ELSE
    COMMIT TRAN T1
GO

-- #8) INSERT INTO tblSPACECRAFT
CREATE PROCEDURE GetModelID
@SCModelName varchar(50),
@M_ID INT OUTPUT
AS
SET @M_ID = (SELECT SCModelID FROM tblSPACECRAFT_MODEL WHERE SCModelName = @SCModelName)
GO

CREATE PROCEDURE GetStatusID
@SCStatusName varchar(50),
@S_ID INT OUTPUT
AS
SET @S_ID = (SELECT SCStatusID FROM tblSPACECRAFT_STATUS WHERE SCStatusName = @SCStatusName)
GO

-- base
CREATE PROCEDURE INSERT_SPACECRAFT
@SCSerial varchar(50),
@SCName varchar(50),
@SCDescr varchar(300),
@SCModelName varchar(50),
@SCStatusName varchar(50)
AS
DECLARE @M_ID INT, @S_ID INT

EXEC GetModelID
@SCModelName = @SCModelName,
@M_ID = @M_ID OUTPUT

IF @M_ID IS NULL
    BEGIN
        PRINT 'Looks like SCModelID might be null. Try again.'
        RAISERROR ('@M_ID is null.', 11, 1)
        RETURN
    END

EXEC GetStatusID
@SCStatusName = @SCStatusName,
@S_ID = @S_ID OUTPUT

IF @S_ID IS NULL
    BEGIN
        PRINT 'Looks like SCStatusID might be null. Try again.'
        RAISERROR ('@S_ID is null.', 11, 1)
        RETURN
    END

BEGIN TRAN T1
INSERT INTO tblSPACECRAFT (SCSerial, SCName, SCDescr, SCModelID, SCStatusID)
VALUES (@SCSerial, @SCName, @SCDescr, @M_ID, @S_ID)
IF @@ERROR <> 0
    BEGIN
        PRINT 'Problem... try again.'
        ROLLBACK TRAN T1
    END
ELSE
    COMMIT TRAN T1
GO

--BUSINESS RULES--
------------------

-- #1) No spaceport on the planet Mercury and Venus may be visited by a pilot or co-pilot under the age of 25
CREATE FUNCTION dbo.fn_NoPilotsVisitingInnerPlanets()
RETURNS INTEGER
AS
BEGIN
    DECLARE @RET INTEGER = 0
    IF EXISTS (SELECT SP.SpaceportID
    FROM tblSPACEPORT SP
        JOIN tblPLANET P ON P.PlanetID = SP.PlanetID
        JOIN tblROUTE R ON SP.SpaceportID = R.SpaceportStartingID
        JOIN tblTRIP T ON R.RouteID = T.RouteID
        JOIN tblTRIP_STAFF TS ON T.TripID = TS.TripID
        JOIN tblSTAFF S ON TS.StaffID = S.StaffID
        JOIN tblSTAFF_TYPE ST ON S.StaffTypeID = ST.StaffTypeID
        WHERE P.PlanetName = 'Mercury' OR P.PlanetName = 'Venus'
        AND ST.StaffTypeName = 'Pilot' OR ST.StaffTypeName = 'Co-pilot'
        AND S.StaffBirth > dateadd(year, -25, getdate()))
        BEGIN
        SET @RET = 1
        END
RETURN @RET
END
GO

ALTER TABLE tblSPACEPORT WITH NOCHECK
ADD CONSTRAINT CK_PilotAge
CHECK(dbo.fn_NoPilotsVisitingInnerPlanets() = 0)
GO

--#2) No individual from the species named “Navi” can purchase a first class ticket and travel on the spacecraft type name: Personal Cruiser

CREATE FUNCTION dbo.fn_NoTaxonsInFirstClass()
RETURNS INTEGER
AS
BEGIN
    DECLARE @RET INTEGER = 0
    IF EXISTS (SELECT S.SpeciesID
        FROM tblSPECIES S
        JOIN tblTRAVELER T ON S.SpeciesID = T.SpeciesID
        JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
        JOIN tblSPACECRAFT_SEAT SS ON B.SCSeatID = SS.SCSeatID
        JOIN tblCLASS C ON SS.ClassID = C.ClassID
        JOIN tblTRIP TR ON B.TripID = TR.TripID
        JOIN tblSPACECRAFT SC ON TR.SCID = SC.SCID
        JOIN tblSPACECRAFT_MODEL SM ON SC.SCModelID = SM.SCModelID
        WHERE S.SpeciesName = 'Navi'
        AND SM.SCModelName = 'Mercury'
        AND C.ClassName = 'First')
        BEGIN
        SET @RET = 1
        END
RETURN @RET
END
        GO
ALTER TABLE tblCLASS WITH NOCHECK
ADD CONSTRAINT CK_Species
CHECK( dbo.fn_NoTaxonsInFirstClass()= 0)
GO

-- #3) tblLUGGAGE does not accept luggage for trips scheduled in the future or total weight does not exceed tblCLASS(ClassLuggageLimit)?

CREATE FUNCTION dbo.fn_luggageReqs()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT L.LuggageID FROM tblLUGGAGE L
            JOIN tblBOOKING B ON L.BookingID = B.BookingID
            JOIN tblTRIP T ON B.TripID = T.TripID
			JOIN tblSPACECRAFT_SEAT SS ON B.SCSeatID = SS.SCSeatID
            JOIN tblCLASS C ON  SS.ClassID = C.ClassID
            WHERE T.DeparturingTime > GetDate() OR (B.CurrentLuggageWeightSum + L.Lugg_Weight) > C.ClassLuggageLimit)
            BEGIN
            SET @RET = 1
            END
RETURN @RET
END
GO

ALTER TABLE tblLUGGAGE with nocheck
ADD CONSTRAINT CK_LuggWeight
CHECK(dbo.fn_luggageReqs() = 0)
GO

-- #4) traveler has completed all the requirements?

CREATE FUNCTION dbo.fn_CompletedReqs()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER = 0
IF EXISTS (SELECT T.TravelerID FROM tblTRAVELER T 
            JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
            JOIN tblBOOKING_REQUIREMENT BR ON BR.BookingID = B.BookingID
            JOIN tblREQUIREMENT R ON BR.RequirementID = R.RequirementID
            JOIN tblREQUIREMENT_STATUS RS ON BR.RequirementStatusID = RS.RequirementStatusID
            WHERE RS.RequirementStatusName = 'Incomplete' OR RS.RequirementStatusName = 'Pending')
            BEGIN
            SET @RET = 1
            END
RETURN @RET
END
GO

ALTER TABLE tblTRAVELER with nocheck
ADD CONSTRAINT CK_TravelReqs
CHECK(dbo.fn_CompletedReqs() = 0)
GO

-- #5) a seat must be reserved for a trip before a booking is made 

CREATE FUNCTION IsBooked(@TripID int, @SeatNumber int)
RETURNS int
AS
BEGIN
    DECLARE @IsBooked bit = 0
    IF EXISTS (SELECT *
                FROM tblBOOKING B
                JOIN tblTRIP T ON B.TripID = T.TripID
                JOIN tblSPACECRAFT SC ON T.SCID = SC.SCID
                JOIN tblSPACECRAFT_SEAT SCS ON SC.SCID = SCS.SCSeatID
                WHERE T.TripID = @TripID AND SCS.SeatNumber = @SeatNumber)
                BEGIN
                SET @IsBooked = 1
                END

RETURN @IsBooked
END
GO

ALTER TABLE tblBOOKING
ADD CONSTRAINT CHK_Booked
CHECK(IsBooked(TripID, SeatNumber) = 0)
GO

-- #6) Trips that are scheduled after 2016 must have a spacecraft status of "Active" in order to have trips 

CREATE FUNCTION IsActive()
RETURNS int
AS
BEGIN
    DECLARE @IsActive bit = 0
    IF EXISTS (SELECT *
                FROM tblTRIP T
                JOIN tblSPACECRAFT SC ON T.SCID = SC.SCID
                JOIN tblSPACECRAFT_STATUS SCST ON SC.SCStatusID = SCST.SCStatusID
                WHERE (SCST.SCStatusName = 'Under construction' OR SCST.SCStatusName = 'Retired')
                AND YEAR(T.DeparturingTime) > 2016)
                BEGIN
                SET @IsActive = 1
                END

RETURN @IsActive
END
GO

ALTER TABLE tblTRIP
ADD CONSTRAINT CHK_SCActive
CHECK(dbo.IsActive() = 1)
GO

-- #7) No staff older than 50 from earth assuming the position of ‘Pilot’ may fly trips for the purpose of ‘exploration’ for customer types ‘diplomats’.

CREATE FUNCTION fn_PilotExploration50 ()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT *
            FROM tblSTAFF s
            JOIN tblTRIP_STAFF ts ON ts.StaffID = s.StaffID
            JOIN tblSTAFF_TYPE st ON st.StaffTypeID = s.StaffTypeID
            JOIN tblTRIP t ON t.TripID = ts.TripID
            JOIN tblTRIP_PURPOSE tp ON tp.TripID = t.TripID
            JOIN tblPURPOSE p ON p.PurposeID = tp.PurposeID
            JOIN tblBOOKING b ON b.TripID = t.TripID
            JOIN tblTRAVELER tr ON tr.TravelerID = b.TravelerID
            JOIN tblTRAVELER_TYPE tt ON tt.TravelerTypeID = tr.TravelerTypeID
            WHERE DATEDIFF(YEAR, s.StaffBirth, GETDATE()) > 50
            AND st.StaffTypeName = 'Pilot'
            AND p.PurposeName = 'Exploration'
            AND tt.TravelerTypeName = 'Diplomat')
            BEGIN
            SET @RET = 1
            END

RETURN @RET
END
GO

ALTER TABLE tblTRIP_STAFF
ADD CONSTRAINT CK_Pilot50
CHECK (dbo.fn_PilotExploration50() = 0)
GO


-- #8) Human customers above the age of 12 must be COVID-19 vaccinated in order to fly starting 2023

CREATE FUNCTION fn_Traveler12COVID ()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT *
            FROM tblTRAVELER t
            JOIN tblBOOKING b ON b.TravelerID = t.TravelerID
            JOIN tblBOOKING_REQUIREMENT br ON br.BookingID = b.BookingID
            JOIN tblREQUIREMENT r ON r.RequirementID = br.RequirementID
            JOIN tblREQUIREMENT_STATUS rs ON rs.RequirementStatusID = br.RequirementStatusID
            JOIN tblTRIP tr ON tr.TripID = b.TripID
            WHERE DATEDIFF(YEAR, t.TravelerBirth, GETDATE()) > 12
            AND r.RequirementName = 'COVID-19 Requirement'
            AND rs.RequirementStatusName = 'Complete'
            AND YEAR(tr.DeparturingTime) = 2023 )
            BEGIN
            SET @RET = 1
            END

RETURN @RET
END
GO

ALTER TABLE tblBOOKING
ADD CONSTRAINT CK_Traveler12
CHECK (dbo.fn_Traveler12COVID() =0)
GO

--COMPUTED COLUMNS--
--------------------
-- #1) count number of trips per travler above the age of 35
GO
CREATE OR ALTER FUNCTION fn_CountTravelTrips (@PK INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = (SELECT COUNT(BookingID)
                        FROM tblBOOKING B
                        JOIN tblTRAVELER T on B.TravelerID = T.TravelerID
                        WHERE DATEDIFF(YEAR, T.TravelerBirth, GETDATE()) > 35
                        AND T.TravelerID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblTRAVELER
ADD calcTotalTrips as (dbo.fn_CountTravelTrips(TravelerID))
GO

-- #2) Count the number of space flights arriving on each planet in the year 2019 for the purpose of exploration.
GO
CREATE FUNCTION fn_CountSpaceFlightsEarth (@PK INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = (SELECT COUNT(T.TripID)
                        FROM tblTRIP T
                        JOIN tblTRIP_PURPOSE TP ON  TP.TripID = T.TripID
                        JOIN tblPURPOSE PU ON PU.PurposeID = TP.PurposeID
                        JOIN tblROUTE R ON T.RouteID = R.RouteID
                        JOIN tblSPACEPORT SP ON R.SpaceportEndingID = SP.SpaceportID
                        JOIN tblPLANET P ON P.PlanetID = SP.PlanetID
                        WHERE YEAR(T.DeparturingTime) = '2019'
                        AND PU.PurposeName = 'Exploration'
                        AND T.TripID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblTRIP 
ADD calctotalTripsEarth as (dbo.fn_CountSpaceFlightsEarth(TripID))
GO

-- #3) Count the total number of trip purposes associated with each spaceport

CREATE FUNCTION fn_CountTripPurposes (@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT COUNT(TP.TripPurposeID)
                    FROM tblPURPOSE P
                    JOIN tblTRIP_PURPOSE TP ON P.PurposeID = TP.PurposeID
                    JOIN tblTRIP T ON T.TripID = TP.TripID
                    JOIN tblROUTE R ON R.RouteID = T.RouteID
                    JOIN tblSPACEPORT SP ON SP.SpaceportID = R.SpaceportEndingID
                    WHERE TP.PurposeID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblPURPOSE
ADD CountTripPurposes AS (dbo.fn_CountTripPurposes(SpaceportID))
GO

-- #4) Sum the total luggage weight for trips with Pilots over the age of 45 per each booking 

CREATE FUNCTION fn_BookingLuggageWeight (@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT SUM(Lugg_Weight)
                    FROM  tblLUGGAGE L 
                        JOIN tblBOOKING B ON L.BookingID = B.BookingID
                        JOIN tblTRIP T ON T.TripID = B.TripID
                        JOIN tblTRIP_STAFF TS ON TS.TripID = T.TripID
                        JOIN tblSTAFF S ON S.StaffID = TS.StaffID
                        JOIN tblSTAFF_TYPE ST ON ST.StaffTypeID = S.StaffTypeID
                        WHERE ST.StaffTypeName = 'Pilot'
                        AND DATEDIFF(YEAR, S.StaffBirth, GETDATE()) > 45
                        AND B.BookingID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblBOOKING 
ADD CurrentLuggageWeightSum AS (dbo.fn_BookingLuggageWeight(BookingID))
GO

-- #5) Count the total loaunches for each spacecrafts manufactured by 'SpaceX' 

CREATE FUNCTION GetTotalLaunches(@SCID int)
RETURNS int
AS
BEGIN
    DECLARE @TotalLaunches int = (SELECT COUNT(*)
                                    FROM tblTRIP T
                                    JOIN tblSPACECRAFT S ON S.SCID = T.SCID
                                    JOIN tblSPACECRAFT_MODEL SM ON SM.SCModelID = S.SCModelID
                                    JOIN tblMANUFACTURER M ON M.MFRID = SM.MFRID
                                    WHERE M.MFRName = 'SpaceX'
                                    AND S.SCID = @SCID)
RETURN @TotalLaunches
END
GO

ALTER TABLE tblSPACECRAFT
ADD SCTotalLaunches AS (dbo.GetTotalLaunches(SCID))
GO

-- #6) Sets the Spacecraft status to 'Retired' if total launches from a specific spaceraft exceeds 10000

CREATE FUNCTION IsRetired(@SCID int)
RETURNS int
AS
BEGIN
    DECLARE @IsRetired bit = 0
    IF (SELECT SCTotalLaunches FROM tblSPACECRAFT WHERE SCID = @SCID) > 10000
        BEGIN
        SET @IsRetired = 1
        END
RETURN @IsRetired
END
GO

UPDATE tblSPACECRAFT
SET SCStatusID = (SELECT SCStatusID FROM tblSPACECRAFT_STATUS WHERE SCStatusName = 'Retired')
WHERE dbo.IsRetired(SCID) = 1
GO

-- #7) What is the average luggage weight for a civilian traveling to Pluto for each spacecraft

CREATE FUNCTION fn_AverageLuggagePluto (@PK INT)
RETURNS INT
AS
BEGIN

    DECLARE @RET INT = (SELECT AVG(l.Lugg_Weight)
                        FROM tblLUGGAGE l 
                        JOIN tblBOOKING b ON b.BookingID = l.BookingID
                        JOIN tblTRAVELER t ON t.TravelerID = b.TravelerID
                        JOIN tblTRAVELER_TYPE tt ON tt.TravelerTypeID = t.TravelerTypeID
                        JOIN tblTRIP tr ON tr.TripID = b.TripID
                        JOIN tblSPACECRAFT spa ON spa.SCID = tr.SCID
                        JOIN tblROUTE r ON r.RouteID = tr.RouteID
                        JOIN tblSPACEPORT sp ON sp.SpaceportID = r.SpaceportEndingID
                        JOIN tblPLANET p ON p.PlanetID = sp.PlanetID
                        WHERE p.PlanetName = 'Pluto'
                        AND tt.TravelerTypeName = 'Civilian'
                        AND spa.SCID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblSPACECRAFT
ADD CALC_AverageLuggage AS (dbo.fn_AverageLuggagePluto (SCID))
GO

-- #8) Count the number of Customers traveling for the purpose of tourism from Mars for each class

CREATE FUNCTION fn_CustomerTourism (@PK INT)
RETURNS INT
AS
BEGIN

    DECLARE @RET INT = (SELECT COUNT(*)
                        FROM tblTRAVELER t 
                        JOIN tblBOOKING b ON b.TravelerID = t.TravelerID
                        JOIN tblTRIP tr ON tr.TripID = b.TripID
                        JOIN tblTRIP_PURPOSE tp ON tp.TripID = tr.TripID
                        JOIN tblPURPOSE p ON p.PurposeID = tp.PurposeID
                        JOIN tblROUTE r ON r.RouteID = tr.RouteID
                        JOIN tblSPACEPORT s ON s.SpaceportID = r.SpaceportStartingID
                        JOIN tblPLANET pl ON pl.PlanetID = s.PlanetID
                        JOIN tblSPACECRAFT sp ON sp.SCID = tr.SCID
                        JOIN tblSPACECRAFT_SEAT ss ON ss.SCID = sp.SCID
                        JOIN tblCLASS c ON c.ClassID = ss.ClassID
                        WHERE p.PurposeName = 'Tourism'
                        AND pl.PlanetName = 'Mars'
                        AND c.ClassID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblCLASS
ADD CALC_CustTourism AS (dbo.fn_CustomerTourism (ClassID))
GO

--COMPLEX QUERIES--
-------------------
-- #1) Select all the passengers that have traveled to Neptune on the spacecraft type “Dragon 2” during the past 4 years who have
--     also traveled due to the trip purpose of “science”
GO
 create view vmacTravelers
 AS
 select T.TravelerID, T.TravelerFName, T.TravelerLName, sum(TR.TripID) as TotalTripsTraveler
 from tblTRAVELER T
        join tblBOOKING B on T.TravelerID = B.BookingID
        join tblTRIP TR on B.TripID = TR.TripID
        join tblSPACECRAFT SC on TR.SCID = SC.SCID
        join tblSPACECRAFT_MODEL SM on SC.SCModelID = SM.SCModelID
        join tblTRIP_PURPOSE TP on TR.TripID = TP.TripID
        join tblPURPOSE PUR on TP.PurposeID = PUR.PurposeID
        join tblROUTE R on TR.RouteID = R.RouteID
        join tblSPACEPORT SP on R.SpaceportEndingID = SP.SpaceportID
        join tblPLANET P on SP.PlanetID = P.PlanetID
        where PUR.PurposeName = 'Science'
        group by T.TravelerID, T.TravelerFName, T.TravelerLName
    GO
    create view vmacTravelersContinued
    as
    select T.TravelerID, T.TravelerFName, T.TravelerLName
    from tblTRAVELER T
        join tblBOOKING B on T.TravelerID = B.BookingID
        join tblTRIP TR on B.TripID = TR.TripID
        join tblSPACECRAFT SC on TR.SCID = SC.SCID
        join tblSPACECRAFT_MODEL SM on SC.SCModelID = SM.SCModelID
        join tblTRIP_PURPOSE TP on TR.TripID = TP.TripID
        join tblPURPOSE PUR on TP.PurposeID = PUR.PurposeID
        join tblROUTE R on TR.RouteID = R.RouteID
        join tblSPACEPORT SP on R.SpaceportEndingID = SP.SpaceportID
        join tblPLANET P on SP.PlanetID = P.PlanetID
        and SM.SCModelName = 'Dragon 2'
        and P.PlanetName = 'Neptune'
        and TR.DeparturingTime > dateadd(year, -4, getdate())
    group by T.TravelerID, T.TravelerFName, T.TravelerLName
GO

CREATE VIEW TravelersNeptune AS
select A.TravelerID, A.TravelerFName, A.TravelerLName, A.TotalTripsTraveler from vmacTravelers A 
join vmacTravelersContinued B on A.TravelerID = B.TravelerID
GO

-- #2) Return travelers ranked by the total number of planets they visited.
CREATE VIEW PlanetsVisited AS
with CTE_Trips (FirstName, LastName, TotalPlanetsVisited, TotalTrips)
as
(select T.TravelerFName, T.TravelerLName, count(TR.TripID) as TotalTripsPerTraveler,
rank() over (order by P.PlanetName) as TotalTrips
from tblTRAVELER T
    join tblBOOKING B on T.TravelerID = B.BookingID
        join tblTRIP TR on B.TripID = TR.TripID
        join tblSPACECRAFT SC on TR.SCID = SC.SCID
        join tblSPACECRAFT_MODEL SM on SC.SCModelID = SM.SCModelID
        join tblTRIP_PURPOSE TP on TR.TripID = TP.TripID
        join tblPURPOSE PUR on TP.PurposeID = PUR.PurposeID
        join tblROUTE R on TR.RouteID = R.RouteID
        join tblSPACEPORT SP on R.SpaceportEndingID = SP.SpaceportID
        join tblPLANET P on SP.PlanetID = P.PlanetID
        group by T.TravelerFName, T.TravelerLName,TR.TripID, P.PlanetName)
    select * 
    from CTE_Trips
GO

-- #3) Select all Human travelers going to Saturn’s South Saturn Space Port on Ships with Type CST-100 Starliner with status ‘Under Construction' in the last 11 months

CREATE VIEW HumansToSaturn AS
SELECT S.SpeciesName, T.TravelerFname, T.TravelerLname, T.TravelerID, SP.SpacePortName, craft.SCName, craft.SCStatusName
	FROM tblTRAVELER T
	JOIN tblTRAVELER_TYPE TT ON T.TravelerTypeID = TT.TravelerTypeID
	JOIN tblSPECIES S ON T.SpeciesID = S.SpeciesID
	JOIN tblBOOKING B ON T.TravelerID = B.TravelerID
	JOIN tblTRIP TR ON B.TripID = TR.TripID
	JOIN tblROUTE R ON TR.RouteID = R.RouteID
	JOIN tblSPACEPORT SP ON R.SpaceportEndingID = SP.SpaceportID
	JOIN tblPLANET P ON SP.PlanetID = P.PlanetID
	JOIN (SELECT TR.TripID, SC.SCName, ST.SCStatusName FROM tblTRIP TR
			JOIN tblSPACECRAFT SC on TR.SCID = SC.SCID
			JOIN tblSPACECRAFT_STATUS ST ON SC.SCStatusID = ST.SCStatusID
			JOIN tblSPACECRAFT_MODEL SM ON SC.SCModelID = SM.SCModelID
			WHERE SM.SCModelName = 'CST-100 Starliner'
				AND ST.SCStatusName = 'Under construction') AS craft ON TR.TripID = craft.TripID
	WHERE getDate() > DATEADD(MONTH,-11, TR.DeparturingTime)
	AND S.SpeciesName = 'Human'
	AND P.PlanetName = 'Saturn'
	AND SP.SpaceportName = 'South Saturn SP'
GO

-- #4) Rank the crew members by amount of time in space accumulated over all trips

CREATE VIEW StaffInSpace AS
SELECT S.StaffID, S.StaffFName, S.StaffLName, RANK()OVER( ORDER BY SUM(boom.yo) DESC) as DaysRanking, sum(boom.yo) as DaysInSpace FROM tblSTAFF S
	JOIN tblSTAFF_TYPE ST ON S.StaffTypeID = ST.StaffTypeID
	JOIN tblTRIP_STAFF TS ON S.StaffID = TS.StaffID
	JOIN tblTRIP T ON TS.TripID = T.TripID
	JOIN tblTRIP_PURPOSE TP ON T.TripID = TP.TripID
		JOIN (SELECT DATEDIFF(day, T.DeparturingTime, T.ArrivalTime) AS yo, TripID FROM tblTRIP T) as boom ON T.TripID = boom.TripID
	GROUP BY S.StaffID, S.StaffFName, S.StaffLName
GO

-- #5) Return Travel Class Rank by Route

DECLARE @BookingClassTable TABLE (
    BookingClassID int IDENTITY(1,1) PRIMARY KEY,
    ClassName varchar(50) NOT NULL,
    DepartingSP varchar(55) NOT NULL,
    ArrivingSP varchar(55) NOT NULL,
    TotalBooking int NOT NULL,
    RouteClassRank int NOT NULL
)

INSERT INTO @BookingClassTable(ClassName, DepartingSP, ArrivingSP, TotalBooking, RouteClassRank)
SELECT C.ClassName, SP.SpaceportName AS Departure, SP2.SpaceportName AS Arrival, COUNT(*) AS TotalBooking, RANK() OVER (PARTITION BY SP.SpaceportName, SP2.SpaceportName ORDER BY COUNT(*) DESC) AS BookingClassRank
FROM tblBOOKING B
    JOIN tblSPACECRAFT_SEAT SC ON B.SCSeatID = SC.SCSeatID
    JOIN tblCLASS C ON SC.ClassID = C.ClassID
    JOIN tblTRIP T ON B.TripID = T.TripID
    JOIN tblROUTE R ON T.RouteID = R.RouteID
    JOIN tblSPACEPORT SP ON R.SpaceportStartingID = SP.SpaceportID
    JOIN tblSPACEPORT SP2 ON R.SpaceportEndingID = SP2.SpaceportID
GROUP BY C.ClassName, SP.SpaceportName, SP2.SpaceportName
ORDER BY Departure, Arrival

SELECT *
FROM @BookingClassTable
GO

-- #6) Return Booking Requirement Status by Color

DECLARE @ReqCountTable TABLE (
    ReqCountID int IDENTITY(1,1) PRIMARY KEY,
    BookingID int NOT NULL,
    TotalCompleted int NOT NULL
)

INSERT INTO @ReqCountTable(BookingID, TotalCompleted)
SELECT BookingID, COUNT(*) AS TotalCompletedReq
FROM tblBOOKING_REQUIREMENT BR
    JOIN tblREQUIREMENT_STATUS RS ON BR.RequirementStatusID = RS.RequirementStatusID
WHERE RS.RequirementStatusName = 'Complete'
GROUP BY BookingID

INSERT INTO @ReqCountTable(BookingID, TotalCompleted)
SELECT BookingID, 0
FROM tblBOOKING
WHERE BookingID NOT IN (
    SELECT BookingID
    FROM tblBOOKING_REQUIREMENT BR
        JOIN tblREQUIREMENT_STATUS RS ON BR.RequirementStatusID = RS.RequirementStatusID
    WHERE RequirementStatusName = 'Complete'
)

SELECT BookingID, (
    CASE TotalCompleted
        WHEN 0 THEN 'Red'
        WHEN 1 THEN 'Orange'
        WHEN 2 THEN 'Yellow'
        WHEN 3 THEN 'Green'
    END
) AS RequirementStatus
FROM @ReqCountTable
GO

-- #7) Select all non human travelers below the age of 30 who are traveling on spacecraft model 'Mercury' in the year 2020
--     who have also previously travelled to Venus on First class

CREATE VIEW Aliens AS
SELECT t.TravelerID, t.TravelerFname, t.TravelerLname
FROM tblTRAVELER t 
JOIN tblSPECIES sp ON sp.SpeciesID = t.SpeciesID
JOIN tblBOOKING b ON t.TravelerID = b.TravelerID
JOIN tblTRIP tr ON tr.TripID = b.TripID
JOIN tblSPACECRAFT s ON s.SCID = tr.SCID
JOIN tblSPACECRAFT_MODEL sm ON sm.SCModelID = s.SCModelID
JOIN (SELECT DISTINCT t.TravelerID, t.TravelerFname, t.TravelerLname
        FROM tblTRAVELER t 
        JOIN tblBOOKING b ON t.TravelerID = b.TravelerID
        JOIN tblTRIP tr ON tr.TripID = b.TripID
        JOIN tblSPACECRAFT s ON s.SCID = tr.SCID
        JOIN tblSPACECRAFT_SEAT ss ON ss.SCID = s.SCID
        JOIN tblCLASS c ON c.ClassID = ss.ClassID
        JOIN tblROUTE r ON r.RouteID = tr.RouteID
        JOIN tblSPACEPORT sp ON sp.SpaceportID = r.SpaceportEndingID
        JOIN tblPLANET p ON p.PlanetID = sp.PlanetID
        WHERE p.PlanetName = 'Venus'
        AND c.ClassName = 'First') as a ON a.TravelerID = t.TravelerID
WHERE DATEDIFF(YEAR, t.TravelerBirth, GETDATE()) < 30
AND sm.SCModelName = 'Mercury'
AND YEAR(tr.DeparturingTime) = '2020'
AND sp.SpeciesName != 'Human'
GO

-- #8) Select all travellers who completed at least two requirements met to travel and have traveled to more than three destinations in the last year.

CREATE VIEW REQUIREMENTS AS
SELECT t.TravelerFName, t.TravelerLName, COUNT(r.RequirementID) as Requirements
FROM tblTRAVELER t
JOIN tblBOOKING b ON b.TravelerID = t.TravelerID
JOIN tblBOOKING_REQUIREMENT br ON br.BookingID = b.BookingID
JOIN tblREQUIREMENT r ON r.RequirementID = br.RequirementID
JOIN tblREQUIREMENT_STATUS rs ON rs.RequirementStatusID = br.RequirementStatusID
JOIN (SELECT t.TravelerFName, t.TravelerLName, t.TravelerID
        FROM tblTRAVELER t
        JOIN tblBOOKING b ON b.TravelerID = t.TravelerID
        JOIN tblTRIP tr ON tr.TripID = b.TripID
        JOIN tblROUTE r ON r.RouteID = tr.RouteID
        JOIN tblSPACEPORT s ON s.SpaceportID = r.SpaceportEndingID
        WHERE DATEDIFF(MONTH, tr.DeparturingTime, GETDATE()) <= 18
        GROUP BY t.TravelerFName, t.TravelerLName, t.TravelerID
        HAVING COUNT(r.SpaceportEndingID) > 2) as a ON a.TravelerID = t.TravelerID
WHERE rs.RequirementStatusName = 'Complete'
GROUP BY t.TravelerFName, t.TravelerLName
HAVING COUNT(r.RequirementID) >= 2
GO

--TABLEAU QUERIES--
-------------------

-- #1) Return monthly trips for each traveler type in the last year


CREATE VIEW AverageMonthlyTrips AS
SELECT tt.TravelerTypeName, COUNT(tr.TripID) as Trips, RANK() OVER (PARTITION BY MONTH(tr.DeparturingTime) ORDER BY COUNT(tr.TripID)  ASC) as TripsPerMonth, MONTH(tr.DeparturingTime) as Month
FROM tblTRAVELER t
JOIN tblTRAVELER_TYPE tt ON tt.TravelerTypeID = t.TravelerTypeID
JOIN tblBOOKING b ON b.TravelerID = t.TravelerID
JOIN tblTRIP tr ON tr.TripID = b.TripID
WHERE YEAR(tr.DeparturingTime) = '2020' 
GROUP BY tt.TravelerTypeName, MONTH(tr.DeparturingTime)
GO


-- #2) Return which planets have the most requirements assosiated with for travel

CREATE VIEW PlanetRequirements AS
SELECT p.PlanetName, COUNT(re.RequirementID) as TotNumRequirements, RANK() OVER (PARTITION BY re.RequirementName ORDER BY COUNT(re.RequirementID)  ASC) as reqs, re.RequirementName
FROM tblPLANET p 
JOIN tblSPACEPORT s ON s.PlanetID = p.PlanetID
JOIN tblROUTE r ON r.SpaceportEndingID = s.SpaceportID
JOIN tblTRIP t ON t.RouteID = r.RouteID
JOIN tblBOOKING b ON b.TripID = t.TripID
JOIN tblBOOKING_REQUIREMENT br ON br.BookingID = b.BookingID
JOIN tblREQUIREMENT re ON re.RequirementID = br.RequirementID
JOIN tblREQUIREMENT_STATUS rs ON rs.RequirementStatusID = br.RequirementStatusID
WHERE rs.RequirementStatusName = 'Complete'
GROUP BY p.PlanetName, re.RequirementName
GO


-- #3) Return planets, their associated total cpmpleted requirements, and their associated total incomplete requirements

CREATE VIEW CompletedAndInc AS
WITH CTE_NotCompleted (PlanetName, NumIncomplete)
AS (SELECT p.PlanetName, COUNT(re.RequirementID) as TotNumIncompleteRequirements
FROM tblPLANET p 
JOIN tblSPACEPORT s ON s.PlanetID = p.PlanetID
JOIN tblROUTE r ON r.SpaceportEndingID = s.SpaceportID
JOIN tblTRIP t ON t.RouteID = r.RouteID
JOIN tblBOOKING b ON b.TripID = t.TripID
JOIN tblBOOKING_REQUIREMENT br ON br.BookingID = b.BookingID
JOIN tblREQUIREMENT re ON re.RequirementID = br.RequirementID
JOIN tblREQUIREMENT_STATUS rs ON rs.RequirementStatusID = br.RequirementStatusID
WHERE rs.RequirementStatusName = 'Incomplete'
GROUP BY p.PlanetName)

SELECT p.PlanetName, COUNT(re.RequirementID) as TotCompletedNumRequirements, a.NumIncomplete
FROM tblPLANET p 
JOIN tblSPACEPORT s ON s.PlanetID = p.PlanetID
JOIN tblROUTE r ON r.SpaceportEndingID = s.SpaceportID
JOIN tblTRIP t ON t.RouteID = r.RouteID
JOIN tblBOOKING b ON b.TripID = t.TripID
JOIN tblBOOKING_REQUIREMENT br ON br.BookingID = b.BookingID
JOIN tblREQUIREMENT re ON re.RequirementID = br.RequirementID
JOIN tblREQUIREMENT_STATUS rs ON rs.RequirementStatusID = br.RequirementStatusID
JOIN (SELECT * FROM CTE_NotCompleted) as a ON a.PlanetName = p.PlanetName
WHERE rs.RequirementStatusName = 'Complete'
GROUP BY p.PlanetName, a.NumIncomplete
GO

-- #4) Return percentage species traveled to earth

CREATE VIEW SpeciesBreakdown AS
WITH CTE_TotSpecies  (SpeciesID)
AS (SELECT COUNT(s.SpeciesID) as species FROM tblSPECIES s
JOIN tblTRAVELER t ON t.SpeciesID = s.SpeciesID
JOIN tblBOOKING b ON b.TravelerID = T.TravelerID
JOIN tblTRIP tr ON tr.TripID = b.TripID
JOIN tblROUTE r ON r.RouteID = tr.RouteID
JOIN tblSPACEPORT sp ON sp.SpaceportID = r.SpaceportEndingID
JOIN tblPLANET p ON p.PlanetID = sp.PlanetID
WHERE p.PlanetName = 'Earth')

SELECT s.SpeciesName, CAST(COUNT(s.SpeciesID) AS DECIMAL(7,2)) / (SELECT * FROM CTE_TotSpecies) * 100 as perc
FROM tblSPECIES s
JOIN tblTRAVELER t ON t.SpeciesID = s.SpeciesID
JOIN tblBOOKING b ON b.TravelerID = T.TravelerID
JOIN tblTRIP tr ON tr.TripID = b.TripID
JOIN tblROUTE r ON r.RouteID = tr.RouteID
JOIN tblSPACEPORT sp ON sp.SpaceportID = r.SpaceportEndingID
JOIN tblPLANET p ON p.PlanetID = sp.PlanetID
WHERE p.PlanetName = 'Earth'
GROUP BY s.SpeciesName

 
    

