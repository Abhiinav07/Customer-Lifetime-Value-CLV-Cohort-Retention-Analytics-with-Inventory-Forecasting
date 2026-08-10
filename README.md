# Customer Lifetime Value, Cohort Retention & Inventory Forecasting

## Executive Summary
This portfolio project connects **customer value analytics** with **inventory planning** for an online retailer facing churn and peak-season stock-out risk.

The workflow moves from raw transactional data → SQL analytics → Python RFM/CLV/cohort analysis → Excel inventory planning → Power BI executive dashboard.

## Business Questions
1. Which customers generate the most long-term value?
2. Which customer segments are at risk of churn?
3. How does retention change across acquisition cohorts?
4. Which channels/categories drive revenue and profit?
5. Which products need earlier replenishment?
6. How can marketing and inventory decisions be aligned?

## Deliverables
- `data/raw/` — customers, products, orders and inventory data
- `data/processed/` — RFM/CLV, cohort and monthly forecast outputs
- `sql/` — relational schema and 10 analytical queries
- `python/` — notebook for RFM scoring, CLV estimation and cohort heatmap
- `excel/` — inventory planner with forecast/reorder logic
- `powerbi/` — Power BI build guide and data model specification
- `dashboard/` — final dashboard PDF mock/report
- `docs/` — methodology and interview talking points

## Tech Stack
**Python:** pandas, NumPy, Matplotlib, Seaborn, Jupyter  
**SQL:** PostgreSQL-compatible analytical SQL  
**Excel:** forecasting, reorder point, safety stock, conditional planning  
**Power BI:** DAX, Power Query, cross-page filtering, drill-through, KPI cards

## Key Methodology
### RFM
- Recency: days since latest purchase
- Frequency: distinct orders
- Monetary: net revenue
- Customers are scored into quintiles and mapped to actionable segments.

### CLV
A transparent portfolio estimate is used:
`CLV = AOV × Annual Purchase Frequency × Expected Lifetime × Gross Margin`

This is deliberately explainable for business interviews rather than presented as a production-grade probabilistic CLV model.

### Inventory
The planner uses rolling demand averages, lead time, safety stock and reorder-point logic:
`Reorder Point = Lead-Time Demand + Safety Stock`

### Cohorts
Customers are grouped by first-purchase month and tracked by months since acquisition.



## License
MIT License — see `LICENSE`.
