--==============================================================================================================================================

/* Time Between Purchases per Vendor */

WITH PurchaseVendors AS (
    SELECT
        poh.VendorID,
        v.Name AS VendorName,
        poh.PurchaseOrderID,
        poh.OrderDate
    FROM Purchasing.PurchaseOrderHeader poh
    LEFT JOIN Purchasing.Vendor v    -- Join Vendor to retrieve vendor names for each purchase order
        ON poh.VendorID = v.BusinessEntityID
),
PurchaseLead AS (
    SELECT
        VendorID,
        VendorName,
        PurchaseOrderID,
        OrderDate,
        LEAD(OrderDate) OVER (  -- LEAD() returns the next purchase date for the same vendor
            PARTITION BY VendorID 
            ORDER BY OrderDate ASC
        ) AS NextOrderDate
    FROM PurchaseVendors
),
PurchaseDays AS (
    SELECT
        VendorName,
        OrderDate,
        NextOrderDate,
        DATEDIFF(DAY, OrderDate, NextOrderDate) AS DaysBetweenPurchases  -- Calculate the number of days between consecutive purchases
    FROM PurchaseLead
    WHERE NextOrderDate IS NOT NULL -- Exclude the last purchase per vendor (no next order to compare)
)
SELECT
	VendorName,
	AVG(DaysBetweenPurchases) as AvgDaysBetweenPurchases    -- Average time gap between purchases for each vendor
FROM PurchaseDays
GROUP BY VendorName
ORDER BY AvgDaysBetweenPurchases ASC;   -- Vendors with the most frequent purchasing patterns appear first

--==============================================================================================================================================
