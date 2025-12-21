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
