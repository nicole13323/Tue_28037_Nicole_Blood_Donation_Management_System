-- data retrieval
-- 1.1 Get All Donors with Registration Details
SELECT donorID, name, email, phone, bloodType,
       TO_CHAR(dateOfBirth, 'DD-MON-YYYY') AS birth_date,
       address,
       TO_CHAR(registrationDate, 'DD-MON-YYYY') AS registered_date,
       TO_CHAR(lastDonationDate, 'DD-MON-YYYY') AS last_donation,
       CASE 
           WHEN lastDonationDate IS NULL THEN 'Never donated'
           WHEN MONTHS_BETWEEN(SYSDATE, lastDonationDate) > 6 THEN 'Eligible'
           ELSE 'Not eligible (recent donation)'
       END AS eligibility_status
FROM DONOR
ORDER BY donorID;

-- 1.2 Get All Staff Members
SELECT staffID, name, email, phone, position, department,
       TO_CHAR(hireDate, 'DD-MON-YYYY') AS hired_date,
       ROUND(MONTHS_BETWEEN(SYSDATE, hireDate)/12, 1) AS years_of_service
FROM STAFF
ORDER BY department, position;

-- 1.3 Get All Donations with Details
SELECT d.donationID, d.donorID, dn.name AS donor_name,
       d.staffID, s.name AS staff_name,
       TO_CHAR(d.donationDate, 'DD-MON-YYYY') AS donation_date,
       d.bloodType, d.quantity,
       d.status, d.testResults,
       TO_CHAR(d.expiryDate, 'DD-MON-YYYY') AS expiry_date,
       ROUND(d.expiryDate - SYSDATE) AS days_until_expiry
FROM DONATION d
JOIN DONOR dn ON d.donorID = dn.donorID
JOIN STAFF s ON d.staffID = s.staffID
ORDER BY d.donationDate DESC;

-- 1.4 Get Blood Inventory Status
SELECT inventoryID, donationID, bloodType, quantity,
       TO_CHAR(expiryDate, 'DD-MON-YYYY') AS expiry_date,
       location, status,
       ROUND(expiryDate - SYSDATE) AS days_remaining,
       CASE 
           WHEN expiryDate < SYSDATE THEN 'EXPIRED'
           WHEN expiryDate BETWEEN SYSDATE AND SYSDATE + 7 THEN 'EXPIRING SOON'
           WHEN status = 'Available' THEN 'READY FOR USE'
           ELSE status
       END AS alert_status
FROM BLOOD_INVENTORY
ORDER BY expiryDate, status;

-- 1.5 Get All Blood Requests
SELECT r.requestID, h.name AS hospital_name,
       r.bloodType, r.quantity,
       r.urgency,
       TO_CHAR(r.requestDate, 'DD-MON-YYYY HH24:MI') AS requested_at,
       TO_CHAR(r.fulfillmentDate, 'DD-MON-YYYY HH24:MI') AS fulfilled_at,
       r.status,
       CASE 
           WHEN r.fulfillmentDate IS NOT NULL 
           THEN ROUND((r.fulfillmentDate - r.requestDate) * 24, 2)
           ELSE NULL
       END AS hours_to_fulfill
FROM BLOOD_REQUEST r
JOIN HOSPITAL h ON r.hospitalID = h.hospitalID
ORDER BY r.requestDate DESC;

-- 1.6 Get All Audit Log Entries
SELECT auditID, table_name, operation_type, record_id,
       TO_CHAR(operation_date, 'DD-MON-YYYY HH24:MI:SS') AS operation_time,
       user_name, ip_address, status,
       SUBSTR(error_message, 1, 50) AS error_preview
FROM AUDIT_LOG
ORDER BY auditID DESC;
