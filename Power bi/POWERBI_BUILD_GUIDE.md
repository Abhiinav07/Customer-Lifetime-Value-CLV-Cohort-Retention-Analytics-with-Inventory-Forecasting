# Power BI Dashboard Build Guide

## Data Sources
Load:
- `data/raw/orders.csv`
- `data/raw/customers.csv`
- `data/raw/products.csv`
- `data/raw/inventory_monthly.csv`
- `data/processed/customer_rfm_clv.csv`
- `data/processed/cohort_retention.csv`
- `data/processed/monthly_sales_forecast.csv`

## Recommended Model
- Customers 1 → * Orders
- Products 1 → * Orders
- Products 1 → * Inventory
- Customers 1 → * Customer_RFM_CLV
- Date 1 → * Orders / Inventory / Forecast

Create a proper Date table:
```DAX
Date = CALENDAR(DATE(2024,1,1), DATE(2026,12,31))
```

## Core Measures
```DAX
Revenue = SUM(Orders[net_sales])

Gross Profit = SUM(Orders[gross_profit])

Orders Count = DISTINCTCOUNT(Orders[order_id])

Customers = DISTINCTCOUNT(Orders[customer_id])

AOV = DIVIDE([Revenue], [Orders Count])

Repeat Customers =
COUNTROWS(
    FILTER(
        VALUES(Orders[customer_id]),
        CALCULATE(DISTINCTCOUNT(Orders[order_id])) > 1
    )
)

Repeat Rate = DIVIDE([Repeat Customers], [Customers])

Average CLV = AVERAGE(Customer_RFM_CLV[estimated_clv])

At Risk Customers =
CALCULATE(
    DISTINCTCOUNT(Customer_RFM_CLV[customer_id]),
    Customer_RFM_CLV[customer_segment] = "At Risk"
)
```

## Page Design
### 1. Executive Overview
KPI cards: Revenue, Gross Profit, Customers, AOV, Repeat Rate, Average CLV.
Charts: monthly revenue/profit, category revenue, acquisition-channel revenue.
Slicers: date, region, category, channel.

### 2. Customer Value
Visuals: RFM segment bar chart, CLV distribution, revenue by segment, high-value-at-risk table.
Use drill-through on Customer ID.

### 3. Cohort Retention
Matrix: Cohort Month × Cohort Age with retention %.
Line chart: average retention by cohort age.
Slicers: acquisition channel and region.

### 4. Inventory & Forecast
Visuals: monthly demand/revenue forecast, product reorder alerts, stock coverage, category stock risk.
Conditional formatting: highlight REORDER/WATCH products.

## Cross-Page Filtering
Sync slicers for Date, Region, Category and Acquisition Channel across pages.
Use Edit Interactions to make KPI and charts respond consistently.

## Automated Insights
Use Power BI's anomaly detection on monthly revenue.
Add a decomposition tree for Revenue → Category → Channel → Customer Segment.
