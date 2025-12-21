## 2. KEY PERFORMANCE INDICATORS (KPIs)

### 2.1 Inventory Management KPIs
| KPI | Calculation | Target | Alert Threshold |
|-----|-------------|---------|-----------------|
| **Blood Wastage Rate** | `(Expired Units / Total Inventory) × 100` | < 2% | > 3% |
| **Inventory Turnover Ratio** | `Total Requests Fulfilled / Average Inventory` | > 8 times/month | < 6 times/month |
| **Critical Blood Availability** | `O- Units Available / Total O- Requests` | > 95% | < 90% |
| **Average Inventory Age** | `AVG(SYSDATE - Donation Date)` | < 21 days | > 28 days |
| **Stock-Out Frequency** | `COUNT(Days with zero inventory per blood type)` | 0/month | > 2/month |

### 2.2 Operational Efficiency KPIs
| KPI | Calculation | Target | Alert Threshold |
|-----|-------------|---------|-----------------|
| **Request Fulfillment Rate** | `(Fulfilled Requests / Total Requests) × 100` | > 98% | < 95% |
| **Average Fulfillment Time** | `AVG(Fulfillment Date - Request Date)` | < 4 hours | > 6 hours |
| **Critical Request Time** | `AVG(Fulfillment Date - Request Date WHERE urgency='Critical')` | < 2 hours | > 3 hours |
| **Testing Efficiency** | `AVG(Test Completion Date - Donation Date)` | < 24 hours | > 36 hours |
| **System Uptime** | `(24×7 - Downtime minutes) / (24×7) × 100` | > 99.5% | < 99% |

### 2.3 Donor Management KPIs
| KPI | Calculation | Target | Alert Threshold |
|-----|-------------|---------|-----------------|
| **Donor Retention Rate** | `(Repeat Donors / Total Donors) × 100` | > 60% | < 50% |
| **New Donor Acquisition** | `COUNT(Donors with first donation in last 30 days)` | > 100/month | < 75/month |
| **Donor Return Interval** | `AVG(Days between donations for repeat donors)` | < 90 days | > 120 days |
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

