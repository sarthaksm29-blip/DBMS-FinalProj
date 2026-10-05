-- WarrantyBox
-- Product Warranty & Service Claim Tracker
-- PostgreSQL

DROP TABLE IF EXISTS Claim CASCADE;
DROP TABLE IF EXISTS Warranty CASCADE;
DROP TABLE IF EXISTS ServiceCenter CASCADE;
DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS Product CASCADE;
DROP FUNCTION IF EXISTS check_warranty_expiry() CASCADE;

CREATE TABLE Product (
    ProductID INTEGER PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Brand VARCHAR(50),
    Price NUMERIC(10,2)
);

CREATE TABLE Customer (
    CustomerID INTEGER PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

CREATE TABLE ServiceCenter (
    ServiceCenterID INTEGER PRIMARY KEY,
    CenterName VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    ContactNo VARCHAR(15)
);

CREATE TABLE Warranty (
    WarrantyID INTEGER PRIMARY KEY,
    PurchaseID INTEGER UNIQUE NOT NULL,
    ProductID INTEGER NOT NULL,
    CustomerID INTEGER NOT NULL,
    PurchaseDate DATE NOT NULL,
    WarrantyPeriod INTEGER NOT NULL,
    ExpiryDate DATE NOT NULL,
    CONSTRAINT fk_warranty_product
        FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    CONSTRAINT fk_warranty_customer
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Claim (
    ClaimID INTEGER PRIMARY KEY,
    ProductID INTEGER NOT NULL,
    CustomerID INTEGER NOT NULL,
    WarrantyID INTEGER NOT NULL,
    ServiceCenterID INTEGER NOT NULL,
    ClaimDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL,
    Description VARCHAR(255),
    CONSTRAINT fk_claim_product
        FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    CONSTRAINT fk_claim_customer
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT fk_claim_warranty
        FOREIGN KEY (WarrantyID) REFERENCES Warranty(WarrantyID),
    CONSTRAINT fk_claim_service_center
        FOREIGN KEY (ServiceCenterID) REFERENCES ServiceCenter(ServiceCenterID)
);

-- Trigger function:
-- Reject a claim when the associated warranty has expired
-- on the claim date.
CREATE OR REPLACE FUNCTION check_warranty_expiry()
RETURNS TRIGGER
AS $$
DECLARE
    warranty_expiry DATE;
BEGIN
    SELECT ExpiryDate
    INTO warranty_expiry
    FROM Warranty
    WHERE WarrantyID = NEW.WarrantyID;

    IF warranty_expiry IS NULL THEN
        RAISE EXCEPTION 'Warranty ID % does not exist', NEW.WarrantyID;
    END IF;

    IF warranty_expiry < NEW.ClaimDate THEN
        RAISE EXCEPTION 'Claim rejected: Warranty has expired';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_warranty_before_claim
BEFORE INSERT ON Claim
FOR EACH ROW
EXECUTE FUNCTION check_warranty_expiry();
