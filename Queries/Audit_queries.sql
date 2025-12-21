---- first off all i created holidays table 
----- and then i inserted the holidays
----then create audits:
----1. Create Audit Log Table
CREATE TABLE AUDIT_LOG (
    auditID NUMBER(10) PRIMARY KEY,
    table_name VARCHAR2(50) NOT NULL,
    operation_type VARCHAR2(10) CHECK (operation_type IN ('INSERT', 'UPDATE', 'DELETE')),
    record_id VARCHAR2(100),
    old_values CLOB,
    new_values CLOB,
    user_name VARCHAR2(100) DEFAULT USER,
    operation_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    ip_address VARCHAR2(50),
    status VARCHAR2(20) DEFAULT 'SUCCESS' CHECK (status IN ('SUCCESS', 'DENIED', 'ERROR')),
    error_message VARCHAR2(4000)
);

CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1;

-- 2: Create Audit Logging Function
CREATE OR REPLACE FUNCTION log_audit_trail(
    p_table_name IN VARCHAR2,
    p_operation IN VARCHAR2,
    p_record_id IN VARCHAR2,
    p_old_values IN CLOB DEFAULT NULL,
    p_new_values IN CLOB DEFAULT NULL,
    p_status IN VARCHAR2 DEFAULT 'SUCCESS',
    p_error_msg IN VARCHAR2 DEFAULT NULL
) RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_audit_id NUMBER;
    v_ip_address VARCHAR2(50);
BEGIN
    -- Get IP address (simplified)
    SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') INTO v_ip_address FROM DUAL;
    
    -- Insert audit record
SELECT audit_seq.NEXTVAL INTO v_audit_id FROM DUAL;
    
    INSERT INTO AUDIT_LOG (
        auditID, table_name, operation_type, record_id,
        old_values, new_values, user_name, operation_date,
        ip_address, status, error_message
    ) VALUES (
        v_audit_id, p_table_name, p_operation, p_record_id,
        p_old_values, p_new_values, USER, SYSTIMESTAMP,
        v_ip_address, p_status, p_error_msg
    );
    
    COMMIT;
    RETURN v_audit_id;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END log_audit_trail;
/
---and then Create Restriction Check Function
    
    
  -- Test  Check successful audit entries
SELECT 
    auditID,
    table_name,
    operation_type,
    record_id,
    TO_CHAR(operation_date, 'DD-MON-YYYY HH24:MI:SS') AS operation_time,
    status,
    error_message
FROM AUDIT_LOG
ORDER BY auditID DESC;
-- Test : Test BLOOD_INVENTORY audit trigger
BEGIN
    -- This should be logged
    UPDATE BLOOD_INVENTORY
    SET status = 'Reserved'
    WHERE inventoryID = 1;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Update completed - check audit log');
END;
/
-- Test : Check audit log for denied attempt
SELECT * FROM AUDIT_LOG 
WHERE status = 'DENIED'
ORDER BY operation_date DESC;
-- : Audit Summary by Day
SELECT 
    TRUNC(operation_date) AS audit_date,
    table_name,
    operation_type,
    status,
    COUNT(*) AS operation_count,
    LISTAGG(DISTINCT user_name, ', ') WITHIN GROUP (ORDER BY user_name) AS users
FROM AUDIT_LOG
WHERE operation_date >= SYSDATE - 30
GROUP BY TRUNC(operation_date), table_name, operation_type, status
ORDER BY audit_date DESC, table_name;
