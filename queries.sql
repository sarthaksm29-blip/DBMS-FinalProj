-- WarrantyBox queries
-- Run these after schema.sql and seed.sql.

-- 1. Display all claims ordered by ClaimID
SELECT *
FROM Claim
ORDER BY ClaimID;


-- 2. Find warranties expiring within the next 30 days
SELECT
    WarrantyID,
    ProductID,
    CustomerID,
    PurchaseDate,
    ExpiryDate
FROM Warranty
WHERE ExpiryDate BETWEEN CURRENT_DATE
AND CURRENT_DATE + INTERVAL '30 days';


-- 3. Count claims for each service center
SELECT
    s.CenterName,
    COUNT(c.ClaimID) AS TotalClaims
FROM ServiceCenter s
LEFT JOIN Claim c
    ON s.ServiceCenterID = c.ServiceCenterID
GROUP BY s.ServiceCenterID, s.CenterName
ORDER BY TotalClaims DESC;


-- 4. Find customers who have a warranty
-- using a subquery
SELECT CustomerName
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Warranty
);


-- 5. Check a particular claim
SELECT *
FROM Claim
WHERE ClaimID = 503;


-- 6. Count total claims
SELECT COUNT(*) AS TotalClaims
FROM Claim;


-- 7. Check whether rejected ClaimID 600 exists
-- It should return 0 rows if the trigger rejected it.
SELECT *
FROM Claim
WHERE ClaimID = 600;


-- 8. Test the trigger with an expired warranty.
-- Warranty 401 expires on 2026-10-05.
-- Use a later ClaimDate so the trigger rejects the INSERT.

-- INSERT INTO Claim
-- (ClaimID, ProductID, CustomerID, WarrantyID, ServiceCenterID,
--  ClaimDate, Status, Description)
-- VALUES
-- (600, 101, 201, 401, 302, '2026-10-06',
--  'Pending', 'Headphone not working');

-- Expected result:
-- ERROR: Claim rejected: Warranty has expired


-- 9. Verify that ClaimID 600 was not inserted
SELECT *
FROM Claim
WHERE ClaimID = 600;
