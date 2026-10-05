-- WarrantyBox seed data
-- Run schema.sql before running this file.

INSERT INTO Product (ProductID, ProductName, Category, Brand, Price) VALUES
(101, 'Galaxy S25', 'Smartphone', 'Samsung', 74999.00),
(102, 'Bravia 55-inch TV', 'Television', 'Sony', 89999.00),
(103, 'Inspiron 15', 'Laptop', 'Dell', 65999.00),
(104, 'iPhone 16', 'Smartphone', 'Apple', 79999.00);

INSERT INTO Customer (CustomerID, CustomerName, Email, Phone, Address) VALUES
(201, 'Priya Mehta', 'priya@example.com', '9876543210', 'Mumbai'),
(202, 'Sneha Joshi', 'sneha@example.com', '9876543211', 'Pune'),
(203, 'Arjun Shah', 'arjun@example.com', '9876543212', 'Navi Mumbai'),
(204, 'Rahul Sharma', 'rahul@example.com', '9876543213', 'Thane'),
(205, 'Amit Patil', 'amit@example.com', '9876543214', 'Mumbai');

INSERT INTO ServiceCenter (ServiceCenterID, CenterName, Location, ContactNo) VALUES
(301, 'Sony Service Center', 'Mumbai', '02240000001'),
(302, 'Samsung Service Center', 'Mumbai', '02240000002'),
(303, 'Dell Service Center', 'Pune', '02040000003'),
(304, 'Apple Service Center', 'Mumbai', '02240000004');

-- Warranty 406 expires on 2026-10-05, so it appears in the
-- "expiring within 30 days" query when run on 2026-10-05.
INSERT INTO Warranty
(WarrantyID, PurchaseID, ProductID, CustomerID, PurchaseDate, WarrantyPeriod, ExpiryDate)
VALUES
(401, 1001, 101, 201, '2025-10-05', 365, '2026-10-05'),
(402, 1002, 102, 202, '2026-02-15', 730, '2028-02-15'),
(403, 1003, 103, 203, '2025-06-10', 730, '2027-06-10'),
(404, 1004, 104, 204, '2026-01-20', 365, '2027-01-20'),
(405, 1005, 101, 205, '2026-03-01', 365, '2027-03-01'),
(406, 1006, 101, 201, '2025-10-05', 365, '2026-10-05');

-- Valid claims. These pass the trigger.
INSERT INTO Claim
(ClaimID, ProductID, CustomerID, WarrantyID, ServiceCenterID, ClaimDate, Status, Description)
VALUES
(501, 102, 202, 402, 302, '2026-09-28', 'Pending', 'Display issue'),
(502, 102, 202, 402, 302, '2026-09-28', 'Pending', 'Battery issue'),
(503, 102, 202, 402, 302, '2026-09-29', 'Pending', 'Screen display issue');
