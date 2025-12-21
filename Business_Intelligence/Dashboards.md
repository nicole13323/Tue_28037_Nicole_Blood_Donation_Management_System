-- 1. EXECUTIVE SUMMARY DASHBOARD QUERIES
-- ============================================

-- KPI 1: Total Available Blood Inventory
SELECT 
    'Total Available Blood' AS KPI,
    SUM(quantity) AS value_ml,
    COUNT(*) AS units,
    ROUND(SUM(quantity) / 1000, 1) AS value_liters
FROM BLOOD_INVENTORY
WHERE status = 'Available'
AND expiryDate > SYSDATE;

-- KPI 2: Blood Requests Fulfillment Rate
SELECT 
    'Fulfillment Rate' AS KPI,
    ROUND(
        SUM(CASE WHEN status = 'Fulfilled' THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(COUNT(*), 0), 2
         ) AS value_percent,
    COUNT(*) AS total_requests,
    SUM(CASE WHEN status = 'Fulfilled' THEN 1 ELSE 0 END) AS fulfilled_requests
FROM BLOOD_REQUEST
WHERE requestDate >= TRUNC(SYSDATE, 'MM');

-- KPI 3: Active Donors This Month
SELECT 
    'Active Donors' AS KPI,
    COUNT(DISTINCT donorID) AS value_count
FROM DONATION
WHERE donationDate >= TRUNC(SYSDATE, 'MM')
AND status = 'Approved';

-- KPI 4: Expiring Inventory (Next 7 Days)
SELECT 
    'Expiring Soon' AS KPI,
    SUM(quantity) AS value_ml,
    COUNT(*) AS units
FROM BLOOD_INVENTORY
WHERE status = 'Available'
AND expiryDate BETWEEN SYSDATE AND SYSDATE + 7;



-- 2. INVENTORY ANALYSIS DASHBOARD
-- ============================================

-- Query 1: Blood Inventory by Type and Status
SELECT 
    bloodType,
    status,
    COUNT(*) AS unit_count,
    SUM(quantity) AS total_ml,
    ROUND(AVG(quantity), 2) AS avg_ml_per_unit,
    MIN(expiryDate) AS earliest_expiry,
    MAX(expiryDate) AS latest_expiry
FROM BLOOD_INVENTORY
GROUP BY bloodType, status
ORDER BY bloodType, status;

-- Query 2: Inventory Age Analysis
SELECT 
    bloodType,
    CASE 
        WHEN age_days <= 7 THEN '0-7 days'
         WHEN age_days <= 14 THEN '8-14 days'
        WHEN age_days <= 21 THEN '15-21 days'
        WHEN age_days <= 28 THEN '22-28 days'
        ELSE '29+ days'
    END AS age_category,
    COUNT(*) AS units,
    SUM(quantity) AS total_ml,
    ROUND(AVG(age_days), 1) AS avg_age_days
FROM (
    SELECT 
        bi.inventoryID,
        bi.bloodType,
        bi.quantity,
        ROUND(SYSDATE - d.donationDate) AS age_days
    FROM BLOOD_INVENTORY bi
    JOIN DONATION d ON bi.donationID = d.donationID
    WHERE bi.status = 'Available'
    AND bi.expiryDate > SYSDATE
)
GROUP BY bloodType, 
CASE 
        WHEN age_days <= 7 THEN '0-7 days'
        WHEN age_days <= 14 THEN '8-14 days'
        WHEN age_days <= 21 THEN '15-21 days'
        WHEN age_days <= 28 THEN '22-28 days'
        ELSE '29+ days'
    END
ORDER BY bloodType, MIN(age_days);

-- Query 3: Expiry Forecast
SELECT 
    TO_CHAR(expiryDate, 'YYYY-MM-DD') AS expiry_day,
    bloodType,
    COUNT(*) AS units_expiring,
    SUM(quantity) AS ml_expiring,
    SUM(SUM(quantity)) OVER (
        ORDER BY expiryDate 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_ml
FROM BLOOD_INVENTORY
WHERE status = 'Available'
AND expiryDate BETWEEN SYSDATE AND SYSDATE + 30
GROUP BY expiryDate, bloodType
ORDER BY expiryDate, bloodType;



-- ============================================
-- 3. DONATION ANALYTICS DASHBOARD
-- ============================================

-- Query 1: Monthly Donation Trends
SELECT 
    TO_CHAR(donationDate, 'YYYY-MM') AS donation_month,
    COUNT(*) AS donation_count,
    SUM(quantity) AS total_ml,
    COUNT(DISTINCT donorID) AS unique_donors,
    ROUND(AVG(quantity), 2) AS avg_donation_ml,
    ROUND(SUM(quantity) / NULLIF(COUNT(DISTINCT donorID), 0), 2) AS ml_per_donor
FROM DONATION
WHERE donationDate >= ADD_MONTHS(SYSDATE, -12)
AND status = 'Approved'
GROUP BY TO_CHAR(donationDate, 'YYYY-MM')
ORDER BY donation_month;

-- Query 2: Donor Frequency Analysis
SELECT 
    donation_frequency,
    COUNT(*) AS donor_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM (
    SELECT 
        d.donorID,
        COUNT(dn.donationID) AS total_donations,
        CASE 
            WHEN COUNT(dn.donationID) = 1 THEN 'One-time'
            WHEN COUNT(dn.donationID) BETWEEN 2 AND 5 THEN 'Occasional (2-5)'
            WHEN COUNT(dn.donationID) BETWEEN 6 AND 10 THEN 'Regular (6-10)'
            ELSE 'Frequent (10+)'
        END AS donation_frequency
    FROM DONOR d
    LEFT JOIN DONATION dn ON d.donorID = dn.donorID AND dn.status = 'Approved'
    GROUP BY d.donorID
)
GROUP BY donation_frequency
ORDER BY 
    CASE donation_frequency
        WHEN 'One-time' THEN 1
        WHEN 'Occasional (2-5)' THEN 2
        WHEN 'Regular (6-10)' THEN 3
        ELSE 4
    END;

-- Query 3: Blood Type Distribution Analysis
SELECT 
    d.bloodType AS donor_blood_type,
    COUNT(DISTINCT d.donorID) AS donor_count,
    COUNT(dn.donationID) AS total_donations,
    SUM(dn.quantity) AS total_ml_donated,
    ROUND(AVG(dn.quantity), 2) AS avg_donation_ml,
    ROUND(COUNT(dn.donationID) * 100.0 / NULLIF(COUNT(DISTINCT d.donorID), 0), 2) AS donations_per_donor
FROM DONOR d
LEFT JOIN DONATION dn ON d.donorID = dn.donorID AND dn.status = 'Approved'
GROUP BY d.bloodType
ORDER BY donor_count DESC;
