USE [master]
GO

CREATE DATABASE [BoroMainDB]
GO

USE [BoroMainDB]
GO

CREATE TABLE Users (
    UserId UNIQUEIDENTIFIER PRIMARY KEY,
    FacebookId NVARCHAR(50) NOT NULL,
    Email NVARCHAR(256) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    About NVARCHAR(MAX) NOT NULL,
    DateJoined DATETIME NOT NULL,
    Latitude FLOAT NOT NULL,
    Longitude FLOAT NOT NULL,
    ImageId UNIQUEIDENTIFIER NULL
);

GO

CREATE TABLE UserImages (
    ImageId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    ImageMetaData NVARCHAR(MAX) NOT NULL DEFAULT '',
    ImageData VARBINARY(MAX) NOT NULL DEFAULT 0x
);

ALTER TABLE UserImages ADD CONSTRAINT PK_UserImages PRIMARY KEY CLUSTERED (ImageId);

GO

CREATE TABLE Items (
    ItemId UNIQUEIDENTIFIER NOT NULL,
    Title NVARCHAR(255) NOT NULL DEFAULT '',
    Description NVARCHAR(MAX),
    OwnerId UNIQUEIDENTIFIER NOT NULL,
    Condition NVARCHAR(50) NOT NULL DEFAULT '',
    Categories NVARCHAR(255) NOT NULL DEFAULT '',
    Latitude FLOAT NOT NULL DEFAULT 0,
    Longitude FLOAT NOT NULL DEFAULT 0
    
);
ALTER TABLE Items ADD CONSTRAINT PK_Items PRIMARY KEY CLUSTERED (ItemId);

GO

CREATE TABLE ItemImages (
    ImageId UNIQUEIDENTIFIER NOT NULL,
    ItemId UNIQUEIDENTIFIER NOT NULL,
    ImageMetaData NVARCHAR(MAX) NOT NULL DEFAULT '',
    ImageData VARBINARY(MAX) NOT NULL DEFAULT 0x
);
ALTER TABLE ItemImages ADD CONSTRAINT PK_ItemImages PRIMARY KEY CLUSTERED (ImageId);

GO

CREATE TABLE Reservations (
    ReservationId UNIQUEIDENTIFIER NOT NULL,
    ItemId UNIQUEIDENTIFIER NOT NULL,
    BorrowerId UNIQUEIDENTIFIER NOT NULL,
    LenderId UNIQUEIDENTIFIER NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    Status INT NOT NULL
);
ALTER TABLE Reservations ADD CONSTRAINT PK_Reservations PRIMARY KEY CLUSTERED (ReservationId);

GO

CREATE TABLE BlockedDates (
    ItemId UNIQUEIDENTIFIER NOT NULL,
    Date DATETIME NOT NULL
);
ALTER TABLE BlockedDates ADD CONSTRAINT PK_BlockedDates PRIMARY KEY CLUSTERED (ItemId, Date);

GO

CREATE FUNCTION dbo.IsLocationInRadius(@longitude1 FLOAT,
    @latitude1 FLOAT,
    @longitude2 FLOAT,
    @latitude2 FLOAT,
    @radius FLOAT)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT;
    DECLARE @distance FLOAT;
    DECLARE @earthRadius FLOAT;
    SET @earthRadius = 6371000;

    DECLARE @dLat FLOAT, @dLon FLOAT, @a FLOAT, @c FLOAT;

    SET @dLat = (@latitude1 - @latitude2) * PI() / 180;
    SET @dLon = (@longitude1 - @longitude2) * PI() / 180;

    SET @a = SIN(@dLat / 2) * SIN(@dLat / 2) +
              COS((@latitude1) * PI() / 180) * COS((@latitude2) * PI() / 180) *
              SIN(@dLon / 2) * SIN(@dLon / 2);

    SET @c = 2 * ATN2(SQRT(@a), SQRT(1 - @a));

    SET @distance = @earthRadius * @c;
    IF (@distance <= @radius)
        SET @result = 1;
    ELSE
        SET @result = 0;
    
    RETURN @result;
END

GO

ALTER TABLE Users ADD CONSTRAINT FK_Users_UserImages FOREIGN KEY (ImageId) REFERENCES UserImages(ImageId);
ALTER TABLE UserImages ADD CONSTRAINT FK_UserImages_Users FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE ItemImages ADD CONSTRAINT FK_ItemImages_Items FOREIGN KEY (ItemId) REFERENCES Items(ItemId);
ALTER TABLE Reservations ADD CONSTRAINT FK_Reservations_Items FOREIGN KEY (ItemId) REFERENCES Items(ItemId);
ALTER TABLE Reservations ADD CONSTRAINT FK_Reservations_Borrowers FOREIGN KEY (BorrowerId) REFERENCES Users(UserId);
ALTER TABLE Reservations ADD CONSTRAINT FK_Reservations_Lenders FOREIGN KEY (LenderId) REFERENCES Users(UserId);
ALTER TABLE BlockedDates ADD CONSTRAINT FK_BlockedDates_Items FOREIGN KEY (ItemId) REFERENCES Items(ItemId);