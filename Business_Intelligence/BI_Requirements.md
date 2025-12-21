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
