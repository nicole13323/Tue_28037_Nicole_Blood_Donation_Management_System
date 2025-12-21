----Request Performance Metrics
SELECT 
    TO_CHAR(requestDate, 'YYYY-MM') AS request_month,
    COUNT(*) AS total_requests,
    SUM(CASE WHEN status = 'Fulfilled' THEN 1 ELSE 0 END) AS fulfilled,
    SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending,
    SUM(quantity) AS total_ml_requested,
    AVG(CASE 
        WHEN fulfillmentDate IS NOT NULL AND requestDate IS NOT NULL 
        THEN fulfillmentDate - requestDate 
    END) AS avg_fulfillment_days,
    ROUND(
        SUM(CASE WHEN status = 'Fulfilled' THEN quantity ELSE 0 END) * 100.0 /
        NULLIF(SUM(quantity), 0), 2
    ) AS fulfillment_rate_percent
FROM BLOOD_REQUEST
WHERE requestDate >= ADD_MONTHS(SYSDATE, -6)
GROUP BY TO_CHAR(requestDate, 'YYYY-MM')
ORDER BY request_month;

-----Urgency Level Analysis
SELECT 
    urgency,
    COUNT(*) AS request_count,
    SUM(quantity) AS total_ml_requested,
    ROUND(AVG(quantity), 2) AS avg_request_ml,
    SUM(CASE WHEN status = 'Fulfilled' THEN 1 ELSE 0 END) AS fulfilled_count,
    ROUND(
        SUM(CASE WHEN status = 'Fulfilled' THEN 1 ELSE 0 END) * 100.0 /
        NULLIF(COUNT(*), 0), 2
    ) AS fulfillment_rate,
    AVG(CASE 
        WHEN fulfillmentDate IS NOT NULL 
        THEN fulfillmentDate - requestDate 
    END) AS avg_response_days
FROM BLOOD_REQUEST
WHERE requestDate >= SYSDATE - 90
GROUP BY urgency
ORDER BY 
    CASE urgency
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Normal' THEN 3
        WHEN 'Low' THEN 4
    END;


--  Hospital Request Patterns
SELECT 
    h.name AS hospital_name,
    COUNT(br.requestID) AS total_requests,
    SUM(br.quantity) AS total_ml_requested,
    ROUND(AVG(br.quantity), 2) AS avg_request_ml,
    SUM(CASE WHEN br.status = 'Fulfilled' THEN 1 ELSE 0 END) AS fulfilled_requests,
    ROUND(
        SUM(CASE WHEN br.status = 'Fulfilled' THEN br.quantity ELSE 0 END) * 100.0 /
        NULLIF(SUM(br.quantity), 0), 2
    ) AS fulfillment_rate_percent,
    LISTAGG(DISTINCT br.bloodType, ', ') WITHIN GROUP (ORDER BY br.bloodType) AS blood_types_requested
FROM HOSPITAL h
JOIN BLOOD_REQUEST br ON h.hospitalID = br.hospitalID
WHERE br.requestDate >= ADD_MONTHS(SYSDATE, -6)
GROUP BY h.hospitalID, h.name
ORDER BY total_requests DESC;


-- : Predictive Analytics - Blood Shortage Risk
SELECT 
    bt.bloodType,
    NVL(inv.available_ml, 0) AS current_inventory_ml,
    NVL(don.avg_daily_supply, 0) AS avg_daily_supply_ml,
    NVL(req.avg_daily_demand, 0) AS avg_daily_demand_ml,
    NVL(inv.available_ml, 0) / NULLIF(NVL(req.avg_daily_demand, 0), 0) AS days_of_supply,
    CASE 
        WHEN NVL(inv.available_ml, 0) / NULLIF(NVL(req.avg_daily_demand, 0), 0) < 3 THEN 'CRITICAL'
        WHEN NVL(inv.available_ml, 0) / NULLIF(NVL(req.avg_daily_demand, 0), 0) < 7 THEN 'LOW'
        WHEN NVL(inv.available_ml, 0) / NULLIF(NVL(req.avg_daily_demand, 0), 0) < 14 THEN 'ADEQUATE'
        ELSE 'GOOD'
    END AS inventory_status
FROM (
    SELECT 'O+' AS bloodType FROM DUAL UNION ALL SELECT 'O-' FROM DUAL UNION ALL
    SELECT 'A+' FROM DUAL UNION ALL SELECT 'A-' FROM DUAL UNION ALL
    SELECT 'B+' FROM DUAL UNION ALL SELECT 'B-' FROM DUAL UNION ALL
    SELECT 'AB+' FROM DUAL UNION ALL SELECT 'AB-' FROM DUAL
) bt
LEFT JOIN (
    SELECT bloodType, SUM(quantity) AS available_ml
    FROM BLOOD_INVENTORY
    WHERE status = 'Available'
    AND expiryDate > SYSDATE
    GROUP BY bloodType
) inv ON bt.bloodType = inv.bloodType
LEFT JOIN (
    SELECT bloodType, AVG(daily_quantity) AS avg_daily_supply
    FROM (
        SELECT bloodType, donationDate, SUM(quantity) AS daily_quantity
        FROM DONATION
        WHERE donationDate >= SYSDATE - 90
        AND status = 'Approved'
        GROUP BY bloodType, donationDate
    )
    GROUP BY bloodType
) don ON bt.bloodType = don.bloodType
LEFT JOIN (
    SELECT bloodType, AVG(daily_quantity) AS avg_daily_demand
