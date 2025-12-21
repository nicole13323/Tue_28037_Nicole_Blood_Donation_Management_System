# Business Intelligence Requirements
## Blood Donation Management System
**Document Version:** 1.0  
**Last Updated:** December 19, 2024  
**Author:** IRADUKUNDA nicole 28037  
**Course:** INSY 8311 - Database Development with PL/SQL  
**Institution:** Adventist University of Central Africa (AUCA)

---

## 1. EXECUTIVE OVERVIEW

### 1.1 Business Context
The Blood Donation Management System collects, processes, and distributes blood donations across multiple hospitals in Rwanda. With increasing demand for blood products and strict regulatory requirements, there is a critical need to transform operational data into actionable intelligence for strategic decision-making.

### 1.2 BI Vision & Objectives
Transform transactional blood donation data into strategic insights that:
- **Optimize** blood inventory levels and reduce wastage
- **Accelerate** emergency response times for critical requests
- **Enhance** donor retention and recruitment strategies
- **Ensure** compliance with regulatory and safety standards
- **Improve** operational efficiency across the donation-to-transfusion lifecycle

### 1.3 Target Stakeholders
| Role | Primary BI Needs | Access Frequency |
|------|------------------|------------------|
| **Blood Bank Manager** | Inventory optimization, demand forecasting, cost analysis | Daily |
| **Hospital Coordinator** | Request fulfillment status, blood availability, emergency alerts | Real-time |
| **Medical Director** | Quality metrics, compliance reports, performance trends | Weekly |
| **Lab Technician** | Inventory status, expiry alerts, testing backlogs | Multiple times daily |
| **Donor Relations Officer** | Donor engagement metrics, campaign effectiveness | Weekly |
| **System Administrator** | Audit logs, security violations, user activity | As needed |

---


| **Donor Satisfaction Score** | `(Survey Score / Total Possible) × 100` | > 85% | < 75% |
| **Eligible Donor Pool** | `COUNT(Donors eligible to donate today)` | > 500 | < 300 |

### 2.4 Financial & Compliance KPIs
| KPI | Calculation | Target | Alert Threshold |
|-----|-------------|---------|-----------------|
| **Cost per Unit** | `Total Operational Cost / Units Processed` | < RWF 15,000 | > RWF 18,000 |
| **Regulatory Compliance** | `(Compliant Processes / Total Processes) × 100` | 100% | < 99% |
| **Audit Resolution Time** | `AVG(Resolution Date - Audit Date)` | < 3 days | > 5 days |
| **Data Accuracy Rate** | `(Accurate Records / Total Records) × 100` | > 99.9% | < 99.5% |

---

## 3. DASHBOARD SPECIFICATIONS

### 3.1 Executive Command Center
**Purpose:** Strategic overview for senior management
**Refresh Rate:** Real-time (15-minute intervals)
**Primary Users:** Medical Director, Blood Bank Manager

**Widgets & Visualizations:**
1. **KPI Summary Cards** (6 cards)
   - Current Available Inventory (liters)
   - Today's Donations Count
   - Pending Critical Requests
   - Month-to-date Fulfillment Rate
   - Current Wastage Rate
   - System Health Status

2. **Supply-Demand Balance Chart**
   - Line chart: Daily donations vs. requests (30-day trend)
   - Area chart: Inventory levels by blood type

3. **Geographic Heat Map**
   - Hospital locations with request volumes
   - Donation center performance metrics

4. **Alert Ticker**
   - Real-time alerts for critical thresholds
   - Expiry warnings (24-hour notice)

### 3.2 Inventory Control Dashboard
**Purpose:** Daily operational management
**Refresh Rate:** Near real-time (5-minute intervals)
**Primary Users:** Lab Technicians, Inventory Managers

**Widgets & Visualizations:**
1. **Inventory Aging Report**
   - Table: Units grouped by days to expiry
   - Color coding: Red (<7 days), Yellow (7-14 days), Green (>14 days)

2. **Blood Type Matrix**
   - Grid view: All blood types with current stock, ideal stock, variance
   - Trend arrows: 7-day movement direction

3. **Location Status Board**
   - Storage unit monitoring (temperature, capacity)
   - Transfer requests pending

4. **Expiry Forecast**
   - Predictive chart: Expected expirations next 7 days
   - Action recommendations

### 3.3 Donor Analytics Dashboard
**Purpose:** Donor relationship management
**Refresh Rate:** Daily
**Primary Users:** Donor Relations Officers, Marketing Team

**Widgets & Visualizations:**
1. **Donor Cohort Analysis**
   - Retention curves by acquisition month
   - Lifetime value projections

2. **Demographic Segmentation**
   - Donor distribution by age, gender, location
   - Blood type prevalence analysis

3. **Campaign Performance**
   - Response rates by channel (SMS, email, social)
   - Cost per acquired donor

4. **Eligibility Calendar**
   - Daily count of donors becoming eligible
   - Automated reminder scheduling

### 3.4 Compliance & Audit Dashboard
**Purpose:** Regulatory and security monitoring
**Refresh Rate:** Real-time
**Primary Users:** System Administrators, Quality Assurance

**Widgets & Visualizations:**
1. **Audit Trail Monitor**
   - Live feed of system changes
   - User activity heatmap

2. **Rule Violation Analysis**
   - Weekday/holiday restriction breaches
   - Pattern detection for suspicious activity

3. **Compliance Checklist**
   - Daily/weekly/monthly compliance tasks
   - Automated verification status

4. **Security Incident Log**
   - Failed access attempts
   - Data modification alerts

---

## 4. DATA ARCHITECTURE

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

-- Dimension Tables
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_number INT,
    week_number INT,
    month_number INT,
    quarter_number INT,
    year_number INT,
    is_weekend CHAR(1),
    is_holiday CHAR(1),
    holiday_name VARCHAR(50)
);

CREATE TABLE dim_donor (
    donor_key INT PRIMARY KEY,
    donor_id INT,
    blood_type VARCHAR(5),
    age_group VARCHAR(20),
    gender CHAR(1),
    location VARCHAR(100),
    donor_segment VARCHAR(30),
    first_donation_date DATE,
    last_donation_date DATE,
    total_donations INT
);

CREATE TABLE dim_hospital (
    hospital_key INT PRIMARY KEY,
    hospital_id INT,
    name VARCHAR(100),
    type VARCHAR(30),
    location VARCHAR(100),
    bed_count INT,
    contact_person VARCHAR(100)
);
