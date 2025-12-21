##  DATA ARCHITECTURE

### 4.1 Source Systems
| Source System | Data Type | Update Frequency | Latency |
|---------------|-----------|------------------|---------|
| **Transactional Database** | Donor registrations, donations, inventory, requests | Continuous | < 1 second |
| **Lab Systems** | Test results, quality metrics | Batch (hourly) | 1-2 hours |
| **Hospital EMR** | Patient demand, usage patterns | Daily | 24 hours |
| **Mobile Applications** | Donor engagement, appointment data | Continuous | < 5 minutes |
| **External APIs** | Weather, holiday calendars, demographics | Daily | 24 hours |

### 4.2 Data Warehouse Schema

```sql
-- STAR SCHEMA EXAMPLE
-- Fact Tables
CREATE TABLE fact_donation (
    donation_key INT PRIMARY KEY,
    date_key INT,
    donor_key INT,
    staff_key INT,
    blood_type_key INT,
    quantity_ml DECIMAL(10,2),
    test_result VARCHAR(20),
 status VARCHAR(20)
);

CREATE TABLE fact_inventory (
    inventory_key INT PRIMARY KEY,
    date_key INT,
    donation_key INT,
    blood_type_key INT,
    location_key INT,
    quantity_ml DECIMAL(10,2),
    days_to_expiry INT,
    status VARCHAR(20)
);

CREATE TABLE fact_request (
    request_key INT PRIMARY KEY,
    date_key INT,
    hospital_key INT,
    inventory_key INT,
    blood_type_key INT,
    quantity_ml DECIMAL(10,2),
    urgency VARCHAR(20),
    fulfillment_time_hours DECIMAL(5,2)
);
