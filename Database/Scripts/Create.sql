-- Create DONOR table
CREATE TABLE DONOR (
    donorID NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    bloodType VARCHAR2(5) NOT NULL CHECK (bloodType IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    dateOfBirth DATE NOT NULL,
    address VARCHAR2(200),
    registrationDate DATE DEFAULT SYSDATE NOT NULL,
    lastDonationDate DATE,
    CONSTRAINT chk_donor_age CHECK (MONTHS_BETWEEN(SYSDATE, dateOfBirth)/12 >= 18)
);

-- Create STAFF table
CREATE TABLE STAFF (
    staffID NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    position VARCHAR2(50) NOT NULL,
    department VARCHAR2(50) NOT NULL,
    hireDate DATE DEFAULT SYSDATE NOT NULL
);
-- Create DONATION table
CREATE TABLE DONATION (
    donationID NUMBER(10) PRIMARY KEY,
    donorID NUMBER(10) NOT NULL,
    staffID NUMBER(10) NOT NULL,
    donationDate DATE DEFAULT SYSDATE NOT NULL,
    bloodType VARCHAR2(5) NOT NULL CHECK (bloodType IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    quantity NUMBER(5,2) NOT NULL CHECK (quantity BETWEEN 250 AND 500),
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Tested', 'Approved', 'Rejected', 'Expired')),
    testResults VARCHAR2(20) CHECK (testResults IN ('Pass', 'Fail', 'Pending')),
    expiryDate DATE NOT NULL,
    CONSTRAINT fk_donation_donor FOREIGN KEY (donorID) REFERENCES DONOR(donorID),
    CONSTRAINT fk_donation_staff FOREIGN KEY (staffID) REFERENCES STAFF(staffID)
);
-- Create BLOOD_INVENTORY table
CREATE TABLE BLOOD_INVENTORY (
    inventoryID NUMBER(10) PRIMARY KEY,
    donationID NUMBER(10) NOT NULL,
    bloodType VARCHAR2(5) NOT NULL CHECK (bloodType IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    quantity NUMBER(5,2) NOT NULL CHECK (quantity > 0),
    expiryDate DATE NOT NULL,
    location VARCHAR2(50) NOT NULL,
    status VARCHAR2(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Reserved', 'Transfused', 'Expired', 'Discarded')),
    CONSTRAINT fk_inventory_donation FOREIGN KEY (donationID) REFERENCES DONATION(donationID)
);

-- Create HOSPITAL table
CREATE TABLE HOSPITAL (
    hospitalID NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    address VARCHAR2(200) NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    phone VARCHAR2(20) NOT NULL,
  -- Create indexes for better performance
CREATE INDEX idx_donor_bloodtype ON DONOR(bloodType);
CREATE INDEX idx_donation_date ON DONATION(donationDate);
CREATE INDEX idx_inventory_expiry ON BLOOD_INVENTORY(expiryDate, status);
CREATE INDEX idx_request_status ON BLOOD_REQUEST(status, urgency);
CREATE INDEX idx_donation_status ON DONATION(status);
