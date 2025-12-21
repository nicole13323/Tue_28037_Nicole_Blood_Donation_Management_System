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
